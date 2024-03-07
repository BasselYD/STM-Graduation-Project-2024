module SYSTEM_TOP #(parameter AW       = 16,
							  Include_dual_timer = 1,
							  MEMFILE = "../Program/Scratch/main.bin")
( 

    input wire           HCLK,
    input wire           HRESETn,
	output wire       	TXD0,		
	input  wire       	RXD0,		
	output wire       	TXD0_EN,	
	output wire       	TXD1,		
	input  wire       	RXD1,		
	output wire       	TXD1_EN,		
	input  wire			EXTIN, 		
	inout wire [15:0]   SYSTEM_OUT);
	
	
    // Input port SI0 (inputs from cortex)
   wire  [31:0] HADDRS0;        // Address bus
   wire  [1:0] HTRANSS0;        // Transfer type
   wire        HWRITES0;        // Transfer direction
   wire  [2:0] HSIZES0;         // Transfer size
   wire  [2:0] HBURSTS0;        // Burst type
   wire  [3:0] HPROTS0;         // Protection control
   wire [31:0] HWDATAS0;        // Write data
   wire        HMASTLOCKS0;     // Locked Sequence

 

	// Input port SI0 (outputs to cortex)
   wire [31:0] HRDATAS0;        // Read data bus
   wire        HREADYS0;        // HREADY feedback
   wire        HRESPS0;         // Transfer response

	//output wire        SCANOUTHCLK;


// Output port MI0 (outputs to ISRAM)
    wire        HSELM0;          // Slave Select
    wire [31:0] HADDRM0;         // Address bus
    wire [1:0]  HTRANSM0;        // Transfer type
    wire        HWRITEM0;        // Transfer direction
    wire [2:0]  HSIZEM0;         // Transfer size
    wire [2:0]  HBURSTM0;        // Burst type
    wire [3:0]  HPROTM0;         // Protection control
    wire [31:0] HWDATAM0;        // Write data
    wire [31:0] HRDATAM0;        // Read data
    wire        HMASTLOCKM0;     // Locked Sequence
    wire        HREADYMUXM0;     // Transfer done
    wire        HREADYOUTM0;     // Transfer done
	wire 		HRESPM0;		 //Response signal

	// Output port MI1 (outputs to DSRAM)
    wire        HSELM1;          // Slave Select
    wire [31:0] HADDRM1;         // Address bus
    wire [1:0]  HTRANSM1;        // Transfer type
    wire        HWRITEM1;        // Transfer direction
    wire [2:0]  HSIZEM1;         // Transfer size
    wire [2:0]  HBURSTM1;        // Burst type
    wire [3:0]  HPROTM1;         // Protection control
    wire [31:0] HWDATAM1;        // Write data
    wire [31:0] HRDATAM1;        // Read data
    wire        HMASTLOCKM1;     // Locked Sequence
    wire        HREADYMUXM1;     // Transfer done
    wire        HREADYOUTM1;     // Transfer done
	wire 		HRESPM1;		 //Response signal
	
	// Output port MI2 (outputs to apb_subsystem)
    wire        HSELM2;          // Slave Select
    wire [31:0] HADDRM2;         // Address bus
    wire [1:0]  HTRANSM2;        // Transfer type
    wire        HWRITEM2;        // Transfer direction
    wire [2:0]  HSIZEM2;         // Transfer size
    wire [2:0]  HBURSTM2;        // Burst type
    wire [3:0]  HPROTM2;         // Protection control
    wire [31:0] HWDATAM2;        // Write data
    wire [31:0] HRDATAM2;        // Read data
    wire        HMASTLOCKM2;     // Locked Sequence
    wire        HREADYMUXM2;     // Transfer done
    wire        HREADYOUTM2;     // Transfer done
	wire 		HRESPM2;		 //Response signal

	// Output port MI3 (outputs to GPIO)
    wire        HSELM3;          // Slave Select
    wire [31:0] HADDRM3;         // Address bus
    wire [1:0]  HTRANSM3;        // Transfer type
    wire        HWRITEM3;        // Transfer direction
    wire [2:0]  HSIZEM3;         // Transfer size
    wire [2:0]  HBURSTM3;        // Burst type
    wire [3:0]  HPROTM3;         // Protection control
    wire [31:0] HWDATAM3;        // Write data
    wire [31:0] HRDATAM3;        // Read data
    wire        HMASTLOCKM3;     // Locked Sequence
    wire        HREADYMUXM3;     // Transfer done
    wire        HREADYOUTM3;     // Transfer done
	wire 		HRESPM3;		 //Response signal

	/***************************** Clocks and Resets **********************************/

	wire           FCLK ;
	wire           PCLK   ;		
	wire           PCLKG  ;
	wire           PRESETn;
	wire		   WDOGCLK;
	wire		   TIMCLK;
	wire		   WDOGRESn;

	/***************************** INTERRUPTS **********************************/

	wire [31:0] irq ;

	wire [13:0] subsystem_interrupt ;

	wire [15:0] GPIOINT ;
	wire COMBINT;

	wire        watchdog_interrupt ;
	wire		watchdog_reset ;
	
	wire APB_ACTIVE ;

	// GPIO interrupts
	assign irq[15:0]  = GPIOINT ;
	assign irq[16] = COMBINT;

	// APB interrupts
	assign irq[17]  = subsystem_interrupt[0] ;   // Timer interrupt
	assign irq[18]  = subsystem_interrupt[1] ;   // Dual timer interrupt 1
	assign irq[19]  = subsystem_interrupt[2] ;   // Dual timer interrupt 2
	assign irq[20]  = subsystem_interrupt[3] ;   // Dual timer combined interrupt
	assign irq[21]  = subsystem_interrupt[4] ;   // Uart 0 transmit interrupt
	assign irq[22]  = subsystem_interrupt[5] ;   // Uart 0 receive interrupt
	assign irq[23]  = subsystem_interrupt[6] ;   // Uart 0 transmit overflow interrupt
	assign irq[24]  = subsystem_interrupt[7] ;   // Uart 0 receive overflow interrupt
	assign irq[25]  = subsystem_interrupt[8] ;   // Uart 0 combined interrupt
	assign irq[26]  = subsystem_interrupt[9] ; 	 // Uart 1 transmit interrupt
	assign irq[27]  = subsystem_interrupt[10] ;  // Uart 1 receive interrupt
	assign irq[28]  = subsystem_interrupt[11] ;  // Uart 1 transmit overflow interrupt
	assign irq[29]  = subsystem_interrupt[12] ;  // Uart 1 receive overflow interrupt
	assign irq[30]  = subsystem_interrupt[13] ;  // Uart 1 combined interrupt

	assign irq[31] = 1'b0;


