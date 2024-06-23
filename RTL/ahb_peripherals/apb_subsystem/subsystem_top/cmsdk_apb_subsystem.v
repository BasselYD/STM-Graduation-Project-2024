//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2010-2013 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2013-04-12 18:34:22 +0100 (Fri, 12 Apr 2013) $
//
//      Revision            : $Revision: 243882 $
//
//      Release Information : Cortex-M System Design Kit-r1p0-00rel0
//
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Abstract : APB sub system
//-----------------------------------------------------------------------------
 module cmsdk_apb_subsystem #(parameter Include_dual_timer = 1, Include_SPI = 1) (
  //AHB inputs
  input HCLK,
  input HRESETn,
  input [1:0] HTRANS,
  input [2:0] HSIZE,
  input [3:0] HPROT,
  input [15:0] HADDR,
  input [31:0] HWDATA,
  input HSEL,
  input HWRITE,
  input HREADY,

  //APB inputs  
  input PCLK,
  input PCLKG,
  input PRESETn,
  input RXD0,
  input RXD1,
  input EXTIN,

  //WDOG
  input WDOGCLK,
  input WDOGRESn,

  //DualTimer
  input TIMCLK,

  //AHB outputs
  output [31:0] HRDATA,
  output HREADYOUT,
  output HRESP,
  
  //APB outputs
  output APB_ACTIVE,
  output TXD0,
  output TXD1,
  output TXD0_EN,
  output TXD1_EN,
  output watchdog_interrupt,
  output watchdog_reset,
	output SCK_clk, // master output
	output MOSII, // master output
	input  MISO,  // master input
	output SS0, // output master

	output MISOO, // slave output
  input  IN_slave, // slave input MOSI
	input  SS, // slave select input
	input  SCK ,// input clock to slave
	output		 	  SS1,
	output		 	  SS2,
	output		 	  SS3,
  output        enable_master,
  output        RTS0,RTS1,
  input         CTS0,CTS1,
  output reg [16:0] subsystem_interrupt
);

wire PSEL;                        //APB select signal output from bridge
wire PENABLE;                     //APB enable signal output from bridge
wire PWRITE;                      //APB write enbale output from bridge
wire [15:0] PADDR;                //APB adress output from bridge
wire [31:0] PWDATA;               //APB write data output from bridge

wire UART0_PSEL;                  //First uart selector
wire UART1_PSEL;                  //Second uart selector
wire WDOG_PSEL;                   //Watchdog selector
wire TIMER_PSEL;                  //Timer selector
wire DUAL_TIMER_PSEL;             //Dual timer selector
wire SPI_PSEL;                    //SPI selector

wire [31:0] TIMER_PRDATA;         //Timer read data 
wire TIMER_SLVERR;                //Timer error signal
wire TIMERINT;                    //Timer interrupt signal

wire [31:0] SPI_PRDATA;           //SPI read data 
wire SPI_SLVERR;                  //SPI error signal
wire SPI_TXINT;                   //SPI transmitter interrupt
wire SPI_RXINT;                   //SPI receive interrupt
wire SPIINT;                      //SPI combined interrupt

wire [31:0] WDOG_PRDATA;          //Watchdog read data 
wire WDOG_SLVERR;                 //Watchdog error signal
wire WDOGINT;                     //Watchdog interrupt signal
wire WDOGRES;                     //Watchdog reset signal

wire [31:0] DUAL_TIMER_PRDATA;    //Dual timer read data
wire DUAL_TIMER_SLVERR;           //Dual timer error signal
wire DUAL_TIMER_INT1;             //Dual timer 1 interrupt signal
wire DUAL_TIMER_INT2;             //Dual timer 2 interrupt signal
wire DUAL_TIMER_INTC;             //Dual timer combined interrupt signal
 
wire [31:0] UART0_PRDATA;         //Uart0 read data
wire UART0_SLVERR;                //Uart0 error signal
wire TXINT0;                      //Uart0 transmitter interrupt
wire RXINT0;                      //Uart0 receive interrupt
wire TXOVRINT0;                   //Uart0 transmitter overflow interrupt
wire RXOVRINT0;                   //Uart0 receiver overflow interrupt
wire UARTINT0;                    //Uart0 combined interrupt
 
