#Compilation list

+incdir+../RTL/ahb_peripherals/apb_subsystem/watchdog
+incdir+../RTL/ahb_peripherals/apb_subsystem/dual_timer
+incdir+../RTL/bus_matrix/bus_matrix_defs.v
################################################################
#APB_SUBSYTEM

#Watchdog files
../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog_defs.v
../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog_frc.v
../RTL/ahb_peripherals/apb_subsystem/watchdog/cmsdk_apb_watchdog.v

#Dual timer files
../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers_defs.v
../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers_frc.v
../RTL/ahb_peripherals/apb_subsystem/dual_timer/cmsdk_apb_dualtimers.v

#Timer files
../RTL/ahb_peripherals/apb_subsystem/timer/cmsdk_apb_timer.v

#Uart files
../RTL/ahb_peripherals/apb_subsystem/uart/cmsdk_apb_uart.v

#Bridge files
../RTL/ahb_peripherals/apb_subsystem/bridge/APB_Bridge.v

#Subsystem extras
../RTL/ahb_peripherals/apb_subsystem/subsystem_top/APB_decoder.v
../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_irq_sync.v
../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_slave_mux.v
../RTL/ahb_peripherals/apb_subsystem/subsystem_top/cmsdk_apb_subsystem.v

################################################################


################################################################
#AHB system

#Gpio
../RTL/ahb_peripherals/gpio/mux_2x1.v
../RTL/ahb_peripherals/gpio/tri_state_buffer.v
../RTL/ahb_peripherals/gpio/cmsdk_iop_gpio.v
../RTL/ahb_peripherals/gpio/cmsdk_ahb_to_iop.v
../RTL/ahb_peripherals/gpio/cmsdk_ahb_gpio.v
../RTL/ahb_peripherals/gpio/GPIO_HW.v

#Memory
../RTL/ahb_peripherals/memory/cmsdk_ahb_to_dsram.v
../RTL/ahb_peripherals/memory/cmsdk_ahb_to_isram.v
../RTL/ahb_peripherals/memory/cmsdk_fpga_dsram.v
../RTL/ahb_peripherals/memory/cmsdk_fpga_isram.v
../RTL/ahb_peripherals/memory/DATA_SRAM_TOP.v
../RTL/ahb_peripherals/memory/Instruction_SRAM_TOP.v

#RCC
../RTL/ahb_peripherals/rcc/CLKDIV.v
../RTL/ahb_peripherals/rcc/CLK_GATE.v
../RTL/ahb_peripherals/rcc/RESET_SYNC.v
../RTL/ahb_peripherals/rcc/RCC.v
################################################################


################################################################
#Cortex
../RTL/cortex/cortexm0ds_logic.v
../RTL/cortex/CORTEXM0INTEGRATION.v
################################################################

################################################################
#Bus matrix
../RTL/bus_matrix/bus_matrix_defs.v
../RTL/bus_matrix/AHB_Arbiter.v
../RTL/bus_matrix/AHB_InputStage.v
../RTL/bus_matrix/AHB_OutputStage.v
../RTL/bus_matrix/AHB_DecoderStageS0.v
../RTL/bus_matrix/AHB_BusMatrix_default_slave.v
../RTL/bus_matrix/AHB_BusMatrix.v
../RTL/bus_matrix/AHB_BusMatrix_lite.v
################################################################

################################################################
#Top module
../RTL/top/SYSTEM_TOP.v
################################################################

################################################################
#Testbench files
../Testbench/bridge_test.sv
../Testbench/cortex_tb.sv
../Testbench/dualtimers_tb.sv
../Testbench/gpio_tb.sv
../Testbench/subsystem_tb.sv
../Testbench/timer_tb.sv
../Testbench/uart_tb.sv
../Testbench/watchdog_tb.sv
################################################################












