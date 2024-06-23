#Add project files
do ../Compilation/add_files.do

#Create new library
vlib ../fpga/fpga_rtl

#Mapping library
vmap work ../fpga/fpga_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../fpga/transcript -suppress 2263  -work ../fpga/fpga_rtl -F ../Compilation/compile_list.f
