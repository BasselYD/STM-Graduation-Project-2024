#Add project files
do ../Compilation/add_files.do

#Create new library
vlib ../Scratch/scratch_rtl

#Mapping library
vmap work ../Scratch/scratch_rtl

#Compile files,dump transcirpt in transcript file , allow all signal visibility using vopt
vlog -vopt +acc -l ../Scratch/transcript -work ../Scratch/scratch_rtl -F ../Compilation/compile_list.f
