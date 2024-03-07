#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h" 

#include "system_macros.h"



//////////////////////////////////Register layering of uart

typedef struct 
{
  __IO   uint32_t  DATA;          //Offset: 0x000 Data Register    (R/W) 
  __IO   uint32_t  STATE;         // Offset: 0x004 Status Register  (R/W) 
  __IO   uint32_t  CTRL;          // Offset: 0x008 Control Register (R/W) 
  union {
    __I    uint32_t  INTSTATUS;   // Offset: 0x00C Interrupt Status Register (R/ ) 
    __O    uint32_t  INTCLEAR;    // Offset: 0x00C Interrupt Clear Register ( /W) 
    };
  __IO   uint32_t  BAUDDIV;       // Offset: 0x010 Baudrate Divider Register (R/W) 

} CMSDK_UART_TypeDef;

typedef struct 
{
  uint32_t divider;
  uint32_t tx_en;
  uint32_t rx_en;
  uint32_t tx_irq_en;
  uint32_t rx_irq_en;
  uint32_t tx_ovrirq_en;
  uint32_t rx_ovrirq_en;

} CMSDK_UART_Configuration;



//Uart get receiver buffer status

uint32_t CMSDK_uart_GetRxBufferFull(CMSDK_UART_TypeDef *UART);


//Uart get transmitter buffer status

uint32_t CMSDK_uart_GetTxBufferFull(CMSDK_UART_TypeDef *UART);

//Uart transmit character

void CMSDK_uart_SendChar(CMSDK_UART_TypeDef *UART, char txchar);


//Uart receive character

char CMSDK_uart_ReceiveChar(CMSDK_UART_TypeDef *UART);


//Uart return uart overrun status

uint32_t CMSDK_uart_GetOverrunStatus(CMSDK_UART_TypeDef *UART);

/**
 *
 * @param *CMSDK_UART UART Pointer
 * @return 0 - No overrun
 * @return 1 - TX overrun
 * @return 2 - RX overrun
 * @return 3 - TX & RX overrun
 *
 * @brief  Clears the overrun status of both the RX & TX buffers and then returns the current overrun status.
 */

uint32_t CMSDK_uart_ClearOverrunStatus(CMSDK_UART_TypeDef *UART);


//Uart return baud divider value

uint32_t CMSDK_uart_GetBaudDivider(CMSDK_UART_TypeDef *UART);

void CMSDK_uart_SetBaudDivider(CMSDK_UART_TypeDef *UART, uint32_t divider);


//Uart clear interrupt status

uint32_t CMSDK_uart_GetTxIRQStatus(CMSDK_UART_TypeDef *UART);

//Uart return interrupt status if interrupt is high or low

uint32_t CMSDK_uart_GetRxIRQStatus(CMSDK_UART_TypeDef *UART);

//Uart clear transmitter interrupt

void CMSDK_uart_ClearTxIRQ(CMSDK_UART_TypeDef *UART);

//Uart clear receiver interrupt

void CMSDK_uart_ClearRxIRQ(CMSDK_UART_TypeDef *UART);


//Uart configuration function

uint32_t CMSDK_UART_Config(CMSDK_UART_TypeDef *UART, CMSDK_UART_Configuration *CONFIG);



#ifdef __cplusplus
}
#endif
