#Compilation list

+incdir+../RTL/ahb_peripherals/apb_subsystem/watchdog
+incdir+../RTL/ahb_peripherals/apb_subsystem/dual_timer
+incdir+../RTL/ahb_peripherals/dma
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

#Spi files
../RTL/ahb_peripherals/apb_subsystem/spi/tri_state_buffer.v
../RTL/ahb_peripherals/apb_subsystem/spi/spi_master.v       
../RTL/ahb_peripherals/apb_subsystem/spi/spi_slave.v        
../RTL/ahb_peripherals/apb_subsystem/spi/spi_top.v          
../RTL/ahb_peripherals/apb_subsystem/spi/apb_spi_interface.v

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
../RTL/ahb_peripherals/gpio/GPIO_HW.sv


#Memory
../RTL/ahb_peripherals/memory/cmsdk_ahb_to_dsram.v
../RTL/ahb_peripherals/memory/cmsdk_ahb_to_isram.v
../RTL/ahb_peripherals/memory/cmsdk_fpga_dsram.v
../RTL/ahb_peripherals/memory/cmsdk_fpga_isram.v
../RTL/ahb_peripherals/memory/DATA_SRAM_TOP.v
../RTL/ahb_peripherals/memory/Instruction_SRAM_TOP.v

#RCC
../RTL/ahb_peripherals/rcc/CLK_DIV.v
../RTL/ahb_peripherals/rcc/RESET_SYNC.v
../RTL/ahb_peripherals/rcc/RCC.v
../RTL/ahb_peripherals/rcc/ahb_to_RCC.v


#DMA
../RTL/ahb_peripherals/dma/wb_to_ahb3lite.v    
../RTL/ahb_peripherals/dma/wb_dma_wb_slv.v     
../RTL/ahb_peripherals/dma/wb_dma_wb_mast.v    
../RTL/ahb_peripherals/dma/wb_dma_wb_if.v      
../RTL/ahb_peripherals/dma/wb_dma_top.v        
../RTL/ahb_peripherals/dma/wb_dma_rf.v         
../RTL/ahb_peripherals/dma/wb_dma_pri_enc_sub.v
../RTL/ahb_peripherals/dma/wb_dma_inc30r.v     
../RTL/ahb_peripherals/dma/wb_dma_defines.v    
../RTL/ahb_peripherals/dma/wb_dma_de.v         
../RTL/ahb_peripherals/dma/wb_dma_ch_sel.v     
../RTL/ahb_peripherals/dma/wb_dma_ch_rf.v      
../RTL/ahb_peripherals/dma/wb_dma_ch_pri_enc.v 
../RTL/ahb_peripherals/dma/wb_dma_ch_arb.v     
../RTL/ahb_peripherals/dma/ahb3lite_to_wb.v    
../RTL/ahb_peripherals/dma/ahb3lite_dma.sv     
################################################################


################################################################
#Cortex
../RTL/cortex/cortexm0ds_logic.v
../RTL/cortex/CORTEXM0INTEGRATION.v
################################################################

################################################################
#Bus matrix
#without DMA
../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_Arbiter.v
../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_InputStage.v
../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_OutputStage.v
../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_DecoderStageS0.v
../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_BusMatrix_default_slave.v
../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_BusMatrix.v
../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_BusMatrix_lite.v

#with DMA
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_Arbiter_DMA.v                
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_InputStage_DMA.v             
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_OutputStage_DMA.v            
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_DecoderStage_DMAS0.v         
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_DecoderStage_DMAS1.v         
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_BusMatrix_DMA_default_slave.v
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_BusMatrix_DMA.v              
../RTL/busmatrix/Bus_Matrix(DMA)/AHB_BusMatrix_DMA_lite.v         
################################################################

################################################################
#Top module
../RTL/top/SYSTEM_TOP.sv
################################################################














