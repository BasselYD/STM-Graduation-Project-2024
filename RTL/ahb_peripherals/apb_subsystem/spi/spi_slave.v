//////////////////////////////////////////////////////////////////////////////////
								/*SPI_Slave*/
//////////////////////////////////////////////////////////////////////////////////
/*
CONFIG_REG[7] when it low >>>>>>>>>>> FULL_DUPLEX_SPI
CONFIG_REG[7] when it high >>>>>>>>>> HALF_DUPLEX_SPI
*/
//////////////////////////////////////////////////////////////////////////////////

module SPI_Slave
(
	input 				PRESETn,
	input				PCLK,
	input				MOSI,
	input 				SCK,    // input from other chip
	input 				SS,     // input from other chip 
	input 				SEL_DATA_Slave,
	input				Clear,
	input               SEL_DATA,
	input       [15:0]  CONFIG_REG,
	input       [7:0]   DATA_SHIFT_REG,
	input 		[1:0]   SPI_INT_CLR,
	output reg	[1:0]   SPI_INT, 
	output reg  [7:0]   RX_REG ,
	output wire			MOSI_half_duplex, 
	/*
	in case of half duplex there is only one common wire for the tx and rx data.
	in the spi_top.v will be more clear thet the input and output use the same wire.
	*/ 
	output wire         MISO //it is considered not connected in case of half duplex
);

wire   SPI_EN ;
assign SPI_EN = CONFIG_REG[10] ;

reg 		SHIFT_IN  ;
reg [7:0] 	SHIFT_REG ;

reg 		SHIFT_IN_PEDGE  ;
reg [7:0] 	SHIFT_REG_PEDGE ;

reg 		SHIFT_IN_NEDGE  ;
reg [7:0] 	SHIFT_REG_NEDGE ;

wire [1:0] 	MODE ;

//the used flag to control the Receiving Data Register
reg clear_flag ;

//Flag and pulses for indication that there is transmission session ans alarming for asserting the tx_interrupt
reg tx_alarm ;
reg int_flag ;
reg pul ;
wire TXINT_PULSE; 

// douple sync registers for RX register (receiving data)
reg [7:0] sync0, sync1 ;

// flags needed for updating the register with the data to be transmitted
reg Flag_PEDGE,  Flag_NEDGE;

////////////////////////////////////////* RX Interrupt *///////////////////////////////////////////

