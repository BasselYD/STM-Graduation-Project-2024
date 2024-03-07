module RCC #(parameter scale1 = 8 ,scale2 = 8 ,scale3 = 8 ,RESET_WDOG = 2 ,RESET_APB = 2)(

input    HCLK , HRESETn,APB_ACTIVE ,
input   [scale1 - 1 : 0 ]      PCLK_PCLKG_DIV ,
input   [scale2 - 1 : 0 ]      TIMCLK_DIV ,
input   [scale3 - 1 : 0 ]      WDOGCLK_DIV ,

output PCLK,PCLKG,PRESETn,TIMCLK,WDOGCLK,WDOGRESn,FCLK
);	


assign  FCLK=HCLK; // Free running Clock is same as HCLK in this design.

/*
CLK_GATE GATE(
  .CLK_EN(APB_ACTIVE),
  .CLK(PCLK),
  .GATED_CLK(PCLKG)
);*/

(*gated_clock = "true"*)
assign PCLKG = APB_ACTIVE * PCLK;

CLKDIV #(.width(scale1)) PCLK_Divider (

  .REF_CLK(HCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(PCLK_PCLKG_DIV) ,
  .OUT_CLK(PCLK));


CLKDIV #(.width(scale3)) WDOGCLK_Divider (

  .REF_CLK(PCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(WDOGCLK_DIV) ,
  .OUT_CLK(WDOGCLK));


CLKDIV #(.width(scale2)) TIMCLK_Divider (

  .REF_CLK(PCLK) ,
  .RST(HRESETn) ,
  .DIV_RATIO(TIMCLK_DIV) ,
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

 


