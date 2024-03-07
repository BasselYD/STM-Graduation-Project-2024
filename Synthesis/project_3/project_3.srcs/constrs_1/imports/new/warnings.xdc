#Delay percentage
set delay 0.2
set o_delay 0.05
set period 10
set half [expr $period*0.5]
set pdiv 2

set pclk [expr $period * $pdiv]
set wdogdiv 2
set timdiv 2

set wdogclk [expr $pclk * $wdogdiv]
set timclk [expr $pclk * $timdiv]
set h_delay [expr $period * $delay]
set p_delay [expr $pclk * $delay]
set w_delay [expr $wdogclk * $delay]
set t_delay [expr $timclk * $delay]

set oh_delay [expr $period * $o_delay]
set op_delay [expr $pclk * $o_delay]
set ow_delay [expr $wdogclk * $o_delay]
set ot_delay [expr $timclk * $o_delay]

create_clock -period $period -name HCLK -waveform "0.000 $half" [get_ports HCLK]
create_generated_clock -name PCLK -source [get_ports HCLK] -divide_by $pdiv [get_pins RCC_instance/PCLK_Divider/div_clk_reg/Q]
create_generated_clock -name TIMCLK -source [get_pins RCC_instance/PCLK] -divide_by $timdiv [get_pins RCC_instance/TIMCLK_Divider/div_clk_reg/Q]
create_generated_clock -name WDOGCLK -source [get_pins RCC_instance/PCLK] -divide_by $wdogdiv [get_pins RCC_instance/WDOGCLK_Divider/div_clk_reg/Q]
create_generated_clock -name FCLK -source [get_ports HCLK] -divide_by 1 [get_pins RCC_instance/FCLK]
create_generated_clock -name PCLKG -source [get_pins RCC_instance/PCLK_Divider/div_clk_reg/Q] -divide_by 1 [get_pins RCC_instance/PCLKG]

set_input_delay -clock [get_clocks HCLK] -min -add_delay $h_delay [get_ports {SYSTEM_OUT[*]}]
set_input_delay -clock [get_clocks HCLK] -max -add_delay $h_delay [get_ports {SYSTEM_OUT[*]}]
set_input_delay -clock [get_clocks PCLK] -min -add_delay $p_delay [get_ports EXTIN]
set_input_delay -clock [get_clocks PCLK] -max -add_delay $p_delay [get_ports EXTIN]
set_input_delay -clock [get_clocks HCLK] -min -add_delay $h_delay [get_ports HRESETn]
set_input_delay -clock [get_clocks HCLK] -max -add_delay $h_delay [get_ports HRESETn]
set_input_delay -clock [get_clocks PCLK] -min -add_delay $p_delay  [get_ports HRESETn]
set_input_delay -clock [get_clocks PCLK] -max -add_delay $p_delay  [get_ports HRESETn]
set_input_delay -clock [get_clocks WDOGCLK] -min -add_delay $w_delay [get_ports HRESETn]
set_input_delay -clock [get_clocks WDOGCLK] -max -add_delay $w_delay [get_ports HRESETn]
set_input_delay -clock [get_clocks PCLK] -min -add_delay $p_delay [get_ports RXD0]
set_input_delay -clock [get_clocks PCLK] -max -add_delay $w_delay [get_ports RXD0]
set_input_delay -clock [get_clocks PCLK] -min -add_delay $w_delay [get_ports RXD1]
set_input_delay -clock [get_clocks PCLK] -max -add_delay $w_delay [get_ports RXD1]

set_output_delay -clock [get_clocks HCLK] -min -add_delay $oh_delay [get_ports {SYSTEM_OUT[*]}]
set_output_delay -clock [get_clocks HCLK] -max -add_delay $h_delay [get_ports {SYSTEM_OUT[*]}]
set_output_delay -clock [get_clocks PCLK] -min -add_delay $op_delay [get_ports TXD0]
set_output_delay -clock [get_clocks PCLK] -max -add_delay $p_delay [get_ports TXD0]
set_output_delay -clock [get_clocks PCLK] -min -add_delay $op_delay [get_ports TXD0_EN]
set_output_delay -clock [get_clocks PCLK] -max -add_delay $p_delay [get_ports TXD0_EN]
set_output_delay -clock [get_clocks PCLK] -min -add_delay $op_delay [get_ports TXD1]
set_output_delay -clock [get_clocks PCLK] -max -add_delay $p_delay [get_ports TXD1]
set_output_delay -clock [get_clocks PCLK] -min -add_delay $op_delay [get_ports TXD1_EN]
set_output_delay -clock [get_clocks PCLK] -max -add_delay $p_delay [get_ports TXD1_EN]

set_multicycle_path -hold "[expr $pdiv-1]" -from [get_clocks PCLK] -to [get_clocks HCLK]
set_multicycle_path -hold "[expr [expr $pdiv * $wdogdiv]-1]" -from [get_clocks WDOGCLK] -to [get_clocks HCLK]
set_multicycle_path -hold "[expr [expr $pdiv * $timdiv]-1]" -from [get_clocks TIMCLK] -to [get_clocks HCLK]
set_multicycle_path -setup $pdiv -from [get_clocks PCLK] -to [get_clocks HCLK]
set_multicycle_path -setup "[expr $pdiv * $wdogdiv]" -from [get_clocks WDOGCLK] -to [get_clocks HCLK]
set_multicycle_path -setup "[expr $pdiv * $timdiv]" -from [get_clocks TIMCLK] -to [get_clocks HCLK]

set_multicycle_path -hold "[expr $timdiv-1]" -from [get_clocks TIMCLK] -to [get_clocks PCLK]
set_multicycle_path -hold "[expr $wdogdiv -1]" -from [get_clocks WDOGCLK] -to [get_clocks PCLK]
set_multicycle_path -setup $timdiv -from [get_clocks TIMCLK] -to [get_clocks PCLK]
set_multicycle_path -setup $wdogdiv -from [get_clocks WDOGCLK] -to [get_clocks PCLK]


set_clock_latency 0.3 [get_clocks HCLK]
set_clock_latency 0.3 [get_clocks PCLK]
set_clock_latency 0.3 [get_clocks WDOGCLK]
set_clock_latency 0.3 [get_clocks TIMCLK]
set_clock_latency 0.3 [get_clocks FCLK]
set_clock_latency 0.3 [get_clocks PCLKG]

