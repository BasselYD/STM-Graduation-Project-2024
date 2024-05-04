//////////////////////////////////////////////////////////////////////////////////
									/*SPI_MASTER*/ 
// The module is designed by 									
// Engineer: Péntek Róbert Gergő
// we re-built and re-designed the module with major edits for synthesis

//////////////////////////////////////////////////////////////////////////////////
/*
CONFIG_REG[7] when it low >>>>>>>>>>> FULL_DUPLEX_SPI
CONFIG_REG[7] when it high >>>>>>>>>> HALF_DUPLEX_SPI
*/
//////////////////////////////////////////////////////////////////////////////////

module SPI_Master
(
	input 				PRESETn,
	input 				PCLK,

	input 				SEL_DATA,
	input 				SEL_CMD,
	input				Clear,
	input  		[15:0] 	CONFIG_REG,
	output reg 	[7:0] 	RX_REG,
	output reg 	[1:0] 	SPI_INT,
	output				RX_PULSE,
	input  		[1:0] 	SPI_INT_CLR, 
	input  		[7:0] 	DATA_SHIFT_REG,
	//SPI_MASTER
	input 				MISO_half_duplex,
	/*
	in case of half duplex there is only one common wire for the tx and rx data.
	in the spi_top.v will be more clear thet the input and output use the same wire.
	*/ 
	input 				MISO,
	output 	 			MOSI, 
	output reg  		SCK,
	
	output reg 			SS0,
	output reg 			SS1,
	output reg 			SS2,
	output reg 			SS3
);

wire   SPI_EN;
assign SPI_EN = CONFIG_REG[10] ;
	
////////////////////////SPI_MASTER
	reg 	  SHIFT_IN;
	reg [7:0] SHIFT_REG;
	reg CMD; // representing the commond which trigger the FSM from its idle state

	reg[1:0] STATE;    // fsm states
	reg[4:0] SCK_CNT; // the counter of the clock ,it counts with every pos and neg edge of the clock
	
////////////////////////clock generator
	reg [3:0] 	counter;
	reg [3:0] 	divider;
	reg 		SCK_ENABLE;
	reg 		SPI_CLK;
	
//////////////////// P/N EDGE 
	reg			d_ffp;
	reg			d_ffn;
	wire		P_EDGE;
	wire		N_EDGE;
//////////////////////////
	reg 		Tx_int_en ;

	reg 		RX_DFF; // reg used to generate pulse with the session end 

	reg 		int_flag ;
	reg 		clear_flag ; //flag for clearing the interrupts and the receiving data register after reading the data as expected

//////////////////////////////////////////////////////////////////Gray Encoding
  localparam [1:0] IDLE     	= 2'b00,
                   CONFIGURE   	= 2'b01,
                   TRANSFER 	= 2'b11,
                   TRANSFER_END = 2'b10;
//////////////////////////////////////////////////////////////////

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		CMD <= 'b0 ;
	end
	else if (SEL_CMD && CONFIG_REG[6])
	begin
		CMD <= CONFIG_REG[10] ;	
	end
	else if(STATE == CONFIGURE)
	begin
		CMD <='b0;
	end 
end


////////////////////////////////////////////////Clock Mode///////////////////////////////////////////////////////////////

wire [1:0] MODE ;

assign MODE = CONFIG_REG[5:4] ;	
/*
	CONFIG_REG[4] ---> CPHA
	CONFIG_REG[5] ---> CPOL
*/

////////////////////////////////////////////////////////clock_divider/////////////////////////////////////////////////////////

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		divider<=4'b0000;
	end
	else if(STATE == CONFIGURE)
	begin
		case(CONFIG_REG[1:0])
		2'b00: divider<=4'b0001;
		2'b01: divider<=4'b0011;
		2'b10: divider<=4'b0111;
		2'b11: divider<=4'b1111;
		endcase
	end
end

////////////////////////////////////////////////SPI CLK GENERATOR///////////////////////////////////////////////////////////////

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		SPI_CLK<='b0;
		counter<= 4'b0000;
	end
	else if(STATE==IDLE && CMD)
		SPI_CLK<=CONFIG_REG[5]; // clock polarity
	else if(STATE==CONFIGURE)
		counter<= 4'b0000;
	else if(SCK_ENABLE==1)
	begin
		if(counter==divider)
		begin
			counter<=4'b0000;
			SPI_CLK<= ~SPI_CLK;
		end
		else
		begin
			counter<=counter+1'b1;
		end
	end
end

// based on the next 2 always blocks generate the falling and rising edges of the spi_clock

always @(posedge PCLK)
begin
	if(SCK_ENABLE==1)
	begin
		if(PRESETn==0)
		begin
			d_ffp<=1'b0;
		end
		else if (SPI_CLK==1)
		begin
			d_ffp<=1'b1;
		end
		else
		begin
			d_ffp<=1'b0;
		end
	end
end

assign P_EDGE=SCK_ENABLE? (~d_ffp & SPI_CLK): 1'b0; // Positive edge
	
