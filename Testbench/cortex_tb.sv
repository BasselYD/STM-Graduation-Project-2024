`timescale 1ns/1ps
module cortex_tb ();
                                        

reg HCLK;
reg HRESETn;
wire TXD0;
wire RXD0;
wire TXD0_EN;
wire TXD1;
reg  RXD1;
wire TXD1_EN;
reg EXTIN;

wire [15:0] SYSTEM_OUT;

localparam clk_period                = 20;
localparam pclk			     = 20*2;
            
/////clock generation///////
always #(clk_period/2) HCLK=~HCLK;


SYSTEM_TOP DUT (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .TXD0(TXD0),
    .RXD0(RXD0),
    .TXD0_EN(TXD0_EN),
    .TXD1(TXD1),
    .RXD1(RXD1),
    .TXD1_EN(TXD1_EN),
    .EXTIN(EXTIN),
    .SYSTEM_OUT(SYSTEM_OUT)
);


  integer i;
  localparam AW = 16;
  localparam MEM_SIZE = 2**(AW+2);
  localparam MEMFILE = "C:/Ain_shams/GP/Program/Scratch/main.mem";
  logic [8:0] fileimage [0:((MEM_SIZE)-1)];
  int depth = 4*1024;
  localparam width = 8;

task receive ;
  input [9:0] data ;
  integer i;
  begin
    for (i = 0 ; i < 10 ; i = i+1)
    begin
      RXD1 = data[i] ;
      repeat(32)
      #(pclk);
    end
    
  end
endtask


initial begin
    HCLK = 0;
    HRESETn = 0;
    EXTIN = 1;
    #100;
    HRESETn = 1;
    #10000;
    receive(10'b1100100110);
    #100000;
    $stop;

end
             
endmodule  
