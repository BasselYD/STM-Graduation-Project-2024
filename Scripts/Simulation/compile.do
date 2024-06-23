#Add project files
do ../Compilation/add_files.do

#Create new library
vlib ../asic/asic_rtl

#Mapping library
vmap work ../asic/asic_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../asic/transcript -suppress 2263  -work ../asic/asic_rtl -F ../Compilation/compile_list.f -lint
