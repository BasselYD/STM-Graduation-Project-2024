#include "../include/timer_driver.h"


//////////////////////////////////Timer fucntion driver

//Timer enable interrupt
void CMSDK_TIMER_EN_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER)
{
      TIMER->CTRL |= TIMER_CTRL_IRQEN_Msk;
}


//Timer disable interrupt
void CMSDK_TIMER_DIS_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER)
{
      TIMER->CTRL &= ~TIMER_CTRL_IRQEN_Msk;
}

//Timer enable
void CMSDK_TIMER_EN(CMSDK_TIMER_TypeDef *TIMER)
{
      TIMER->CTRL |= TIMER_CTRL_EN_Msk;
}

//Timer disable
void CMSDK_TIMER_DIS(CMSDK_TIMER_TypeDef *TIMER)
{
      TIMER->CTRL &= ~TIMER_CTRL_EN_Msk;
}

//Timer enable extin as enable
void CMSDK_TIMER_EXTIN_EN (CMSDK_TIMER_TypeDef *TIMER){
      TIMER->CTRL |= TIMER_CTRL_SELEXTEN_Msk;
}

//Timer disable extin as enable
void CMSDK_TIMER_EXTIN_DIS (CMSDK_TIMER_TypeDef *TIMER){
      TIMER->CTRL &= ~TIMER_CTRL_SELEXTEN_Msk;
}

//Timer enable extin as clock
void CMSDK_TIMER_EXTIN_EN_CLK (CMSDK_TIMER_TypeDef *TIMER){
      TIMER->CTRL |= TIMER_CTRL_SELEXTCLK_Msk;
}

//Timer disable extin as clock
void CMSDK_TIMER_EXTIN_DIS_CLK (CMSDK_TIMER_TypeDef *TIMER){
      TIMER->CTRL &= ~TIMER_CTRL_SELEXTCLK_Msk;
}


//Timer return control register configuration
uint32_t CMSDK_TIMER_READ_CTRL (CMSDK_TIMER_TypeDef *TIMER){
      return TIMER->CTRL &= (TIMER_CTRL_SELEXTCLK_Msk | TIMER_CTRL_SELEXTEN_Msk | TIMER_CTRL_EN_Msk |TIMER_CTRL_IRQEN_Msk);
}

//Timer set value register
void CMSDK_TIMER_SET_VALUE(CMSDK_TIMER_TypeDef *TIMER, uint32_t value)
{
      TIMER->VALUE = value;
}


//Timer read value register
uint32_t CMSDK_TIMER_READ_VALUE(CMSDK_TIMER_TypeDef *TIMER)
{
      return TIMER->VALUE;
}


//Timer set reload register
void CMSDK_TIMER_SET_RELOAD(CMSDK_TIMER_TypeDef *TIMER, uint32_t value)
{
      TIMER->RELOAD = value;
}

//Timer read reload register
uint32_t CMSDK_TIMER_READ_RELOAD(CMSDK_TIMER_TypeDef *TIMER)
{
      return TIMER->RELOAD;
}


//Timer clear interrupt
void CMSDK_TIMER_CLR_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER)
{
      TIMER->INTCLEAR = TIMER_INTCLEAR_Msk;
}


//Timer read interrupt status
uint32_t  CMSDK_TIMER_STATUS_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER)
{
      return TIMER->INTSTATUS;
}


//Timer full configuration
void CMSDK_TIMER_CONFIG (CMSDK_TIMER_TypeDef *TIMER , CMSDK_TIMER_Configuration *CONFIG)
{     
      uint32_t cntrl = 0;
      if(CONFIG->irq_en == 1)   {cntrl |= TIMER_CTRL_IRQEN_Msk;}
      if(CONFIG->enable==1)     {cntrl |=TIMER_CTRL_EN_Msk;}
      if(CONFIG->extin==1)      {cntrl |=TIMER_CTRL_SELEXTEN_Msk;}
      if(CONFIG->extinclk==1)   {cntrl |=TIMER_CTRL_SELEXTEN_Msk;}
      TIMER->CTRL |= cntrl;
}


//Timer IRQ handler
void CMSDK_TIMER_IRQ_HANDLER (void) {
      CMSDK_TIMER_CLR_INTERRUPT     (CMSDK_TIMER0);
      CMSDK_TIMER_SET_RELOAD        (CMSDK_TIMER0,RELOAD_32);
      CMSDK_TIMER_SET_VALUE         (CMSDK_TIMER0,RELOAD_32);
}
