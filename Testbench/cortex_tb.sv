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
wire MOSI;
wire MISO;
wire SCK;
wire SS0;
wire SS1;
wire SS2;
wire SS3;

wire RTS0;
reg CTS0;
wire RTS1;
reg CTS1;

wire [15:0] SYSTEM_OUT;

localparam clk_period                = 20;
localparam pclk			     = 20*2;
            


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
    .MOSI(MOSI),
    .MISO(MISO),
    .SCK(SCK),
    .SS0(SS0),
    .SS1(SS1),
    .SS2(SS2),
    .SS3(SS3),
    .RTS0(RTS0),
    .CTS0(CTS0),
    .RTS1(RTS1),
    .CTS1(CTS1),
    .SYSTEM_OUT(SYSTEM_OUT)
);


  integer i;
  //localparam AW = 16;
  //localparam MEM_SIZE = 2**(AW+2);
  //localparam MEMFILE = "C:/Ain_shams/GP/Program/Scratch/main.mem";
  //logic [8:0] fileimage [0:((MEM_SIZE)-1)];
  //int depth = 4*1024;
  //localparam width = 8;

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
//Clock generation
initial begin
  HCLK =   0;
  forever begin
    #(clk_period/2) HCLK = !HCLK;
  end
end


initial begin
  fork
    begin
    HRESETn = 0;
    EXTIN = 1;
    #100;
    HRESETn = 1;
    #100000;
    $stop;
    end
    begin
      forever begin
        @(negedge HCLK);
        if(RTS) begin
          receive({1'b1, 8'hFF, 1'b0});
          receive({1'b1, 8'hAA, 1'b0});
          receive({1'b1, 8'hBB, 1'b0});
          receive({1'b1, 8'hCC, 1'b0});
          receive({1'b1, 8'h00, 1'b0});
        end
      end
    end
  join
    
end
             
endmodule  
