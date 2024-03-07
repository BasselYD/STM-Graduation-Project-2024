#Compilation list

################################################################
#APB_SUBSYTEM

#Watchdog files
project addfile ../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog_defs.v
project addfile ../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog_frc.v
project addfile ../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog.v

#Dual timer files
project addfile ../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers_defs.v
project addfile ../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers_frc.v
project addfile ../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers.v

#Timer files
project addfile ../RTL/ahb_peripherals/apb_subsystem/timer/cmsdk_apb_timer.v

#Uart files
project addfile ../RTL/ahb_peripherals/apb_subsystem/uart/cmsdk_apb_uart.v

#Bridge files
project addfile ../RTL/ahb_peripherals/apb_subsystem/bridge/APB_Bridge.v

#Subsystem extras
project addfile ../RTL/ahb_peripherals/apb_subsystem/subsystem_top/APB_decoder.v
project addfile ../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_irq_sync.v
project addfile ../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_slave_mux.v
project addfile ../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_subsystem.v

################################################################


################################################################
#AHB system

#Gpio
project addfile ../RTL/ahb_peripherals/gpio/mux_2x1.v
project addfile ../RTL/ahb_peripherals/gpio/tri_state_buffer.v
project addfile ../RTL/ahb_peripherals/gpio/cmsdk_iop_gpio.v
project addfile ../RTL/ahb_peripherals/gpio/cmsdk_ahb_to_iop.v
project addfile ../RTL/ahb_peripherals/gpio/cmsdk_ahb_gpio.v
project addfile ../RTL/ahb_peripherals/gpio/GPIO_HW.v

#Memory
project addfile ../RTL/ahb_peripherals/memory/cmsdk_ahb_to_dsram.v
project addfile ../RTL/ahb_peripherals/memory/cmsdk_ahb_to_isram.v
project addfile ../RTL/ahb_peripherals/memory/cmsdk_fpga_dsram.v
project addfile ../RTL/ahb_peripherals/memory/cmsdk_fpga_isram.v
project addfile ../RTL/ahb_peripherals/memory/DATA_SRAM_TOP.v
project addfile ../RTL/ahb_peripherals/memory/Instruction_SRAM_TOP.v

#RCC
project addfile ../RTL/ahb_peripherals/rcc/CLKDIV.v
project addfile ../RTL/ahb_peripherals/rcc/CLK_GATE.v
project addfile ../RTL/ahb_peripherals/rcc/RESET_SYNC.v
project addfile ../RTL/ahb_peripherals/rcc/RCC.v
################################################################


################################################################
#Cortex
project addfile ../RTL/cortex/cortexm0ds_logic.v
project addfile ../RTL/cortex/CORTEXM0INTEGRATION.v
################################################################

################################################################
#Bus matrix
project addfile ../RTL/bus_matrix/bus_matrix_defs.v
project addfile ../RTL/bus_matrix/AHB_Arbiter.v
project addfile ../RTL/bus_matrix/AHB_InputStage.v
project addfile ../RTL/bus_matrix/AHB_OutputStage.v
project addfile ../RTL/bus_matrix/AHB_DecoderStageS0.v
project addfile ../RTL/bus_matrix/AHB_BusMatrix_default_slave.v
project addfile ../RTL/bus_matrix/AHB_BusMatrix.v
project addfile ../RTL/bus_matrix/AHB_BusMatrix_lite.v
################################################################

################################################################
#Top module
project addfile ../RTL/top/SYSTEM_TOP.v
################################################################

################################################################
#Testbench files
project addfile ../Testbench/bridge_test.sv
project addfile ../Testbench/cortex_tb.sv
project addfile ../Testbench/dualtimers_tb.sv
project addfile ../Testbench/gpio_tb.sv
project addfile ../Testbench/subsystem_tb.sv
project addfile ../Testbench/timer_tb.sv
project addfile ../Testbench/uart_tb.sv
project addfile ../Testbench/watchdog_tb.sv
################################################################