wire [31:0] UART1_PRDATA;         //Uart1 read data
wire UART1_SLVERR;                //Uart1 error signal
wire TXINT1;                      //Uart1 transmitter interrupt
wire RXINT1;                      //Uart1 receive interrupt
wire TXOVRINT1;                   //Uart1 transmitter overflow interrupt
wire RXOVRINT1;                   //Uart1 receiver overflow interrupt
wire UARTINT1;                    //Uart1 combined interrupt

wire TIMERINT_IRQ;                //Sycnrhonized timer interrupt

wire DUAL_TIMER_INT1_IRQ;         //Sycnrhonized dual timer 1 interrupt
wire DUAL_TIMER_INT2_IRQ;         //Sycnrhonized dual timer 2 interrupt
wire DUAL_TIMER_INTC_IRQ;         //Sycnrhonized dual timer combined interrupt

wire TXINT0_IRQ;                  //Synchronized uart 0 interrupt transmitter
wire RXINT0_IRQ;                  //Synchronized uart 0 interrupt receiver
wire TXOVRINT0_IRQ;               //Synchronized uart 0 overflow interrupt transmitter
wire RXOVRINT0_IRQ;               //Synchronized uart 0 overflow interrupt receiver
wire UARTINT0_IRQ;                //Synchronized uart 0 combined interrupt

wire TXINT1_IRQ;                  //Synchronized uart 1 interrupt transmitter
wire RXINT1_IRQ;                  //Synchronized uart 1 interrupt receiver
wire TXOVRINT1_IRQ;               //Synchronized uart 1 overflow interrupt transmitter
wire RXOVRINT1_IRQ;               //Synchronized uart 1 overflow interrupt receiver
wire UARTINT1_IRQ;                //Synchronized uart 1 combined interrupt


wire TIMER_READY;                 //Timer ready signal
wire UART0_READY;                 //Uart0 ready signal
wire UART1_READY;                 //Uart1 ready signal
wire SPI_READY;                   //SPI ready signal

wire PSLVERR;                     //Muxed slave error signal
wire PREADY;                      //Muxed slave ready signal
wire [31:0] PRDATA;               //Muxed read data 
 
/*AHB to APB bridge module used to transfer data from pipelined to single cycle and enable the apb peripherals*/
APB_Bridge #(.HADDR_SIZE (16),
             .HDATA_SIZE (32),
             .PADDR_SIZE (16),
             .PDATA_SIZE (32),
             .SYNC_DEPTH (3))