always @(posedge PCLK)
begin
	if(SCK_ENABLE==1)
	begin
		if(PRESETn==0)
		begin
			d_ffn<=1'b0;
		end
		else if (SPI_CLK==0)
		begin
			d_ffn<=1'b1;
		end
		else
		begin
			d_ffn<=1'b0;
		end
	end
end
	
assign N_EDGE=SCK_ENABLE? (~d_ffn & ~SPI_CLK): 1'b0; // Negativ edge
	
// SCK generator

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		SCK<=1'b0;
	end
	else if(SCK_ENABLE==1)
	begin
		if(P_EDGE)
		begin
			SCK    <= 1'b1;
		end
		else if(N_EDGE)
		begin
			SCK    <= 1'b0;
		end
	end
	else
	begin
		SCK<=1'b0;
	end
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

reg capture ; // that signal based on it, the whole process of the tx & rx starts

always @ (posedge PCLK or negedge PRESETn)
begin
  if(!PRESETn)
  capture <= 'b0 ;
  else if (P_EDGE && (MODE == 1 || MODE == 2))
  capture <= 'b1 ;
  else if (N_EDGE && (MODE == 0 || MODE == 3))
  capture <= 'b1 ;
  else if (STATE==TRANSFER_END)
  capture <= 'b0 ;
end

/////////////////////////////////////////Slave_Selector//////////////////////////////////////

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		SS0<=1;
		SS1<=1;
		SS2<=1;
		SS3<=1;
	end
	else if(STATE == CONFIGURE) 
	begin
		case (CONFIG_REG[3:2])
		2'b00: SS0<=0;
		2'b01: SS1<=0;
		2'b10: SS2<=0;
		2'b11: SS3<=0;
		endcase
	end
	else if (STATE == TRANSFER_END) 
	begin
		SS0<=1;
		SS1<=1;
		SS2<=1;
		SS3<=1;
	end
end

////////////////////////////////////////////////////////SPI_MASTER__FSM////////////////////////////////////////////////

always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
    	RX_REG     <=8'b0   ;
		SCK_ENABLE <= 1'b0  ;
		STATE      <= IDLE ;
	end
	else if(CONFIG_REG[6])
	begin
    case (STATE)
    IDLE : //IDLE
    begin
        if(!CMD && RX_PULSE)  
            RX_REG <= SHIFT_REG ;
		else if (clear_flag)
			RX_REG <= 'b0 ; 		  
        else if (CMD)  //BUSY state
            STATE  <= CONFIGURE ;
    end
    CONFIGURE : // CONFIG
    begin
        STATE <= TRANSFER ;
    end
    TRANSFER: //TRANSFER
    begin
		SCK_ENABLE     <= 1'b1 ;
		if(SCK_CNT<16)
		begin
			SCK_ENABLE <= 1'b1;
		end
		else
		begin
			SCK_ENABLE <= 1'b0 ;
			STATE      <= TRANSFER_END;
		end        
    end
    TRANSFER_END: //TRANSFER_END
    begin
		STATE <= IDLE ;    
    end
    endcase
	end
end	

///////////////////////////////////////////////////SPI_MASTER_OUTPUT//////////////////////////////////////

