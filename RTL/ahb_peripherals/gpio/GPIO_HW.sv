module GPIO_HW  #(// Parameter to define valid bit pattern for Alternate functions

   // If an I/O pin does not have alternate function its function mask
   // can be set to 0 to reduce gate count.
   //
   // By default every bit can have alternate function
   parameter  ALTERNATE_FUNC_MASK = 16'hFFFF,

   // Default alternate function settings
   parameter  ALTERNATE_FUNC_DEFAULT = 16'h0000,

   // By default use little endian
   parameter  BE                  = 0,

   // The GPIO width by default is 16-bit, but is coded in a way that it is
   // easy to customise the width.
   parameter  PORTWIDTH                      = 16,
   parameter  ALTFUNC                        =  4

  )
   (
   input  wire                                    HCLK,       // system bus clock
   input  wire                                    HRESETn,    // system bus reset
   input  wire                                    FCLK,       // system bus clock
   input  wire                                    HSEL,       // AHB peripheral select
   input  wire                                    HREADY,     // AHB ready input
   input  wire  [1:0]                             HTRANS,     // AHB transfer type
   input  wire  [2:0]                             HSIZE,      // AHB hsize
   input  wire                                    HWRITE,     // AHB hwrite
   input  wire  [11:0]                            HADDR,      // AHB address bus
   input  wire  [31:0]                            HWDATA,     // AHB write data bus
   input  wire  [3:0]                             ECOREVNUM,  // Engineering-change-order revision bits
   output  wire  [(PORTWIDTH*ALTFUNC)-1:0]        ALT_FUNC_IN,
   input   wire  [(PORTWIDTH*ALTFUNC)-1:0]        ALT_FUNC_OUT,
   output wire                                    HREADYOUT,  // AHB ready output to S->M mux
   output wire                                    HRESP,      // AHB response
   output wire [31:0]                             HRDATA,
   input  wire                                    enable_master,
   inout  wire [PORTWIDTH-1:0]                    SYSTEM_OUT,
   output wire [PORTWIDTH-1:0]                    GPIOINT,
   output wire                                    COMBINT
 
);
localparam sel_bits = $clog2(ALTFUNC);
wire  [PORTWIDTH-1:0] PORTOUT;
wire  [PORTWIDTH-1:0] PORTEN;
wire  [PORTWIDTH-1:0] PORTFUNC;
wire  [PORTWIDTH-1:0] PORTIN;
wire   [sel_bits - 1:0] selector_bits [PORTWIDTH-1 : 0];
wire  [PORTWIDTH * $clog2(ALTFUNC) - 1:0] altfunc_select_in;   // Alternate function selection lines
genvar i;
genvar j;

cmsdk_ahb_gpio #(
    .ALTERNATE_FUNC_MASK     (ALTERNATE_FUNC_MASK),
    .ALTERNATE_FUNC_DEFAULT  (ALTERNATE_FUNC_DEFAULT), // All pins default to GPIO
    .BE                      (BE),
    .PORTWIDTH               (PORTWIDTH),
    .ALTFUNC                 (ALTFUNC)  
    )
    GPIO (
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
   .PORTIN(PORTIN),     // GPIO Interface input
   .HREADYOUT(HREADYOUT), // AHB ready output to S->M mux
   .HRESP(HRESP),     // AHB response
   .HRDATA(HRDATA),
   .PORTOUT(PORTOUT),    // GPIO output
   .PORTEN(PORTEN),     // GPIO output enable
   .PORTFUNC(PORTFUNC),   // Alternate function control
   .ALT_FUNC(altfunc_select_in),  // Alternate function selector
   .GPIOINT(GPIOINT),    // Interrupt output for each pin
   .COMBINT(COMBINT)
);
        wire  [PORTWIDTH-1:0] enable;
        wire  [PORTWIDTH-1:0] TRI_OUT;
        wire  [PORTWIDTH-1:0] sys_out_buff_in;
        wire  [PORTWIDTH-1:0] S_M;


        assign S_M = enable_master ? 15'b000011111111101 : 15'b000011111110010;
        
generate
 
    for (j = 0; j < PORTWIDTH; j = j + 1) begin
      assign   selector_bits[j] = altfunc_select_in[(j * sel_bits) + sel_bits - 1:j * sel_bits];
      assign   sys_out_buff_in[j] = PORTFUNC[j]? ALT_FUNC_OUT[(selector_bits[j]*PORTWIDTH)+ j] : PORTOUT[j];
      assign   PORTIN[j] = PORTEN? 1'b0: SYSTEM_OUT[j] ;
      assign   ALT_FUNC_IN[j] = PORTFUNC[j] ? SYSTEM_OUT[j] : 1'b1;
    end
endgenerate
 
generate
    for (j = 0; j < PORTWIDTH; j = j + 1) 
    begin
      assign enable[j] = PORTFUNC[j]?  S_M[j]: PORTEN[j];
    end
endgenerate


  generate
    for (i = 0; i < PORTWIDTH; i = i + 1) begin
      tri_state_buffer tri_buffer_i (
        .enable(enable[i]),
        .data_in(sys_out_buff_in[i]),
        .data_out(SYSTEM_OUT[i])
      );
    end
  endgenerate
assign PORTIN = TRI_OUT;
endmodule