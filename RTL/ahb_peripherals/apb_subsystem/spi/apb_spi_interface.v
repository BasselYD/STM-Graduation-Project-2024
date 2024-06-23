//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : APB SPI
//-----------------------------------------------------------------------------
//-------------------------------------
// Programmer's model
// -------------------------------
// 0x000 RW    Config Reg[10:0]
//               [10] SPI Enable
//               [9] RX interrupt enable
//               [8] TX interrupt enable
//               [7] Full/Half Duplex (write 1 for half-duplex)
//               [6] Slave/Master Mode (write 1 to enable master mode)
//               [4:5] Clock phase and polarity
//               [2:3] Slave selector
//               [0:1] Clock divider
// 0x004 R     RX Data[7:0]           Received Data
//       W     Data Shift Reg[7:0]    Transmit Data
// 0x08  R     State Register
//               [1] RX buffer full
//               [0] TX buffer full
// 0x0C  R     Interrupt Status
//               [1] RX interrupt STATUS
//		         [0] TX interrupt STATUS
//       W     Interrupt Status Clear
//               [1] clear RX INT
//		         [0] clear TX INT
//-------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////
/*
SPI (Serial Peripheral Interface) is a synchronous serial communication protocol used to 
connect microcontrollers and peripheral devices. it supports the following properties:
1. Switching between master and slave modes
2. Communication with up to 4 slaves
3. Switching between full-duplex and half-duplex modes
4. Programmable clock modes
4. Clock divsion up to 16 times
*/
/////////////////////////////////////////////////////////////////////////////////////////
module APB_SPI_interface
(
	input 			  PRESETn,
	input 			  PCLK,
	input 			  PSEL,
	input 			  PENABLE,
	input 			  PWRITE,
	input [11:2] 	  PADDR,
	input [31:0] 	  PWDATA,
	
	output  		  PREADY,
	output reg 		  PSLVERR,
	output reg [31:0] PRDATA,

	//inout 			  MISO,
	//inout 			  MOSI,
	//inout 			  SCK,
  //
   ////output selector for external slaves from SPI master
	//inout		 	  SS0,
	output SCK_clk, // master output
	output MOSII, // master output
	input  MISO,  // master input
	output SS0, // output master

	output MISOO, // slave output
    input  IN_slave, // slave input MOSI
	input  SS, // slave select input
	input  SCK,// input clock to slave
	output		 	  SS1,
	output		 	  SS2,
	output		 	  SS3,
    output            enable_master,
	//interrupts 
	output 			  TXINT,
	output 			  RXINT,
	output reg 		  COMBINT
);

/////////////////////////////////////SPI_REGISTERS/////////////////////////////////////
	 
	reg  [15:0] CONFIG_REG ;      // the used register to configure the module
	wire [7:0] 	RX_REG ;          // THE REGISTER which have the received data 
	wire [1:0] 	INTSTATUS ;       // read only
	reg  [1:0]  INTCLEAR ;        // write only
	reg  [7:0]  DATA_SHIFT_REG ;  // the register which is updated with the data to be transmitted
	reg  [1:0]  STATE_REG ; 	  // the register that defines if there transimission or receiving is processing 
	reg 		d_ff;
	wire 		PULSE ;
	wire 		RX_PULSE; 

/////////////////////////////////////////PREADY/////////////////////////////////////////

assign PREADY = 1 ;
assign enable_master = CONFIG_REG[6];
/////////////////////////////////////////the interrupts///////////////////////////////////////////

assign {RXINT,TXINT} = INTSTATUS;

always @ (*)
begin
	if(|INTSTATUS)
	COMBINT = 1;
	else
	COMBINT = 0;
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

// needed pulse every time there is write transfer to generate another pulses to facilitate some actions needed

/*the another pulses */
reg SEL_DATA, SEL_CMD, Clear ;

always @(posedge PCLK or negedge PRESETn)				
begin
	if(!PRESETn)
	begin
		d_ff <= 1'b0;
	end
    else if (PENABLE==1)
	begin
		d_ff <= 1'b1;
	end
	else
	begin
		d_ff <= 1'b0;
	end
end

assign PULSE = ~d_ff & PENABLE; 

///////////////////////////////////////////////////////////shared area registers//////////////////////////////////////////////////////