assign MOSI= ((({SS0,SS1,SS2,SS3})!=4'b1111)  )? SHIFT_REG[7] : 1'b0;

//////////////////////////////////////////////THE RECEIVER ANS TRANSMITTER////////////////////////////////

always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		SHIFT_REG <= 8'b0   ;
		SCK_CNT   <= 4'b0000;
		SHIFT_IN  <= 1'b0   ;
	end
	else if (SEL_DATA && CONFIG_REG[6])
	begin
		SHIFT_REG <= DATA_SHIFT_REG ;	
	end
	else if(STATE==CONFIGURE || STATE==TRANSFER_END)
	begin
		SCK_CNT <= 4'b0000 ;
	end
	else if(STATE== TRANSFER && capture)
	begin
	     if(!CONFIG_REG[7]) 	//full duplex mode
	            begin
	                SHIFT_IN <= MISO ;
	            end
				else                // half duplex mode
	            begin  
				    SHIFT_IN <= MISO_half_duplex ;
	            end	
	    if(P_EDGE)
	    begin
	        SCK_CNT <= SCK_CNT + 1'b1 ;
	        case (MODE)
	        2'b00 : 
	        begin           
	            if(!CONFIG_REG[7]) 	//full duplex mode
	            begin
	                SHIFT_IN <= MISO ;
	            end
				else                // half duplex mode
	            begin  
				    SHIFT_IN <= MISO_half_duplex ;
	            end				
	        end
	        2'b01 : 
	        begin
				SHIFT_REG    <= SHIFT_REG << 1 ;
				SHIFT_REG[0] <= SHIFT_IN ;
	        end
	        2'b10 : 
	        begin
				SHIFT_REG    <= SHIFT_REG << 1 ;
				SHIFT_REG[0] <= SHIFT_IN;
	        end
	        2'b11 : 
	        begin
	            if(!CONFIG_REG[7]) 	//full duplex mode
	            begin
	                SHIFT_IN <= MISO ;
	            end
				else                // half duplex mode
	            begin  
				    SHIFT_IN <= MISO_half_duplex ;
	            end
	        end
	        endcase
	    end
	    else if (N_EDGE)
	    begin
	        SCK_CNT <= SCK_CNT + 1'b1 ;
	        case (MODE)
	        2'b00 : 
	        begin
				SHIFT_REG    <= SHIFT_REG << 1 ;
				SHIFT_REG[0] <= SHIFT_IN ;            
	        end
	        2'b01 : 
	        begin
	            if(!CONFIG_REG[7]) 	//full duplex mode
	            begin
	                SHIFT_IN <= MISO ;
	            end
				else                // half duplex mode
	            begin  
				    SHIFT_IN <= MISO_half_duplex ;
	            end            
	        end
	        2'b10 : 
	        begin
	            if(!CONFIG_REG[7]) 	//full duplex mode
	            begin
	                SHIFT_IN <= MISO ;
	            end
				else                // half duplex mode
	            begin  
				    SHIFT_IN <= MISO_half_duplex ;
	            end            
	        end
	        2'b11 : 
	        begin
	 			SHIFT_REG    <= SHIFT_REG << 1 ;
				SHIFT_REG[0] <= SHIFT_IN ;           
	        end
	        endcase        
	    end
	end	
end

/////////////////////////////////////////////////////////////////////////////////////////////////////////

//that pulse used to indicate the end of the session andd update the RX_REG with the received date
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		RX_DFF <= 1'b0 ;
	end
    else if (SS0 == 0 || SS1 == 0 || SS2 == 0 || SS3 == 0)
	begin
		RX_DFF <= 1'b1 ;
	end
	else
	begin
		RX_DFF <= 1'b0 ;
	end
end

assign RX_PULSE = RX_DFF & (SS0 == 1 && SS1 == 1 && SS2 == 1 && SS3 == 1) ; 

always @ (posedge PCLK or negedge PRESETn)
begin
  	if (!PRESETn)
		int_flag <= 0 ;
	else if (RX_PULSE)
		int_flag <= 1 ;
	else if (SPI_INT_CLR[1])
		int_flag <= 0 ;
end

/////////////////////////////////////////////////Interrupts/////////////////////////////////////////////////////////

//flag for clearing the interrupts and the receiving data register after reading the data as expected

always @ (posedge PCLK or posedge PRESETn)
begin
	if(!PRESETn)
		clear_flag <= 1'b0 ;
 	else if(Clear)
  		clear_flag <= 1'b1 ;
  	else if (SEL_DATA)
  		clear_flag <= 1'b0 ;
end

//////////////////////////////////////////////////////////////////////////////////////////////////

always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	        Tx_int_en <= 'b0;
    else if(SPI_EN  && STATE == TRANSFER_END && CONFIG_REG[7] == 0) // Transmission Session   CONFIG_REG[10] == TX_EN // FULL DUPLEX MODE
			Tx_int_en <= 'b1 ;     
	else if(SPI_EN && STATE == TRANSFER_END && CONFIG_REG[7] == 1 && CONFIG_REG[11] == 0) // Transmission Session   CONFIG_REG[10] == TX_EN // Half DUPLEX MODE
			Tx_int_en <= 'b1 ; 
	else if(clear_flag)
			Tx_int_en <= 'b0 ;  
end

////////////////////////////////////////////////* TX interrupt */////////////////////////////////

always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		SPI_INT[0] <= 'b0 ;
	else if(Tx_int_en && CONFIG_REG[6] == 1 && CONFIG_REG[8] == 1 && SPI_INT_CLR[0] == 0 ) 
		SPI_INT[0] <= 'b1 ;
	else if(SPI_INT_CLR[0]==1 && CONFIG_REG[8] == 1 && CONFIG_REG[6] == 1)
		SPI_INT[0] <= 'b0 ;
    else if(CONFIG_REG[6] == 0)
		SPI_INT[0] <= 'b0 ;
end

//////////////////////////////////////////////* RX interrupt */////////////////////////////////

always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		SPI_INT[1] <= 'b0 ;
	else if((RX_REG == SHIFT_REG) && int_flag && SPI_INT_CLR[1] != 1 && CONFIG_REG[9] == 1 && CONFIG_REG[6] == 1 && CONFIG_REG[7] ==0 ) 
		SPI_INT[1] <= 'b1 ;
	else if((RX_REG == SHIFT_REG) && int_flag && SPI_INT_CLR[1] != 1 && CONFIG_REG[9] == 1 && CONFIG_REG[6] == 1 && CONFIG_REG[7] ==1  && CONFIG_REG[11] == 1) 
		SPI_INT[1] <= 'b1 ;
	else if(SPI_INT_CLR[1] && CONFIG_REG[9] == 1 && CONFIG_REG[6] == 1)
		SPI_INT[1] <= 'b0 ;	
    else if(CONFIG_REG[6] == 0)
		SPI_INT[1] <= 'b0 ;
end

endmodule

