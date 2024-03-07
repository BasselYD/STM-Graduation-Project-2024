module GPIO_HW (
   input  wire                 HCLK,      // system bus clock
   input  wire                 HRESETn,   // system bus reset
   input  wire                 FCLK,      // system bus clock
   input  wire                 HSEL,      // AHB peripheral select
   input  wire                 HREADY,    // AHB ready input
   input  wire  [1:0]          HTRANS,    // AHB transfer type
   input  wire  [2:0]          HSIZE,     // AHB hsize
   input  wire                 HWRITE,    // AHB hwrite
   input  wire [11:0]          HADDR,     // AHB address bus
   input  wire [31:0]          HWDATA,    // AHB write data bus
   input wire  [3:0]           ECOREVNUM,  // Engineering-change-order revision bits
   // AHB Outputs
   output wire                 HREADYOUT, // AHB ready output to S->M mux
   output wire                 HRESP,     // AHB response
   output wire [31:0]          HRDATA,

   inout wire [15:0]           PORT_IN_OUT,
   output wire [15:0]          GPIOINT,
   output wire                 COMBINT
   
);

wire [15:0] PORTOUT;
wire [15:0] PORTEN;
wire [15:0] PORTFUNC;
wire [15:0] TRI_BUFF_SEL;
wire [15:0] TRI_BUFF_IN;
genvar i;

cmsdk_ahb_gpio GPIO (
   .HCLK(HCLK),      // system bus clock
   .HRESETn(HRESETn),   // system bus reset
   .FCLK(FCLK),      // system bus clock
   .HSEL(HSEL),      // AHB peripheral select
   .HREADY(HREADY),    // AHB ready input
   .HTRANS(HTRANS),    // AHB transfer type
   .HSIZE(HSIZE),     // AHB hsize
   .HWRITE(HWRITE),    // AHB hwrite
   .HADDR(HADDR),     // AHB address bus
   .HWDATA(HWDATA),    // AHB write data bus
   .ECOREVNUM(ECOREVNUM),  // Engineering-change-order revision bits
   .PORTIN(PORT_IN_OUT),     // GPIO Interface input
   .HREADYOUT(HREADYOUT), // AHB ready output to S->M mux
   .HRESP(HRESP),     // AHB response
   .HRDATA(HRDATA),
   .PORTOUT(PORTOUT),    // GPIO output
   .PORTEN(PORTEN),     // GPIO output enable
   .PORTFUNC(PORTFUNC),   // Alternate function control
   .GPIOINT(GPIOINT),    // Interrupt output for each pin
   .COMBINT(COMBINT)
);


 // Generate block for instantiating 16 muxes (tri-state buffer input)
  generate
    for (i = 0; i < 16; i = i + 1) begin
      mux_2x1 mux_input_i (
        .A(PORTOUT[i]),
        .B(0), // should be alternate function
        .Sel(PORTFUNC[i]),
        .C(TRI_BUFF_IN[i])
      );
    end
  endgenerate

 // Generate block for instantiating 16 muxes (tri-state buffer selector)
  generate
    for (i = 0; i < 16; i = i + 1) begin
      mux_2x1 mux_sel_i (
        .A(PORTEN[i]),
        .B(0), // should be alternate function
        .Sel(PORTFUNC[i]),
        .C(TRI_BUFF_SEL[i])
      );
    end
  endgenerate

  // Generate block for instantiating 16 tri-state buffers to connect output
  generate
    for (i = 0; i < 16; i = i + 1) begin
      tri_state_buffer tri_buffer_i (
        .enable(TRI_BUFF_SEL[i]),
        .data_in(TRI_BUFF_IN[i]),
        .data_out(PORT_IN_OUT[i])
      );
    end
  endgenerate

endmodule
