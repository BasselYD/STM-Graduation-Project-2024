/**************************************************************************//**
 * @file     blinky.c
 * @brief    Demonstrate minimum program blinking LED1
 * @date     12. August 2018
 ******************************************************************************/
/*
 * Copyright (c) 2018 Milosch Meriac <milosch@meriac.com>. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include <stdint.h>

#include "system_macros.h"
#include "dma_driver.h"
#include "gpio_driver.h"
#include "watchdog_driver.h"
#include "timer_driver.h"
#include "dualtimer_driver.h"
#include "serial.h"
#include "spi_serial.h"

#define TICK_S 25000000

extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;


/// global flags for interrupt functions
int semaphore = 0;
int semaphore_rx = 0;

char str1[20];
char* str2;

watchdog_configuration WDog_Config;
timer_configuration Timer_Config;
uart_configuration UART0_Config;
uart_configuration UART1_Config;
gpio_configuration GPIO_Config;
dma_ch_csr_config DMA_Config;
spi_configuration SPI_Config;

void SystemInit(void) {

    NVIC_EnableIRQ(21); //TX0 Interrupt enable 
    NVIC_EnableIRQ(27); //RX1 Interrupt enable 

    UART0_Config.divider = 16;      
    UART0_Config.tx_en = 1;
    UART0_Config.rx_en = 0;
    UART0_Config.tx_irq_en = 1;
    UART0_Config.rx_irq_en = 0;
    UART0_Config.tx_ovrirq_en = 1;
    UART0_Config.rx_ovrirq_en = 0;
    uart_config( UART0, &UART0_Config);
    
    UART1_Config.divider = 32;
    UART1_Config.tx_en = 0;
    UART1_Config.rx_en = 1;
    UART1_Config.tx_irq_en = 0;
    UART1_Config.rx_irq_en = 1;
    UART1_Config.tx_ovrirq_en = 0;
    UART1_Config.rx_ovrirq_en = 1;
    uart_config( UART1, &UART1_Config);

    DMA_Config.INE_CHK_DONE = 0;
    DMA_Config.INE_DONE = 0;
    DMA_Config.INE_ERROR = 0;
    DMA_Config.REST_EN = 0;
    DMA_Config.ChannelPriority = 0;
    DMA_Config.STOP = 0;
    DMA_Config.SZ_WB = 0;
    DMA_Config.ARS = 0;
    DMA_Config.MODE = 0;
    DMA_Config.INC_SRC = 1;
    DMA_Config.INC_DST = 1;
    DMA_Config.CH_EN = 0;

    DMA_enable(CMSDK_DMA, 0);
    DMA_CH_setCSR(CMSDK_DMA, &DMA_Config, 0);

    GPIO_Config.outenableset = 0xFFFF;
    GPIO_Config.type = 0;
    GPIO_Config.int_num = 0;
    GPIO_Config.alt_func_num = 0;      // alt_func
    GPIO_Config.alt_func_sel_num = 0; //selector 
    gpio_config(GPIO0, &GPIO_Config);

    Timer_Config.irq_en=1;
    Timer_Config.enable=1;
    Timer_Config.extin=0;
    Timer_Config.extinclk=0;

    timer_config(TIMER0,&Timer_Config);
    timer_set_value(TIMER0,TICK_S);
    timer_set_reload(TIMER0,TICK_S);

    SPI_Config.clock_div    = 0 ;
    SPI_Config.slave_select = 0 ;
    SPI_Config.clock_mode   = 0 ;
    SPI_Config.spi_mode     = 1 ; // master
    SPI_Config.duplex_type  = 0 ;
    SPI_Config.tx_int_en    = 1 ;
    SPI_Config.rx_int_en    = 1 ;
    spi_config(SPI0, &SPI_Config);
}

int main(void) {
    //  1 - Receive string from Uart (interrupt) into str1.
    serial_uart_receive_string_poll(UART1 , str1);
    
    //str1[0] = 'H';
    //str1[1] = 'e';
    //str1[2] = 'y';
    //str1[3] = 's';
    //str1[4] = '\0'; 
    

    //  2 - DMA Transfer from str1 to str2.
    uint32_t str_size = 0;
    int i = 0;
    while(str1[i] != '\0')
	{	
        str_size++;
        i++;
    }
    str_size = str_size / 4;

    DMA_CH_setSZ(CMSDK_DMA, str_size, str_size, 0);
    DMA_CH_setA0(CMSDK_DMA, (uint32_t)&str1, 0);
    DMA_CH_setA1(CMSDK_DMA, (uint32_t)str2, 0);
    uint32_t* memory_address = (uint32_t *)(0x40011020);
    uint32_t data_to_write = 0x819;
    *memory_address = data_to_write;
    //uint32_t d = CMSDK_DMA->ChannelsConfig[0].CH_CSR;

    //for(int i = 0; i < 50; i++) {};
    //CMSDK_DMA->ChannelsConfig[0].CH_CSR = d | 1;


    //  3 - Transmit str2 through SPI.
   
    serial_spi_transmit_string_poll(SPI0, str2);

    //  4 - Set Timer to 1s.
    //  5 - In Timer IRQ blink LED using GPIO.
}




void __attribute__((used)) Reset_Handler(void)
{
     /* Copy init values from text to data */
    uint32_t *init_values_ptr = &_etext;
    uint32_t *data_ptr = &_sdata;

    if (init_values_ptr != data_ptr) {
        for (; data_ptr < &_edata;) {
            *data_ptr++ = *init_values_ptr++;
        }
    }

    /* Clear the zero segment */
    for (uint32_t *bss_ptr = &_sbss; bss_ptr < &_ebss;) {
        *bss_ptr++ = 0;
    }

    /* Initialize System */
    SystemInit();

    /* Branch to main function */
    main();

    /* Infinite loop */
    while (1);

}




