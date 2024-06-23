module RCC #(parameter scale1 = 8 ,scale2 = 8 ,scale3 = 8 ,RESET_WDOG = 2 ,RESET_APB = 2)(

input             HCLK ,
input             HRESETn,
input             APB_ACTIVE ,
input [31:0]      HWDATA,
input             HSEL,
input             HRESP,
input             HSEL_REG,
input             HWRITE,
input             HWRITE_REG,
input [2:0]       HSIZE,
input [2:0]       HSIZE_REG,
output reg [31:0] HRDATA_REG ,
output            PCLK,
output            PCLKG,
output            PRESETn,
output            TIMCLK,
output            WDOGCLK,
output            WDOGRESn,
output            FCLK
);	


reg [31:0] scales ; // [7:0  ] PCLK scale
                    // [15:8 ] TIMCLK scale
                    // [23:16] WDOGCLK scale
                    // [31:24] reserved

always@(posedge HCLK or negedge HRESETn)
begin
  if (!HRESETn)
  scales <= 32'h00020202;
  else if (HSEL_REG && HWRITE_REG)
  begin
    if(HSIZE_REG == 3'b0)
    scales <= {scales[31:8],HWDATA[7:0]};
    else if(HSIZE_REG == 3'b1)
    scales <= {scales[31:16],HWDATA[15:0]};
    else
    scales <= HWDATA ;
  end
end



always@(posedge HCLK or negedge HRESETn)
begin
  if (!HRESETn)
  HRDATA_REG <= 32'b0;
  else if (HSEL && !HWRITE && !HRESP)
  begin
    if(HSIZE == 3'b0)
    HRDATA_REG <= {24'b0,scales[7:0]};
    else if(HSIZE == 3'b1)
    HRDATA_REG <= {16'b0,scales[15:0]};
    else
    HRDATA_REG <= scales ;
  end
  else 
  HRDATA_REG <= 32'b0;
end


 

assign  FCLK=HCLK; 

(*gated_clock = "true"*)
assign PCLKG = APB_ACTIVE & PCLK;

CLKDIV #(.width(scale1)) PCLK_Divider (

  .REF_CLK(HCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(scales[7:0]) ,
  .OUT_CLK(PCLK));


CLKDIV #(.width(scale3)) WDOGCLK_Divider (

  .REF_CLK(PCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(scales[23:16]) ,
  .OUT_CLK(WDOGCLK));


CLKDIV #(.width(scale2)) TIMCLK_Divider (

  .REF_CLK(PCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(scales[15:8]) ,
  .OUT_CLK(TIMCLK));



RESET_SYNC #(.NUM_STAGES(RESET_WDOG)) WDOG_RESET (
.RESET(HRESETn),
.CLK  (WDOGCLK),
.SYNC_RESET (WDOGRESn));


RESET_SYNC #(.NUM_STAGES(RESET_APB)) APB_RESET (
.RESET(HRESETn),
.CLK  (PCLK),
.SYNC_RESET (PRESETn));


endmodule

 


