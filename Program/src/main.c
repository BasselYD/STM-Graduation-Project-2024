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
#include "../include/system_macros.h"
#include "../include/gpio_driver.h"
#include "../include/uart_driver.h"
#include "../include/watchdog_driver.h"
#include "../include/timer_driver.h"
#include "../include/dualtimer_driver.h"


extern uint32_t _etext;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sbss;
extern uint32_t _ebss;

/* stack declared in blinky.ld */
extern const uint32_t StackTop;

CMSDK_WATCHDOG_Configuration WDog_Config;
CMSDK_DUALTIMER_Configuration DualTimers_Config;
CMSDK_TIMER_Configuration Timer_Config;
CMSDK_UART_Configuration UART0_Config;
CMSDK_UART_Configuration UART1_Config;
CMSDK_GPIO_Configuration GPIO_Config;

void SystemInit(void) {

      GPIO_Config.outenableset = 1;
      GPIO_Config.Type = 1;
      GPIO_Config.INT_NUM = 1;
      GPIO_Config.ALTFUNC_NUM = 0;

      CMSDK_GPIO_Config(CMSDK_GPIO0, &GPIO_Config);

      DualTimers_Config.irq_en1 = 1;
      DualTimers_Config.oneshot1 = 0;
      DualTimers_Config.freerunning1 = 0;
      DualTimers_Config.prescale1 = 1;
      DualTimers_Config.enable1 = 1;
      DualTimers_Config.bits1 = 0;
      DualTimers_Config.irq_en2 = 0;
      DualTimers_Config.oneshot2 = 1;
      DualTimers_Config.freerunning2 = 1;
      DualTimers_Config.prescale2 = 0;
      DualTimers_Config.enable2 = 1;
      DualTimers_Config.bits2 = 1;

      CMSDK_DUALTIMER_CONFIG(CMSDK_DUALTIMER, &DualTimers_Config);

      UART0_Config.divider = 16;
      UART0_Config.tx_en = 1;
      UART0_Config.rx_en = 0;
      UART0_Config.tx_irq_en = 1;
      UART0_Config.rx_irq_en = 0;
      UART0_Config.tx_ovrirq_en = 1;
      UART0_Config.rx_ovrirq_en = 0;
      CMSDK_UART_Config(CMSDK_UART0, &UART0_Config);

      UART0_Config.divider = 32;
      UART0_Config.tx_en = 0;
      UART0_Config.rx_en = 1;
      UART0_Config.tx_irq_en = 0;
      UART0_Config.rx_irq_en = 1;
      UART0_Config.tx_ovrirq_en = 0;
      UART0_Config.rx_ovrirq_en = 1;
      CMSDK_UART_Config(CMSDK_UART1, &UART1_Config);

      Timer_Config.irq_en = 1;
      Timer_Config.enable = 1;
      Timer_Config.extin = 1;
      Timer_Config.extinclk = 0;
      CMSDK_TIMER_CONFIG(CMSDK_TIMER0, &Timer_Config);

      WDog_Config.irq_en = 1;
      WDog_Config.resen = 1;

      CMSDK_WATCHDOG_CONFIG(CMSDK_WATCHDOG, &WDog_Config);
}

int main(void) {
    CMSDK_TIMER_SET_VALUE(CMSDK_TIMER0,1000);
    CMSDK_DUALTIMER_BOTH_SET_TIMER1_LOAD(CMSDK_DUALTIMER,RELOAD_16);
    CMSDK_WATCHDOG_SET_LOAD(CMSDK_WATCHDOG,RELOAD_32);
    CMSDK_uart_SendChar(CMSDK_UART0, (char)0x35);
    CMSDK_WATCHDOG_READ_VALUE(CMSDK_WATCHDOG);
    CMSDK_DUALTIMER_BOTH_SET_TIMER2_LOAD(CMSDK_DUALTIMER,RELOAD_16);
    CMSDK_GPIO_ClrOutEnable(CMSDK_GPIO0,0xFFFFFFFF);
    CMSDK_GPIO_SetOutEnable(CMSDK_GPIO0,0x5); 
    CMSDK_GPIO_SetDataOut(CMSDK_GPIO0, 0x5); 
    CMSDK_GPIO_readpin(CMSDK_GPIO0);
    CMSDK_uart_ReceiveChar(CMSDK_UART1);

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


