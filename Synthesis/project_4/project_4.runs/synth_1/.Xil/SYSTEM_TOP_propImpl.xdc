set_property SRC_FILE_INFO {cfile:C:/Ain_shams/GP/Synthesis/project_4/project_4.srcs/constrs_1/imports/new/warnings.xdc rfile:../../../project_4.srcs/constrs_1/imports/new/warnings.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_multicycle_path -hold "[expr 2-1]" -from [get_clocks PCLK] -to [get_clocks HCLK]
set_property src_info {type:XDC file:1 line:58 export:INPUT save:INPUT read:READ} [current_design]
set_multicycle_path -hold "[expr [expr 2 * 2]-1]" -from [get_clocks WDOGCLK] -to [get_clocks HCLK]
set_property src_info {type:XDC file:1 line:59 export:INPUT save:INPUT read:READ} [current_design]
set_multicycle_path -hold "[expr [expr 2 * 2]-1]" -from [get_clocks TIMCLK] -to [get_clocks HCLK]
set_property src_info {type:XDC file:1 line:64 export:INPUT save:INPUT read:READ} [current_design]
set_multicycle_path -hold "[expr 2-1]" -from [get_clocks TIMCLK] -to [get_clocks PCLK]
set_property src_info {type:XDC file:1 line:65 export:INPUT save:INPUT read:READ} [current_design]
set_multicycle_path -hold "[expr 2 -1]" -from [get_clocks WDOGCLK] -to [get_clocks PCLK]
