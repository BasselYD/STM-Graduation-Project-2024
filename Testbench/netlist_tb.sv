`timescale 1ns/1ps
module netlist_tb ();
                                        

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
  for(int i = 0; i<MEM_SIZE; i++) begin
    fileimage[i] = 8'b0;
  end
  $readmemh(MEMFILE,fileimage);

  for(int i = 1; i < 9; i++ ) begin :looping_on_instance
    for(int w = 0; w < depth-1 ; w++) begin :looping_on_depth
      for(int k=0; k< width ; k++) begin :looping_on_width
      case(i)
      1:begin
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_1.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_1.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_1.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_1.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      2:begin
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_2.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_2.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_2.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_2.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      3:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_3.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_3.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_3.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_3.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      4:begin
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_4.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_4.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_4.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_4.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      5:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_5.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_5.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_5.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_5.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      6:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_6.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_6.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_6.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_6.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      7:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_7.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_7.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_7.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_7.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      8:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_8.mem[w*width+k] = fileimage[4*w+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_8.mem[w*width+k] = fileimage[4*w+1+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_8.mem[w*width+k] = fileimage[4*w+2+(i-1)*depth][k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_8.mem[w*width+k] = fileimage[4*w+3+(i-1)*depth][k];
      end 
      endcase
      end :looping_on_width
    end :looping_on_depth
  end :looping_on_instance

  ///////////////////////////////////////////////////////////////////////////

  for(int i = 1; i < 9; i++ ) begin :looping_on_instance
    for(int w = 0; w < depth-1 ; w++) begin :looping_on_depth
      for(int k=0; k< 1 ; k++) begin :looping_on_width
      case(i)
      1:begin
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_1.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_1.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_1.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_1.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      2:begin
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_2.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_2.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_2.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_2.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      3:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_3.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_3.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_3.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_3.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      4:begin
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_4.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_4.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_4.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_4.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      5:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_5.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_5.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_5.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_5.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      6:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_6.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_6.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_6.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_6.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      7:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_7.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_7.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_7.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_7.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      8:begin 
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM0_reg_bram_8.memp[w+k] = fileimage[4*w+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM1_reg_bram_8.memp[w+k] = fileimage[4*w+1+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM2_reg_bram_8.memp[w+k] = fileimage[4*w+2+(i-1)*depth][width+k];
          DUT.Instruction_SRAM_TOP_instance.U0_cmsdk_fpga_isram.BRAM3_reg_bram_8.memp[w+k] = fileimage[4*w+3+(i-1)*depth][width+k];
      end 
      endcase
      end :looping_on_width
    end :looping_on_depth
  end :looping_on_instance
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