//APB_Interface
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		CONFIG_REG	   <= 'b0 ;
		DATA_SHIFT_REG <= 'b0 ;
		INTCLEAR       <= 'b0 ;
		PRDATA         <= 'b0 ;   
		SEL_CMD  	   <= 'b0 ;
        SEL_DATA       <= 'b0 ;
        Clear          <= 'b0 ;
	end
	else if( PSEL && PREADY) 
	begin
		if( (PADDR[11:7] == 0) && PWRITE )
		begin
			case(PADDR[6:2])
			4'h0 :  
			begin
			  	CONFIG_REG <= PWDATA ;
				if(PWDATA[10]) // this bit is the commond which triggers spi_master_fsm from the idle state
				SEL_CMD    <= PULSE ;
			end
			4'h1 :  
			begin
				DATA_SHIFT_REG <= PWDATA ;
				SEL_DATA <= PULSE ;
			end
			4'h3 :  
			begin
				INTCLEAR   <= PWDATA ; // write only
				Clear      <= PULSE ;
			end
			default :
			begin
				CONFIG_REG	   <= 'b0 ;
		 		DATA_SHIFT_REG <= 'b0 ;
		 		INTCLEAR       <= 'b0 ;
			end
			endcase
		end
		else if( (PADDR[11:7] == 0) && (! PWRITE) )
		begin
			case(PADDR[6:2])
			4'h0 :    PRDATA <= CONFIG_REG ;
			4'h1 :    PRDATA <= RX_REG     ;
			4'h2 :    PRDATA <= STATE_REG  ;
			4'h3 :    PRDATA <= INTSTATUS  ;
			default : PRDATA <= 'b0        ;
			endcase
		end
	end
	else if (!PULSE)
	begin
		SEL_CMD  	<= 'b0 ;
		SEL_DATA 	<= 'b0 ;
		Clear       <= 'b0 ;
		INTCLEAR    <= 'b0 ;
	end		
end

//////////////////////////////////////////////Error Handling//////////////////////////////////////////////////////////////////

always @ (*)
begin
 if(PADDR > 'h3 && PSEL)
   PSLVERR = 1'b1;
 else if(PADDR == 'h2 && PWRITE == 1 && PSEL)
   PSLVERR = 1'b1;
 else
    PSLVERR = 1'b0;
end

///////////////////////////////////////////////////SPI STATTE//////////////////////////////////////////////////////////

/*
STATE_REG[0] Trasmission
STATE_REG[1] Recieve
*/

always @ (posedge PCLK or negedge PRESETn) 
begin
	if(!PRESETn)
	STATE_REG <= 'b0 ;
	else if (PWRITE && (PADDR[6:2] == 'h1)&& PSEL)
	STATE_REG[0] <= 'b1 ;
	else if (RX_PULSE)
	begin
	  STATE_REG[0] <= 'b0;
	  STATE_REG[1] <= 'b1;
	end
	else if (!PWRITE && (PADDR[6:2] == 'h1)&& PSEL)
	STATE_REG[1] <= 'b0 ;	
end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// the pulse which generated when SPI configured as a slave and selected (SS0 = 0)

reg pul;
wire SEL_DATA_Slave; //pulse for slave 
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
        begin
        pul <= 1'b0;
        end
    else if (SS==0)
        begin
        pul <= 1'b1;
        end
    else
        begin
        pul <= 1'b0;
        end
end

assign SEL_DATA_Slave = (~pul & !SS) ? 'b1 : 'b0; 

/////////////////////////////////////////////////////spi_instantation///////////////////////////////////////

 wire master_ss ;

SPI_TOP SPI
(
	.PCLK(PCLK),
	.PRESETn(PRESETn),

	.SEL_DATA(SEL_DATA),
	.SEL_CMD(SEL_CMD),
	.Clear(Clear),
	.SEL_DATA_Slave(SEL_DATA_Slave),

	.CONFIG_REG(CONFIG_REG),
	.RX_REG(RX_REG),
	.SPI_INT(INTSTATUS),
	.SPI_INT_CLR(INTCLEAR),
	.DATA_SHIFT_REG(DATA_SHIFT_REG),
	.RX_PULSE(RX_PULSE),

	//.MOSI(MOSI), 	 // system out
	//.MISO(MISO),	 // system out
	//.SCK(SCK), 	     // system out
	.SCK_clk(SCK_clk), // master output
	.MOSII(MOSII), // master output
	.MISO(MISO),  // master input

	.MISOO(MISOO), // slave output
    .IN_slave(IN_slave), // slave input MOSI
	.SCK(SCK), // input clock to slave
	.SS(SS), 		 //input selector to the slave
	.SS0(SS0), // the slave selector 0, which is output from the master
	.SS1(SS1),       // system out
	.SS2(SS2),
	.SS3(SS3)
);

//exiting the slave selector tri-state-buffer instance from SPI_TOP
//to that module for solving vivado critical warnings
/*
[Synth 8-5744] Inout buffer is not created at top module APB_SPI_interface for the pin SS0, other connections may not have buffer connection 
["C:/STM-Graduation-Project-2024/RTL/ahb_peripherals/apb_subsystem/spi/apb_spi_interface.v":41]
*/
/*
tri_state_buffer SS0_TRI_BUFF
(
	.enable(CONFIG_REG[6]),
	.data_in(master_ss), // the slave selector 0, which is output from the master
	.data_out(SS0) //inout signal
);
*/		
endmodule 



