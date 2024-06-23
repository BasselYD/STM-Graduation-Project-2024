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

#SPI files
project addfile ../RTL/ahb_peripherals/apb_subsystem/spi/spi_master.v        
project addfile ../RTL/ahb_peripherals/apb_subsystem/spi/spi_slave.v         
project addfile ../RTL/ahb_peripherals/apb_subsystem/spi/spi_top.v           
project addfile ../RTL/ahb_peripherals/apb_subsystem/spi/apb_spi_interface.v

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
project addfile ../RTL/ahb_peripherals/gpio/GPIO_HW.sv


#Memory
project addfile ../RTL/ahb_peripherals/memory/cmsdk_ahb_to_dsram.v
project addfile ../RTL/ahb_peripherals/memory/cmsdk_ahb_to_isram.v
project addfile ../RTL/ahb_peripherals/memory/cmsdk_fpga_dsram.v
project addfile ../RTL/ahb_peripherals/memory/cmsdk_fpga_isram.v
project addfile ../RTL/ahb_peripherals/memory/DATA_SRAM_TOP.v
project addfile ../RTL/ahb_peripherals/memory/Instruction_SRAM_TOP.v

#RCC
project addfile ../RTL/ahb_peripherals/rcc/RESET_SYNC.v
project addfile ../RTL/ahb_peripherals/rcc/CLK_DIV.v
project addfile ../RTL/ahb_peripherals/rcc/RCC.v
project addfile ../RTL/ahb_peripherals/rcc/ahb_to_RCC.v


#DMA
project addfile ../RTL/ahb_peripherals/dma/wb_to_ahb3lite.v        
project addfile ../RTL/ahb_peripherals/dma/wb_dma_wb_slv.v       
project addfile ../RTL/ahb_peripherals/dma/wb_dma_wb_mast.v      
project addfile ../RTL/ahb_peripherals/dma/wb_dma_wb_if.v        
project addfile ../RTL/ahb_peripherals/dma/wb_dma_top.v          
project addfile ../RTL/ahb_peripherals/dma/wb_dma_rf.v            
project addfile ../RTL/ahb_peripherals/dma/wb_dma_pri_enc_sub.v
project addfile ../RTL/ahb_peripherals/dma/wb_dma_inc30r.v      
project addfile ../RTL/ahb_peripherals/dma/wb_dma_defines.v     
project addfile ../RTL/ahb_peripherals/dma/wb_dma_de.v            
project addfile ../RTL/ahb_peripherals/dma/wb_dma_ch_sel.v          
project addfile ../RTL/ahb_peripherals/dma/wb_dma_ch_rf.v          
project addfile ../RTL/ahb_peripherals/dma/wb_dma_ch_pri_enc.v    
project addfile ../RTL/ahb_peripherals/dma/wb_dma_ch_arb.v       
project addfile ../RTL/ahb_peripherals/dma/ahb3lite_to_wb.v      
project addfile ../RTL/ahb_peripherals/dma/ahb3lite_dma.sv       
################################################################


################################################################
#Cortex
project addfile ../RTL/cortex/cortexm0ds_logic.v
project addfile ../RTL/cortex/CORTEXM0INTEGRATION.v
################################################################

################################################################
#Bus matrix

#with DMA

project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_Arbiter_DMA.v                  
project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_InputStage_DMA.v                
project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_OutputStage_DMA.v              
project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_DecoderStage_DMAS0.v          
project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_DecoderStage_DMAS1.v          
project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_BusMatrix_DMA_default_slave.v
project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_BusMatrix_DMA.v               
project addfile ../RTL/busmatrix/Bus_Matrix(DMA)/AHB_BusMatrix_DMA_lite.v          



#without DMA

project addfile ../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_Arbiter.v
project addfile ../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_InputStage.v
project addfile ../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_OutputStage.v
project addfile ../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_DecoderStageS0.v
project addfile ../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_BusMatrix_default_slave.v
project addfile ../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_BusMatrix.v
project addfile ../RTL/busmatrix/Bus_Matrix(No_DMA)/AHB_BusMatrix_lite.v

################################################################

################################################################
#Top module
project addfile ../RTL/top/SYSTEM_TOP.sv
################################################################














