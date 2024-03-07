#include "../include/gpio_driver.h"                       


////////////////////////////////// Gpio Function Driver

//Gpio set pins as output
void CMSDK_GPIO_SetOutEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t outenableset)
{
      GPIO->OUTENABLESET = outenableset;
}



//Gpio set pins as input
void CMSDK_GPIO_ClrOutEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t outenableclr)
{
      GPIO->OUTENABLECLR = outenableclr;
}


//Gpio return function
uint32_t CMSDK_GPIO_readpin (CMSDK_GPIO_TypeDef *GPIO) {
      return GPIO ->DATA;

}



//Gpio return whether pin is input or output
uint32_t CMSDK_GPIO_GetOutEnable(CMSDK_GPIO_TypeDef *GPIO)
{
      return GPIO->OUTENABLESET;
}


//Gpio writing output data
void CMSDK_GPIO_SetDataOut(CMSDK_GPIO_TypeDef *GPIO, uint32_t output_data)
{
      GPIO->DATAOUT = output_data;
}


//Gpio enable alternate function
void CMSDK_GPIO_SetAltFunc(CMSDK_GPIO_TypeDef *GPIO, uint32_t AltFuncset)
{
      GPIO->ALTFUNCSET = AltFuncset;
}


//Gpio disable alternate function
void CMSDK_GPIO_ClrAltFunc(CMSDK_GPIO_TypeDef *GPIO, uint32_t AltFuncclr)
{
      GPIO->ALTFUNCCLR = AltFuncclr;
}


//Gpio returns whether the pin is enabled as normal or alternate function
uint32_t CMSDK_GPIO_GetAltFunc(CMSDK_GPIO_TypeDef *GPIO)
{
      return GPIO->ALTFUNCSET;
}


//Gpio clear interrrupt and make sure interrupt is cleared
uint32_t CMSDK_GPIO_IntClear(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num)
{
      GPIO->INTCLEAR = (1 << Num);

      return GPIO->INTSTATUS;
}


//Gpio enable interrupt
uint32_t CMSDK_GPIO_SetIntEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num)
{
      GPIO->INTENSET = (1 << Num);

      return GPIO->INTENSET;
}


//Gpio disable interrupt
uint32_t CMSDK_GPIO_ClrIntEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num)
{
      GPIO->INTENCLR = (1 << Num);

      return GPIO->INTENCLR;
}


//Gpio change type of interrupt to high level
void CMSDK_GPIO_SetIntHighLevel(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num)
{
      GPIO->INTTYPECLR = (1 << Num); /* Clear INT TYPE bit */
      GPIO->INTPOLSET = (1 << Num);  /* Set INT POLarity bit */
}



//Gpio changes the interrupt type to rising edge
void CMSDK_GPIO_SetIntRisingEdge(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num)
{
      GPIO->INTTYPESET = (1 << Num); /* Set INT TYPE bit */
      GPIO->INTPOLSET = (1 << Num);  /* Set INT POLarity bit */
}



//Gpio changes the interrupt type to low level interrupt
void CMSDK_GPIO_SetIntLowLevel(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num)
{
      GPIO->INTTYPECLR = (1 << Num);  /* Clear INT TYPE bit */
      GPIO->INTPOLCLR = (1 << Num);   /* Clear INT POLarity bit */
}


//Gpio changes the interrupt level to falling edge
void CMSDK_GPIO_SetIntFallingEdge(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num)
{
      GPIO->INTTYPESET = (1 << Num);  /* Set INT TYPE bit */
      GPIO->INTPOLCLR = (1 << Num);   /* Clear INT POLarity bit */
}


//Gpio uutputs the specified value on the desired port using the user defined mask to perform Masked access.
void CMSDK_GPIO_MaskedWrite(CMSDK_GPIO_TypeDef *GPIO, uint32_t value, uint32_t mask)
{
      GPIO->LB_MASKED[0x00FF & mask] = value;
      GPIO->UB_MASKED[((0xFF00 & mask) >> 8)] = value;
}

//GPIO configuration function
//Type 0 is High level 
//Type 1 is Rising Edge
//Type 2 is Low Level
//Type 3 is Falling Edge 
void CMSDK_GPIO_Config(CMSDK_GPIO_TypeDef *GPIO, CMSDK_GPIO_Configuration *CONFIG)
{
      
      GPIO->OUTENABLESET = CONFIG->outenableset & GPIO_OUTENSET_Msk;
      GPIO->INTENSET = CONFIG->INT_NUM & GPIO_INTTYPESET_Msk;
      if((CONFIG->Type == 0) | (CONFIG->Type == 1))  GPIO->INTPOLSET  = CONFIG->INT_NUM  & GPIO_INTPOLSET_Msk;  
      if((CONFIG->Type == 2) | (CONFIG->Type == 3))  GPIO->INTPOLCLR  = CONFIG->INT_NUM  & GPIO_INTPOLCLR_Msk;  
      if((CONFIG->Type == 1) | (CONFIG->Type == 3))  GPIO->INTTYPESET = CONFIG->INT_NUM & GPIO_INTTYPESET_Msk; 
      if((CONFIG->Type == 0) | (CONFIG->Type == 2))  GPIO->INTTYPECLR = CONFIG->INT_NUM & GPIO_INTTYPECLR_Msk; 
      GPIO->ALTFUNCSET = CONFIG->ALTFUNC_NUM & GPIO_ALTFUNCSET_Msk;
 
}
