#Add project files
do ../Compilation/add_files.do

#Create new library
vlib ../zynq/zynq_rtl

#Mapping library
vmap work ../zynq/zynq_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../zynq/transcript -suppress 2263  -work ../zynq/zynq_rtl -F ../Compilation/compile_list.f
