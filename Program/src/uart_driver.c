#include "../include/uart_driver.h"


//Uart get receiver buffer status
uint32_t CMSDK_uart_GetRxBufferFull(CMSDK_UART_TypeDef *UART)
{
      return ((UART->STATE & UART_STATE_RX_BF_Msk)>> UART_STATE_RX_BF_Pos);
}


//Uart get transmitter buffer status
uint32_t CMSDK_uart_GetTxBufferFull(CMSDK_UART_TypeDef *UART)
{
      return ((UART->STATE & UART_STATE_TX_BF_Msk)>> UART_STATE_TX_BF_Pos);
}

//Uart transmit character
void CMSDK_uart_SendChar(CMSDK_UART_TypeDef *UART, char txchar)
{
      while(UART->STATE & UART_STATE_TX_BF_Msk);
      UART->DATA = (uint32_t)txchar;
}


//Uart receive character
char CMSDK_uart_ReceiveChar(CMSDK_UART_TypeDef *UART)
{
      while(!(UART->STATE & UART_STATE_RX_BF_Msk));
      return (char)(UART->DATA);
}


//Uart return uart overrun status
uint32_t CMSDK_uart_GetOverrunStatus(CMSDK_UART_TypeDef *UART)
{
      return ((UART->STATE & (UART_CTRL_RX_OV_IRQ_EN_Msk | UART_CTRL_TX_OV_IRQ_EN_Msk))>>UART_CTRL_TX_OV_IRQ_EN_Pos);
}

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

uint32_t CMSDK_uart_ClearOverrunStatus(CMSDK_UART_TypeDef *UART)
{
      UART->STATE = (UART_CTRL_TX_OV_IRQ_EN_Msk | UART_CTRL_RX_OV_IRQ_EN_Msk);
      return ((UART->STATE & (UART_CTRL_TX_OV_IRQ_EN_Msk | UART_CTRL_RX_OV_IRQ_EN_Msk)) >> UART_CTRL_TX_OV_IRQ_EN_Pos);
}


//Uart return baud divider value
uint32_t CMSDK_uart_GetBaudDivider(CMSDK_UART_TypeDef *UART)
{
      return UART->BAUDDIV;
}

void CMSDK_uart_SetBaudDivider(CMSDK_UART_TypeDef *UART, uint32_t divider)
{
UART->BAUDDIV = divider;
}


//Uart clear interrupt status
uint32_t CMSDK_uart_GetTxIRQStatus(CMSDK_UART_TypeDef *UART)
{
      return ((UART->INTSTATUS & UART_INTCLEAR_TX_IRQ_Msk ) >> UART_INTCLEAR_TX_IRQ_Pos);
}

//Uart return interrupt status if interrupt is high or low
uint32_t CMSDK_uart_GetRxIRQStatus(CMSDK_UART_TypeDef *UART)
{
      return ((UART->INTSTATUS & UART_INTCLEAR_RX_IRQ_Msk) >>UART_INTCLEAR_RX_IRQ_Pos);
}

//Uart clear transmitter interrupt
void CMSDK_uart_ClearTxIRQ(CMSDK_UART_TypeDef *UART)
{
      UART->INTCLEAR = UART_INTCLEAR_TX_IRQ_Msk;
}

//Uart clear receiver interrupt
void CMSDK_uart_ClearRxIRQ(CMSDK_UART_TypeDef *UART)
{
      UART->INTCLEAR = UART_INTCLEAR_RX_IRQ_Msk;
}


//Uart configuration function
uint32_t CMSDK_UART_Config(CMSDK_UART_TypeDef *UART, CMSDK_UART_Configuration *CONFIG)
{
      uint32_t new_ctrl=0;

      if (CONFIG->tx_en!=0)        new_ctrl |= UART_CTRL_TX_EN_Msk;
      if (CONFIG->rx_en!=0)        new_ctrl |= UART_CTRL_RX_EN_Msk;
      if (CONFIG->tx_irq_en!=0)    new_ctrl |= UART_CTRL_TX_IRQ_EN_Msk;
      if (CONFIG->rx_irq_en!=0)    new_ctrl |= UART_CTRL_RX_IRQ_EN_Msk;
      if (CONFIG->tx_ovrirq_en!=0) new_ctrl |= UART_CTRL_TX_OV_IRQ_EN_Msk;
      if (CONFIG->rx_ovrirq_en!=0) new_ctrl |= UART_CTRL_RX_OV_IRQ_EN_Msk;

      UART->CTRL = 0;         
      UART->BAUDDIV = CONFIG->divider;
      UART->CTRL = new_ctrl;  

      if((UART->STATE & (UART_CTRL_TX_OV_IRQ_EN_Msk | UART_CTRL_RX_OV_IRQ_EN_Msk))) return 1;
      else return 0;
}
