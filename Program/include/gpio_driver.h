#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h"
#include "system_macros.h"


//////////////////////////////////Register layering of gpio
typedef struct
{
  __IO   uint32_t  DATA;             /*!< Offset: 0x000 DATA Register (R/W) */
  __IO   uint32_t  DATAOUT;          /*!< Offset: 0x004 Data Output Latch Register (R/W) */
         uint32_t  RESERVED0[2];
  __IO   uint32_t  OUTENABLESET;     /*!< Offset: 0x010 Output Enable Set Register  (R/W) */
  __IO   uint32_t  OUTENABLECLR;     /*!< Offset: 0x014 Output Enable Clear Register  (R/W) */
  __IO   uint32_t  ALTFUNCSET;       /*!< Offset: 0x018 Alternate Function Set Register  (R/W) */
  __IO   uint32_t  ALTFUNCCLR;       /*!< Offset: 0x01C Alternate Function Clear Register  (R/W) */
  __IO   uint32_t  INTENSET;         /*!< Offset: 0x020 Interrupt Enable Set Register  (R/W) */
  __IO   uint32_t  INTENCLR;         /*!< Offset: 0x024 Interrupt Enable Clear Register  (R/W) */
  __IO   uint32_t  INTTYPESET;       /*!< Offset: 0x028 Interrupt Type Set Register  (R/W) */
  __IO   uint32_t  INTTYPECLR;       /*!< Offset: 0x02C Interrupt Type Clear Register  (R/W) */
  __IO   uint32_t  INTPOLSET;        /*!< Offset: 0x030 Interrupt Polarity Set Register  (R/W) */
  __IO   uint32_t  INTPOLCLR;        /*!< Offset: 0x034 Interrupt Polarity Clear Register  (R/W) */
  union {
    __I    uint32_t  INTSTATUS;      /*!< Offset: 0x038 Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;       /*!< Offset: 0x038 Interrupt Clear Register ( /W) */
    };
         uint32_t RESERVED1[241];
  __IO   uint32_t LB_MASKED[256];    /*!< Offset: 0x400 - 0x7FC Lower byte Masked Access Register (R/W) */
  __IO   uint32_t UB_MASKED[256];    /*!< Offset: 0x800 - 0xBFC Upper byte Masked Access Register (R/W) */
} CMSDK_GPIO_TypeDef;


typedef struct 
{
  uint32_t outenableset;
  uint32_t Type;
  uint32_t INT_NUM;
  uint32_t ALTFUNC_NUM;
} CMSDK_GPIO_Configuration;

////////////////////////////////// Gpio Function Driver


//Gpio set pins as output
void CMSDK_GPIO_SetOutEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t outenableset);



//Gpio set pins as input
void CMSDK_GPIO_ClrOutEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t outenableclr);



//Gpio return whether pin is input or output
uint32_t CMSDK_GPIO_GetOutEnable(CMSDK_GPIO_TypeDef *GPIO);


//Gpio writing output data
void CMSDK_GPIO_SetDataOut(CMSDK_GPIO_TypeDef *GPIO, uint32_t output_data);


//Gpio enable alternate function
void CMSDK_GPIO_SetAltFunc(CMSDK_GPIO_TypeDef *GPIO, uint32_t AltFuncset);


//Gpio disable alternate function
void CMSDK_GPIO_ClrAltFunc(CMSDK_GPIO_TypeDef *GPIO, uint32_t AltFuncclr);


//Gpio returns whether the pin is enabled as normal or alternate function
uint32_t CMSDK_GPIO_GetAltFunc(CMSDK_GPIO_TypeDef *GPIO);




//Gpio clear interrrupt and make sure interrupt is cleared
uint32_t CMSDK_GPIO_IntClear(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num);




//Gpio enable interrupt
uint32_t CMSDK_GPIO_SetIntEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num);



//Gpio disable interrupt
uint32_t CMSDK_GPIO_ClrIntEnable(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num);


//Gpio change type of interrupt to high level
void CMSDK_GPIO_SetIntHighLevel(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num);



//Gpio changes the interrupt type to rising edge
void CMSDK_GPIO_SetIntRisingEdge(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num);



//Gpio changes the interrupt type to low level interrupt
void CMSDK_GPIO_SetIntLowLevel(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num);


//Gpio changes the interrupt level to falling edge
void CMSDK_GPIO_SetIntFallingEdge(CMSDK_GPIO_TypeDef *GPIO, uint32_t Num);

//Gpio read pin
uint32_t CMSDK_GPIO_readpin (CMSDK_GPIO_TypeDef *GPIO);


//Gpio uutputs the specified value on the desired port using the user defined mask to perform Masked access.

void CMSDK_GPIO_MaskedWrite(CMSDK_GPIO_TypeDef *GPIO, uint32_t value, uint32_t mask);

void CMSDK_GPIO_Config(CMSDK_GPIO_TypeDef *GPIO, CMSDK_GPIO_Configuration *CONFIG);


  
#ifdef __cplusplus
}
#endif