/***************************** SYSTEM INSTANTIATION **********************************/
//Cortex
CORTEXM0INTEGRATION U0_CORTEXM0INTEGRATION (
	.clk(HCLK),
	.rst(HRESETn|watchdog_reset), // watchdog_reset is ored with system reset
	.nTRST('b1),

	.HADDR(HADDRS0),
	.HBURST(HBURSTS0),
	.HMASTLOCK(HMASTLOCKS0),
	.HPROT(HPROTS0),
	.HSIZE(HSIZES0),
	.HTRANS(HTRANSS0),
	.HWDATA(HWDATAS0),
	.HWRITE(HWRITES0),
	.HRDATA(HRDATAS0),
	.HREADY(HREADYS0),
	.HRESP(HRESPS0),
	.HMASTER(),

	.CODENSEQ(),
	.CODEHINTDE(),
	.SPECHTRANS(),

	.SWDITMS(1'b1),
	.TDI(1'b1),
	.SWDO(),
	.SWDOEN(),
	.TDO(),
	.nTDOEN(),
	.DBGRESTART(1'b0),
	.DBGRESTARTED(),
	.EDBGRQ(1'b0),
	.HALTED(),

	.NMI(watchdog_interrupt),       
	.IRQ(irq),
	.TXEV(),
	.RXEV(1'b0),
	.LOCKUP(),
	.SYSRESETREQ(),
	.STCALIB(26'b10_0000_1111_0100_0010_0011_1111),
	.STCLKEN(1'b0),
	.IRQLATENCY(8'd0), // 
	.ECOREVNUM (8'd0), //

	.GATEHCLK(),
	.SLEEPING(),
	.SLEEPDEEP(),
	.WAKEUP(),
	.WICSENSE(),
	.SLEEPHOLDREQn(1'b1),
	.SLEEPHOLDACKn(),
	.WICENREQ(1'b0),
	.WICENACK(),
	.CDBGPWRUPREQ(),
	.CDBGPWRUPACK(1'b0),

	.SE(1'b1),
	.RSTBYPASS(1'b1)

); 
	

//RCC
RCC RCC_instance
(
   .HCLK(HCLK),
   .HRESETn(HRESETn),
   .APB_ACTIVE(APB_ACTIVE),
   .PCLK_PCLKG_DIV(8'd2),
   .TIMCLK_DIV(8'd2),
   .WDOGCLK_DIV(8'd2),
   .PCLK(PCLK),
   .PCLKG(PCLKG),
   .PRESETn(PRESETn),
   .TIMCLK(TIMCLK),
   .WDOGCLK(WDOGCLK),
   .WDOGRESn(WDOGRESn),
   .FCLK(FCLK)
);

//SRAM
Instruction_SRAM_TOP #(.AW(AW)) Instruction_SRAM_TOP_instance(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSELM0),
    .HREADY(HREADYMUXM0),
    .HTRANS(HTRANSM0),
    .HSIZE(HSIZEM0),
    .HWRITE(HWRITEM0),
    .HADDR(HADDRM0[AW-1:0]),
    .HWDATA(HWDATAM0),
    .HREADYOUT(HREADYOUTM0),
    .HRESP(HRESPM0),
    .HRDATA(HRDATAM0)
);

//DRAM
DATA_SRAM_TOP #(.AW(AW)) DATA_SRAM_TOP_instance(
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(HSELM1),
    .HREADY(HREADYMUXM1),
    .HTRANS(HTRANSM1),
    .HSIZE(HSIZEM1),
    .HWRITE(HWRITEM1),
    .HADDR(HADDRM1[AW-1:0]),
    .HWDATA(HWDATAM1),
    .HREADYOUT(HREADYOUTM1),
    .HRESP(HRESPM1),
    .HRDATA(HRDATAM1)
);

//APB subsystem
cmsdk_apb_subsystem #(.Include_dual_timer(Include_dual_timer))  cmsdk_apb_subsystem_instance(
	    .HCLK(HCLK),
	    .HRESETn(HRESETn),
	    .HSEL(HSELM2),
	    .HADDR(HADDRM2[15:0]),
	    .HTRANS(HTRANSM2),
	    .HWRITE(HWRITEM2),
	    .HSIZE(HSIZEM2),
	    .HPROT(HPROTM2),
	    .HREADY(HREADYMUXM2),
	    .HWDATA(HWDATAM2),
	    .HREADYOUT(HREADYOUTM2),
	    .HRDATA(HRDATAM2),
	    .HRESP(HRESPM2),
	    .PCLK(PCLK),
	    .PCLKG(PCLKG),
	    .PRESETn(PRESETn),
		.APB_ACTIVE(APB_ACTIVE)
		,.WDOGCLK(WDOGCLK)
  		,.WDOGRESn(WDOGRESn)
		,.TIMCLK(TIMCLK),
	    .TXD0 (TXD0),
	    .RXD0 (RXD0),  
	    .TXD0_EN(TXD0_EN),
		.TXD1 (TXD1),
	    .RXD1 (RXD1),  
	    .TXD1_EN(TXD1_EN),
	    .EXTIN(EXTIN),  
	    .subsystem_interrupt(subsystem_interrupt), 
	    .watchdog_interrupt(watchdog_interrupt),   
	    .watchdog_reset(watchdog_reset)            
	);


//GPIO
GPIO_HW cmsdk_ahb_gpio_instance (
	    .HCLK(HCLK),
	    .HRESETn(HRESETn),
	    .FCLK(FCLK),
	    .HSEL(HSELM3),
	    .HREADY(HREADYMUXM3),
	    .HTRANS(HTRANSM3),
	    .HSIZE(HSIZEM3),
	    .HWRITE(HWRITEM3),
	    .HADDR(HADDRM3[11:0]),
	    .HWDATA(HWDATAM3),
	    .ECOREVNUM('b0),
	    .HREADYOUT(HREADYOUTM3),
	    .HRESP(HRESPM3),
	    .HRDATA(HRDATAM3),
		.PORT_IN_OUT(SYSTEM_OUT),
	    .GPIOINT(GPIOINT),
	    .COMBINT(COMBINT)

);


//Bus matrix
AHB_BusMatrix_lite AHB_BusMatrix_lite_instance (
        .HCLK(HCLK),
	    .HRESETn(HRESETn),
	    .REMAP(4'b0), //Remapping signal is not used in our top module or system
	    .HADDRS0(HADDRS0),
	    .HTRANSS0(HTRANSS0),
	    .HWRITES0(HWRITES0),
	    .HSIZES0(HSIZES0),
	    .HBURSTS0(HBURSTS0),
	    .HPROTS0(HPROTS0),
	    .HWDATAS0(HWDATAS0),
	    .HMASTLOCKS0(HMASTLOCKS0),
	    
	    .HRDATAM0(HRDATAM0),
	    .HREADYOUTM0(HREADYOUTM0),
	    .HRESPM0(HRESPM0),
	    .HSELM0(HSELM0),
	    .HADDRM0(HADDRM0),
	    .HTRANSM0(HTRANSM0),
	    .HWRITEM0(HWRITEM0),
	    .HSIZEM0(HSIZEM0),
	    .HBURSTM0(HBURSTM0),
	    .HPROTM0(HPROTM0),
	    .HWDATAM0(HWDATAM0),
	    .HMASTLOCKM0(HMASTLOCKM0),
	    .HREADYMUXM0(HREADYMUXM0),
	    .HRDATAS0(HRDATAS0),
	    .HREADYS0(HREADYS0),
	    .HRESPS0(HRESPS0),

	    
	    .HRDATAM2(HRDATAM2),
	    .HREADYOUTM2(HREADYOUTM2),
	    .HRESPM2(HRESPM2),
	    .HSELM2(HSELM2),
	    .HADDRM2(HADDRM2),
	    .HTRANSM2(HTRANSM2),
	    .HWRITEM2(HWRITEM2),
	    .HSIZEM2(HSIZEM2),
	    .HBURSTM2(HBURSTM2),
	    .HPROTM2(HPROTM2),
	    .HWDATAM2(HWDATAM2),
	    .HMASTLOCKM2(HMASTLOCKM2),
	    .HREADYMUXM2(HREADYMUXM2),

		
		
		.HRDATAM3(HRDATAM3),
	    .HREADYOUTM3(HREADYOUTM3),
	    .HRESPM3(HRESPM3),
	    .HSELM3(HSELM3),
	    .HADDRM3(HADDRM3),
	    .HTRANSM3(HTRANSM3),
	    .HWRITEM3(HWRITEM3),
	    .HSIZEM3(HSIZEM3),
	    .HBURSTM3(HBURSTM3),
	    .HPROTM3(HPROTM3),
	    .HWDATAM3(HWDATAM3),
	    .HMASTLOCKM3(HMASTLOCKM3),
	    .HREADYMUXM3(HREADYMUXM3),

	    
	    .HRDATAM1(HRDATAM1),
	    .HREADYOUTM1(HREADYOUTM1),
	    .HRESPM1(HRESPM1),
	    .HSELM1(HSELM1),
	    .HADDRM1(HADDRM1),
	    .HTRANSM1(HTRANSM1),
	    .HWRITEM1(HWRITEM1),
	    .HSIZEM1(HSIZEM1),
	    .HBURSTM1(HBURSTM1),
	    .HPROTM1(HPROTM1),
	    .HWDATAM1(HWDATAM1),
	    .HMASTLOCKM1(HMASTLOCKM1),
	    .HREADYMUXM1(HREADYMUXM1),
	    .SCANENABLE(1'b0),
	    .SCANINHCLK(1'b0),
	    .SCANOUTHCLK()
);

	
	
endmodule