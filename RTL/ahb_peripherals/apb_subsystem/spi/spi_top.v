////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
		that module containing the instantation of the slave and master and needed tri-state buffers to control 
		the switching between slave and master configurations
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module SPI_TOP
(
	input 		 	PCLK,
	input 		 	PRESETn,

	input 		 	SEL_DATA,
	input 		 	SEL_CMD,
	input			Clear,
	input		 	SEL_DATA_Slave,
	input  [15:0] 	CONFIG_REG,
	input  [1:0] 	SPI_INT_CLR, 
	/* 	
		SPI_INT_CLR bits
		[0] clear TX INT
		[1] clear RX INT
	*/
	input  [7:0] 	DATA_SHIFT_REG,
	output [7:0] 	RX_REG,
	output [1:0] 	SPI_INT,
	/* 
		SPI_INT bits
	   	[0] TX INT
	   	[1] RX INT
	*/
	output		 	RX_PULSE,

	inout 		 	MISO,
	inout 		 	MOSI,
	inout 		 	SCK,
	input		 	SS,
	output		 	SS0,
	output		 	SS1,
	output		 	SS2,
	output		 	SS3
);

/////////////////////////////////////internel registers and signals	 
   	wire MOSII, MISOO, SCK_clk;

   	//for solving synthesis critical warnings in vivado
   	wire [7:0] RX_REG_master, RX_REG_slave ;
	wire [1:0] SPI_INT_master, SPI_INT_slave ;

	/* 
	as in half duplex there is only one wire for the communication in the 2 directions
	this signal is used to carry the output in case of the half duplex to the MOSI port
	*/
	wire MOSI_half_duplex; 

	// controlling the inout port (MOSI) in case of half duplex to be used as output port for the slave or as its default state 
	reg SPI_IO; 

	// the signal is used for controlling the inout port (MOSI)
	wire enable_cond ;
/////////////////////////////////////////////////////////

	//for solving synthesis critical warnings in vivado
   	assign SPI_INT = (CONFIG_REG[6]==0) ?  SPI_INT_slave : SPI_INT_master;
   	assign RX_REG = (CONFIG_REG[6]==0) ?  RX_REG_slave : RX_REG_master;
	
	always@(*)
	begin
	  if(CONFIG_REG[7]==1 && CONFIG_REG[6]==0) // half duplex and slave mode
	  SPI_IO = MOSI_half_duplex; 			  // the output data from the slave 
	  else if(CONFIG_REG[7]==1 && CONFIG_REG[6]==1) // half duplex and master mode
	  SPI_IO = MOSII;
	  else if(CONFIG_REG[7]==0 ) // full dulex (defaultt case) and master 
	  SPI_IO = MOSII;
	  else
	  SPI_IO = 'b0;
	end

	// the signal is used for controlling the inout port (MOSI)
	assign enable_cond = ( (CONFIG_REG[7]==0 && CONFIG_REG[6]==1) || (CONFIG_REG[11]==0 && CONFIG_REG[7]==1)  ) ? 1:0 ;

	tri_state_buffer SPI_IO_BUFF
	(
		.enable(enable_cond),
		.data_in(SPI_IO),
		.data_out(MOSI)
	);

		/* control signal flow */
		wire IN_slave;
		wire IN_master; // the input for the master in case of half duplex

	tri_state_buffer Slave_input_BUFF
	(
		.enable(CONFIG_REG[11]== 1 || CONFIG_REG[7] == 0), /* slave receive */
		.data_in(MOSI),
		.data_out(IN_slave) 
	); // Buffers to avoid timing loop in half-duplex configuration.

	tri_state_buffer Master_input_BUFF
	(
		.enable(CONFIG_REG[11]== 1 || CONFIG_REG[7] == 0), /* master receive */
		.data_in(MOSI),
		.data_out(IN_master)
	); // Buffers to avoid timing loop in half-duplex configuration.

	tri_state_buffer MISO_TRI_BUFF
	(
		.enable(!CONFIG_REG[6] && !CONFIG_REG[7]), // slave ad full duplex
		.data_in(MISOO),
		.data_out(MISO)
	);

	tri_state_buffer SCK_TRI_BUFF
	(
		.enable(CONFIG_REG[6]),
		.data_in(SCK_clk),
		.data_out(SCK)
	);

	SPI_Master SPI_MASTER
	(
		/* APB Interface Signals */
		.PRESETn(PRESETn),
		.PCLK(PCLK),

		.SEL_DATA(SEL_DATA),
		.SEL_CMD(SEL_CMD),
		.Clear(Clear),

		.CONFIG_REG(CONFIG_REG),
		.RX_REG(RX_REG_master),
		.SPI_INT(SPI_INT_master),
		.SPI_INT_CLR(SPI_INT_CLR),
		.DATA_SHIFT_REG(DATA_SHIFT_REG),
		.RX_PULSE(RX_PULSE),

		/* SPI Master Signals */
		.MISO_half_duplex(IN_master),
		.MISO(MISO),
		.MOSI(MOSII), 
		.SCK(SCK_clk),
		.SS0(SS0),
		.SS1(SS1),
		.SS2(SS2),
		.SS3(SS3)
	);

	SPI_Slave SPI_SLAVE
	(
		.PRESETn(PRESETn),
		.PCLK(PCLK),
		.SCK(SCK),
		.MOSI_half_duplex(MOSI_half_duplex),
		.MOSI(IN_slave),
		.MISO(MISOO),
		.SS(SS),
		.CONFIG_REG(CONFIG_REG),
		.SPI_INT(SPI_INT_slave),
		.SPI_INT_CLR(SPI_INT_CLR),
		.DATA_SHIFT_REG(DATA_SHIFT_REG),
		.SEL_DATA_Slave(SEL_DATA_Slave),
		.SEL_DATA(SEL_DATA),
		.Clear(Clear),
		.RX_REG(RX_REG_slave)
	);

endmodule