//  Watchdog Interrupt
void __attribute__((used)) NMI_Handler(void)
{

}


void __attribute__((used)) HardFault_Handler(void)
{

}




void __attribute__((used)) SVC_Handler(void)
{


}


// Handler for PendSV (Context Switching)
void __attribute__((used)) PendSV_Handler(void) {

}


void __attribute__((used)) Systick_Handler(void)
{

}


void __attribute__((used)) GPIO_INT_00_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_01_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_02_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_03_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_04_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_05_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_06_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_07_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_08_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_09_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_10_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_11_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_12_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_13_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_14_Handler(void)
{

}

void __attribute__((used)) GPIO_INT_15_Handler(void)
{

}

void __attribute__((used)) GPIO_COMB_INT_Handler(void)
{

}


void __attribute__((used)) UART0_RX_INT_Handler(void)
{

}

void __attribute__((used)) UART0_TX_INT_Handler(void)
{
   uart_clear_tx_irq( UART0);
    semaphore = 1;
}

void __attribute__((used)) UART0_RXOV_INT_Handler(void)
{

}


void __attribute__((used)) UART0_TXOV_INT_Handler(void)
{

}


void __attribute__((used)) UART0_COMB_INT_Handler(void)
{
    
}

void __attribute__((used)) UART1_RX_INT_Handler(void)
{
    uart_clear_rx_irq( UART1);
    semaphore_rx = 1;
}

void __attribute__((used)) UART1_TX_INT_Handler(void)
{

}

void __attribute__((used)) UART1_RXOV_INT_Handler(void)
{
  
}

void __attribute__((used)) UART1_TXOV_INT_Handler(void)
{

}


void __attribute__((used)) UART1_COMB_INT_Handler(void)
{

}

void __attribute__((used)) TIMER_INT_Handler(void)
{
    int x = gpio_read_pin(GPIO0);
    gpio_write_out_data(GPIO0, ~x); 
}

void __attribute__((used)) DUALTIMER_INT1_Handler(void)
{

}

void __attribute__((used)) DUALTIMER_INT2_Handler(void)
{

}

void __attribute__((used)) DUALTIMER_COMB_INT_Handler(void)
{
   
}

void __attribute__((used)) Default_Handler(void)
{

}


/* declare vector table */
const void* VectorTable[] __attribute__ ((section(".vtor"), used)) = {
    &StackTop,  

    Reset_Handler,     /* -15: Reset_IRQn              */
    NMI_Handler,
    HardFault_Handler,

    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,
    Default_Handler,

    SVC_Handler,

    Default_Handler,
    Default_Handler,

    PendSV_Handler,
    Systick_Handler,

    GPIO_INT_00_Handler,
    GPIO_INT_01_Handler,
    GPIO_INT_02_Handler,
    GPIO_INT_03_Handler,
    GPIO_INT_04_Handler,
    GPIO_INT_05_Handler,
    GPIO_INT_06_Handler,
    GPIO_INT_07_Handler,
    GPIO_INT_08_Handler,
    GPIO_INT_09_Handler,
    GPIO_INT_10_Handler,
    GPIO_INT_11_Handler,
    GPIO_INT_12_Handler,
    GPIO_INT_13_Handler,
    GPIO_INT_14_Handler,
    GPIO_INT_15_Handler,
    GPIO_COMB_INT_Handler,

    TIMER_INT_Handler,
    DUALTIMER_INT1_Handler,
    DUALTIMER_INT2_Handler,
    DUALTIMER_COMB_INT_Handler,

    UART0_TX_INT_Handler,
    UART0_RX_INT_Handler,
    UART0_TXOV_INT_Handler,
    UART0_RXOV_INT_Handler,
    UART0_COMB_INT_Handler,

    UART1_TX_INT_Handler,
    UART1_RX_INT_Handler,
    UART1_TXOV_INT_Handler,
    UART1_RXOV_INT_Handler,
    UART1_COMB_INT_Handler,

    Default_Handler   
};