APB_Bridge_inst(
.HRESETn(HRESETn),
.HCLK(HCLK),
.HSEL(HSEL),
.HADDR(HADDR),
.HWDATA(HWDATA),
.HRDATA(HRDATA),
.HWRITE(HWRITE),
.HSIZE(HSIZE),
.HBURST(3'b0),  //Grounded till further notice
.HPROT(HPROT),
.HTRANS(HTRANS),
.HMASTLOCK(1'b0), //Grounded till further notice
.HREADYOUT(HREADYOUT),
.HREADY(HREADY),
.HRESP(HRESP),
.PRESETn(PRESETn),
.PCLK(PCLK),
.PSEL(PSEL),
.PENABLE(PENABLE),
.PPROT(), //No connection till further notice
.PWRITE(PWRITE),
.PSTRB(), //No connection till further notice
.PADDR(PADDR),
.PWDATA(PWDATA),
.PRDATA(PRDATA),
.PREADY(PREADY),  
.PSLVERR(PSLVERR),
.APB_ACTIVE(APB_ACTIVE)
);


/*Adress decoder to make sure memory mapping is achieved for all peripherals*/

APB_decoder #(.Include_dual_timer(Include_dual_timer), .Include_SPI(Include_SPI)) APB_decoder_inst (
  .PADDR(PADDR[15:12]),
  .PSEL(PSEL),
  .UART0_PSEL(UART0_PSEL),
  .UART1_PSEL(UART1_PSEL),
  .WDOG_PSEL(WDOG_PSEL),
  .TIMER_PSEL(TIMER_PSEL),
  .DUAL_TIMER_PSEL(DUAL_TIMER_PSEL),
  .SPI_PSEL(SPI_PSEL)
);

/*Timer module instantiation*/
cmsdk_apb_timer TIMER(
.PCLK(PCLK),  
.PCLKG(PCLKG),
.PRESETn(PRESETn),
.PSEL(TIMER_PSEL),  
.PADDR(PADDR[11:2]),
.PENABLE(PENABLE),
.PWRITE(PWRITE), 
.PWDATA(PWDATA),
.ECOREVNUM(4'h0), //Grounded till further notice
.PRDATA(TIMER_PRDATA),
.PREADY(TIMER_READY),  
.PSLVERR(TIMER_SLVERR), 
.EXTIN(EXTIN), 
.TIMERINT(TIMERINT)
);

/*Watchdog module instantiation*/
cmsdk_apb_watchdog WATCHDOG (
.PCLK(PCLKG),     
.PRESETn(PRESETn),  
.PENABLE(PENABLE),
.PSEL(WDOG_PSEL),     
.PADDR(PADDR[11:2]),
.PWRITE(PWRITE),
.PWDATA(PWDATA),
.WDOGCLK(WDOGCLK),     //Connected to PCLK till further notice
.WDOGCLKEN(1'b1),   //Assigned one till further notice
.WDOGRESn(WDOGRESn), //Connected to PRESETn till further notice
.ECOREVNUM(4'h0),   //Grounded till further notice
.PRDATA(WDOG_PRDATA),   
.WDOGINT(WDOGINT),  
.WDOGRES(WDOGRES),
.PSLVERR(WDOG_SLVERR)
);

generate if(Include_dual_timer == 1)
begin : Dual_timer_instance
/*Dual timer module instantiation*/
cmsdk_apb_dualtimers DUAL_TIMER(
.PCLK(PCLKG),     
.PRESETn(PRESETn),
.PENABLE(PENABLE),
.PSEL(DUAL_TIMER_PSEL),
.PADDR(PADDR[11:2]),
.PWRITE(PWRITE),
.PWDATA(PWDATA),
.TIMCLK(TIMCLK),    //Connectod to PCLK till further notice
.TIMCLKEN1(1'b1), //Assigned one till further notice
.TIMCLKEN2(1'b1), //Assigned one till further notice
.ECOREVNUM(4'h0), //Grounded till further notice
.PRDATA(DUAL_TIMER_PRDATA),   
.PSLVERR(DUAL_TIMER_SLVERR),
.TIMINT1(DUAL_TIMER_INT1),  
.TIMINT2(DUAL_TIMER_INT2),
.TIMINTC(DUAL_TIMER_INTC)
);
end : Dual_timer_instance
else
begin : grounding_signals
assign  DUAL_TIMER_PRDATA = 32'b0;
assign  DUAL_TIMER_SLVERR = 1'b0;
assign  DUAL_TIMER_INT1 = 1'b0;
assign  DUAL_TIMER_INT2 = 1'b0;
assign  DUAL_TIMER_INTC = 1'b0;
end : grounding_signals
endgenerate


/*
generate if(Include_SPI == 1)
begin : SPI_instance
/*SPI module instantiation
APB_SPI_interface SPI
(
.PCLK(PCLK),     
.PRESETn(PRESETn),
.PENABLE(PENABLE),
.PSEL(SPI_PSEL),
.PADDR(PADDR[11:2]),
.PWRITE(PWRITE),
.PWDATA(PWDATA),
.PRDATA(SPI_PRDATA),   
.PSLVERR(SPI_SLVERR),
.PREADY(SPI_READY),
.TXINT(SPI_TXINT),
.RXINT(SPI_RXINT),
.COMBINT(SPIINT),
.MOSI(MOSI), 
.MISO(MISO), 
.SCK(SCK), 
.SS0(SS0),
.SS1(SS1),
.SS2(SS2),
.SS3(SS3)
);
end : SPI_instance
else
begin : grounding_spi_signals
assign  SPI_PRDATA = 32'b0;
assign  SPI_SLVERR = 1'b0;
assign  SPI_READY = 1'b0;
assign  SPI_TXINT = 1'b0;
assign  SPI_RXINT = 1'b0;
assign  SPIINT = 1'b0;
assign  SS1 = 1'b0;
assign  SS2 = 1'b0;
assign  SS3 = 1'b0;
end : grounding_spi_signals
endgenerate
*/

APB_SPI_interface SPI
(
.PCLK(PCLK),     
.PRESETn(PRESETn),
.PENABLE(PENABLE),
.PSEL(SPI_PSEL),
.PADDR(PADDR[11:2]),
.PWRITE(PWRITE),
.PWDATA(PWDATA),
.PRDATA(SPI_PRDATA),   
.PSLVERR(SPI_SLVERR),
.PREADY(SPI_READY),
.TXINT(SPI_TXINT),
.RXINT(SPI_RXINT),
.COMBINT(SPIINT),
//.MOSI(MOSI), 
//.MISO(MISO), 
//.SCK(SCK), 
//.SS0(SS0),
//.SS1(SS1),
//.SS2(SS2),
//.SS3(SS3)
	.SCK_clk(SCK_clk), // master output
	.MOSII(MOSII), // master output
	.MISO(MISO),  // master input
	.SS0(SS0), // output .
	.MISOO(MISOO), // slave output
  .IN_slave(IN_slave), // slave input MOSI
	.SS(SS), // slave select input
	.SCK(SCK), // input clock to slave
	.SS1(SS1),
	.SS2(SS2),
	.SS3(SS3),
  .enable_master(enable_master)
);

/*First uart module instantiation*/
cmsdk_apb_uart UART0 (
.PCLK(PCLK),    
.PCLKG(PCLKG),
.PRESETn(PRESETn),
.PSEL(UART0_PSEL),
.PADDR(PADDR[11:2]),
.PENABLE(PENABLE),
.PWRITE(PWRITE),
.PWDATA(PWDATA),
.ECOREVNUM(4'h0), //Grounded till further notice
.PRDATA(UART0_PRDATA),
.PREADY(UART0_READY),     
.PSLVERR(UART0_SLVERR),
.RXD(RXD0),    
.TXD(TXD0),
.TXEN(TXD0_EN),        
.BAUDTICK(),    //No connection till further notice
.TXINT(TXINT0),
.RXINT(RXINT0),   
.TXOVRINT(TXOVRINT0),
.RXOVRINT(RXOVRINT0),
.CTS(CTS0),
.RTS(RTS0),
.UARTINT(UARTINT0)
);


/*Second uart module instantiation*/
cmsdk_apb_uart UART1 (
.PCLK(PCLK),    
.PCLKG(PCLKG),
.PRESETn(PRESETn),
.PSEL(UART1_PSEL),
.PADDR(PADDR[11:2]),
.PENABLE(PENABLE),
.PWRITE(PWRITE),
.PWDATA(PWDATA),
.ECOREVNUM(4'h0), //Grounded till further notice
.PRDATA(UART1_PRDATA),
.PREADY(UART1_READY),  
.PSLVERR(UART1_SLVERR),
.RXD(RXD1),    
.TXD(TXD1),
.TXEN(TXD1_EN),          
.BAUDTICK(),    //No connection till further notice
.TXINT(TXINT1),
.RXINT(RXINT1),   
.TXOVRINT(TXOVRINT1),
.RXOVRINT(RXOVRINT1),
.CTS(CTS1),
.RTS(RTS1),
.UARTINT(UARTINT1)
);

cmsdk_apb_slave_mux MUX(
.PSEL0(UART0_PSEL),
.PREADY0(UART0_READY), 
.PRDATA0(UART0_PRDATA),
.PSLVERR0(UART0_SLVERR),
.PSEL1(TIMER_PSEL),
.PREADY1(TIMER_READY), 
.PRDATA1(TIMER_PRDATA),
.PSLVERR1(TIMER_SLVERR),
.PSEL2(WDOG_PSEL),
.PREADY2(1'b1), //Assigned 1 till further notice
.PRDATA2(WDOG_PRDATA),
.PSLVERR2(WDOG_SLVERR),
.PSEL3(DUAL_TIMER_PSEL),
.PREADY3(1'b1),   //Assigned 1 till further notice 
.PRDATA3(DUAL_TIMER_PRDATA),
.PSLVERR3(DUAL_TIMER_SLVERR),
.PSEL4(UART1_PSEL),
.PREADY4(UART1_READY), 
.PRDATA4(UART1_PRDATA),
.PSLVERR4(UART1_SLVERR),
.PSEL5(SPI_PSEL),
.PREADY5(SPI_READY), 
.PRDATA5(SPI_PRDATA),
.PSLVERR5(SPI_SLVERR),
.PREADY(PREADY),
.PRDATA(PRDATA),
.PSLVERR(PSLVERR)
);

//Timer interrupt synchronization
cmsdk_irq_sync u_irq_sync_0 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (TIMERINT),
.IRQOUT(TIMERINT_IRQ)
);

//Dual timer interrupt syncrhonization
cmsdk_irq_sync u_irq_sync_1 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (DUAL_TIMER_INT1),
.IRQOUT(DUAL_TIMER_INT1_IRQ)
);

cmsdk_irq_sync u_irq_sync_2 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (DUAL_TIMER_INT2),
.IRQOUT(DUAL_TIMER_INT2_IRQ)
);

cmsdk_irq_sync u_irq_sync_3 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (DUAL_TIMER_INTC),
.IRQOUT(DUAL_TIMER_INTC_IRQ)
);

//Watchdog interrupt syncrhonization
cmsdk_irq_sync u_irq_sync_4 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (WDOGINT),
.IRQOUT(watchdog_interrupt)
);

cmsdk_irq_sync u_irq_sync_5 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (WDOGRES),
.IRQOUT(watchdog_reset)
);

//First uart interrupt syncrhonization
cmsdk_irq_sync u_irq_sync_6 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (TXINT0),
.IRQOUT(TXINT0_IRQ)
);

cmsdk_irq_sync u_irq_sync_7 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (RXINT0),
.IRQOUT(RXINT0_IRQ)
);

cmsdk_irq_sync u_irq_sync_8 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (TXOVRINT0),
.IRQOUT(TXOVRINT0_IRQ)
);

cmsdk_irq_sync u_irq_sync_9 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (RXOVRINT0),
.IRQOUT(RXOVRINT0_IRQ)
);

cmsdk_irq_sync u_irq_sync_10 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (UARTINT0),
.IRQOUT(UARTINT0_IRQ)
);