always @ (posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		SPI_INT[1] = 'b0 ;
	else if(RX_REG != 0 && int_flag && CONFIG_REG[6] == 0 && CONFIG_REG[9] == 1 && SPI_INT_CLR[1] == 0)
		SPI_INT[1] = 1'b1 ;
	else if(SPI_INT_CLR[1]==1 && CONFIG_REG[6] == 0 && CONFIG_REG[9] == 1)
		SPI_INT[1] = 'b0 ;
	else
		SPI_INT[1] = 'b0 ;
end

// generatting flag based on the rx_interrupt to avoid re-update the RX_REG after clearing the rx_interrupt

always @ (posedge PCLK or negedge SS)
begin
  	if (!SS)
		clear_flag <= 1'b0 ; // the RX_INT has been cleared
	else if (Clear)
		clear_flag <= 1'b1 ;
end

////////////////////////////////////* TX Interrupt *//////////////////////////////////////////////

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
        begin
        pul <= 1'b0;
        end
    else if (SS==1)
        begin
        pul <= 1'b1;
        end
    else
        begin
        pul <= 1'b0;
        end
end

assign TXINT_PULSE = (~pul & SS) ? 'b1 : 'b0; 

always @ (posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		int_flag <= 1'b0 ;
	else if(TXINT_PULSE)
		int_flag <= 1 ;
	else if (SPI_INT_CLR[0])
		int_flag <= 0 ;
	else if (!SS)
		int_flag <= 0 ;
end

always@(*)
begin
	if(int_flag && CONFIG_REG[6] == 0 && CONFIG_REG[8] == 1 && SPI_INT_CLR[0] == 0 && CONFIG_REG[7] == 0 ) 
	SPI_INT[0] = 'b1 ;
	else if(int_flag && CONFIG_REG[6] == 0 && CONFIG_REG[8] == 1 && SPI_INT_CLR[0] == 0 && CONFIG_REG[11] == 0 && CONFIG_REG[7] == 1) 
	SPI_INT[0] = 'b1 ;
	else if(SPI_INT_CLR[0] == 1 && CONFIG_REG[6] == 0 && CONFIG_REG[8] == 1)
	SPI_INT[0] = 'b0 ;
	else
	SPI_INT[0] = 'b0 ;
end

// Flag for indication that there is transmission session ans alarming for asserting the tx_interrupt
always @ (posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		tx_alarm <= 1'b0 ;
  	else if (SEL_DATA)
  		tx_alarm <= 1'b1 ;
  	else if (SPI_INT_CLR[0]) // no need for this alarm after clearing the tx_interrupt to could use it again when ther is another session
  		tx_alarm <= 1'b0 ;
end

 /////////////////////////////////////////////* SPI OUTPUT */////////////////////////////////////////////////////////

assign MISO = (SPI_EN && !SS && (CONFIG_REG[7] == 0)) ? SHIFT_REG[7] :1'b0 ; //Full Duplex           
assign MOSI_half_duplex = (SPI_EN && !SS && (CONFIG_REG[7] == 1) && (CONFIG_REG[11] == 0)) ? SHIFT_REG[7] :1'b0 ; // half duplex

////////////////////////////////////////////////Clock Mode///////////////////////////////////////////////////////////////

assign MODE   = CONFIG_REG[5:4] ; //Clock phase and ploarity 

/*
	CONFIG_REG[4] ---> CPHA
	CONFIG_REG[5] ---> CPOL
*/

////////////////////////////////////////* Receive Register Douple Synchronizer */////////////////////////////////////////

always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
	  sync0  <= 'b0 ;
	  sync1  <= 'b0 ;
	  RX_REG <= 'b0 ;
	end
	else if (SS && ! clear_flag) // update the Receiver Register with the Received Data after triggering the slave slector from low to high
	begin
	  sync0  <= SHIFT_REG ;
	  sync1  <= sync0     ;
	  RX_REG <= sync1     ;
	end 
	else if (clear_flag)// for avoid updating with the transmited data while the slave is active and transmit or during the receiving process
	begin 
	  sync0  <= 'b0 ;
	  sync1  <= 'b0 ;
	  RX_REG <= 'b0 ;	  
	end 
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @(*) 
begin
	if(MODE==2'b00 || MODE==2'b11)
	SHIFT_REG = SHIFT_REG_NEDGE ;
	else if(MODE==2'b10 || MODE==2'b01)
	SHIFT_REG = SHIFT_REG_PEDGE ;
	else
	SHIFT_REG = 'b0 ;
end

always @(*) 
begin
	if(MODE==2'b00 || MODE==2'b11)
	SHIFT_IN = SHIFT_IN_PEDGE ;
	else if(MODE==2'b10 || MODE==2'b01)
	SHIFT_IN = SHIFT_IN_NEDGE ;
	else
	SHIFT_IN = 'b0 ;
end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// for updating the register with the data to be transmitted

always @ (posedge SCK or posedge SEL_DATA_Slave)
begin
  if(SEL_DATA_Slave)
  Flag_PEDGE <= 'b1 ;
  else 
  Flag_PEDGE <= 'b0 ;
end

always @ (negedge SCK or posedge SEL_DATA_Slave)
begin
  if(SEL_DATA_Slave)
  Flag_NEDGE <= 'b1 ;
  else 
  Flag_NEDGE <= 'b0 ;
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge SCK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		SHIFT_IN_PEDGE  <= 'b0 ;
		SHIFT_REG_PEDGE <= 'b0 ;
	end
	else if (Flag_PEDGE)
	begin
	SHIFT_REG_PEDGE <= DATA_SHIFT_REG ;
	SHIFT_IN_PEDGE  <= MOSI ;
	end
	else if(SS==0 && !CONFIG_REG[6] && SPI_EN )
	begin
	case(MODE)
	2'b00 :
	begin
		SHIFT_IN_PEDGE <= MOSI ;
	end
	2'b01 :
	begin
		SHIFT_REG_PEDGE    <= SHIFT_REG_PEDGE << 1 ;
	    SHIFT_REG_PEDGE[0] <= SHIFT_IN_NEDGE;
	end
	2'b10 :
	begin
		SHIFT_REG_PEDGE    <= SHIFT_REG_PEDGE << 1 ;
	    SHIFT_REG_PEDGE[0] <= SHIFT_IN_NEDGE ;
	end
	2'b11 :
	begin
		SHIFT_IN_PEDGE <= MOSI ;
	end
	endcase
	end
end


always @ (negedge SCK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		SHIFT_IN_NEDGE  <= 'b0 ;
		SHIFT_REG_NEDGE <= 'b0 ;
	end
	else if (Flag_NEDGE)
	begin
	SHIFT_REG_NEDGE <= DATA_SHIFT_REG;
	SHIFT_IN_NEDGE  <= MOSI ;
	end
	else if(SS==0 && !CONFIG_REG[6] && SPI_EN)
	begin
	case(MODE)
	2'b00 :
	begin
		SHIFT_REG_NEDGE    <= SHIFT_REG_NEDGE << 1 ;
	   	SHIFT_REG_NEDGE[0] <= SHIFT_IN_PEDGE ;
	end
	2'b01 :
	begin
		SHIFT_IN_NEDGE <= MOSI ;
	end
	2'b10 :
	begin
		SHIFT_IN_NEDGE <= MOSI ;
	end
	2'b11 :
	begin
		SHIFT_REG_NEDGE    <= SHIFT_REG_NEDGE << 1 ;
	   	SHIFT_REG_NEDGE[0] <= SHIFT_IN_PEDGE ;
	end
	endcase
	end	
end

endmodule