//Second uart interrupt syncrhonization
cmsdk_irq_sync u_irq_sync_11 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (TXINT1),
.IRQOUT(TXINT1_IRQ)
);

cmsdk_irq_sync u_irq_sync_12 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (RXINT1),
.IRQOUT(RXINT1_IRQ)
);

cmsdk_irq_sync u_irq_sync_13 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (TXOVRINT1),
.IRQOUT(TXOVRINT1_IRQ)
);

cmsdk_irq_sync u_irq_sync_14 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (RXOVRINT1),
.IRQOUT(RXOVRINT1_IRQ)
);

cmsdk_irq_sync u_irq_sync_15 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (UARTINT1),
.IRQOUT(UARTINT1_IRQ)
);

cmsdk_irq_sync u_irq_sync_16 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (SPI_RXINT),
.IRQOUT(SPI_RXINT_IRQ)
);

cmsdk_irq_sync u_irq_sync_17 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (SPI_TXINT),
.IRQOUT(SPI_TXINT_IRQ)
);


cmsdk_irq_sync u_irq_sync_20 (
.RSTn  (HRESETn),
.CLK   (HCLK),
.IRQIN (SPIINT),
.IRQOUT(SPIINT_IRQ)
);
always @(*)
begin
  subsystem_interrupt[0]  = TIMERINT_IRQ;             //Timer interrupt
  subsystem_interrupt[1]  = DUAL_TIMER_INT1_IRQ;      //Dual timer 1 interrupt
  subsystem_interrupt[2]  = DUAL_TIMER_INT2_IRQ;      //Dual timer 2 interrupt
  subsystem_interrupt[3]  = DUAL_TIMER_INTC_IRQ;      //Dual timer combined interrupt
  subsystem_interrupt[4]  = TXINT0_IRQ;               //Uart 0 transmit interrupt
  subsystem_interrupt[5]  = RXINT0_IRQ;               //Uart 0 receiver interrupt
  subsystem_interrupt[6]  = TXOVRINT0_IRQ;            //Uart 0 transmit overflow interrupt
  subsystem_interrupt[7]  = RXOVRINT0_IRQ;            //Uart 0 receiver overflow interrupt
  subsystem_interrupt[8]  = UARTINT0_IRQ;             //Uart 0 combined interrupt
  subsystem_interrupt[9]  = TXINT1_IRQ;               //Uart 1 transmit interrupt
  subsystem_interrupt[10] = RXINT1_IRQ;               //Uart 1 receiver interrupt
  subsystem_interrupt[11] = TXOVRINT1_IRQ;            //Uart 1 transmit overflow interrupt
  subsystem_interrupt[12] = RXOVRINT1_IRQ;            //Uart 1 receiver overflow interrupt
  subsystem_interrupt[13] = UARTINT1_IRQ;             //Uart 1 combined interrupt
  subsystem_interrupt[14] = SPI_RXINT_IRQ;            //spi  receiver interrupt
  subsystem_interrupt[15] = SPI_TXINT_IRQ;            //spi  transmit interrupt
  subsystem_interrupt[16] = SPIINT_IRQ;               //spi  combined interrupt

end
endmodule
  