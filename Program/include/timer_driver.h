#pragma once

#ifdef __cplusplus
 extern "C" {
#endif


#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h"

#include "system_macros.h"


//////////////////////////////////Register layering of timer


typedef struct
{
  __IO   uint32_t  CTRL;          /*!< Offset: 0x000 Control Register (R/W) */
  __IO   uint32_t  VALUE;         /*!< Offset: 0x004 Current Value Register (R/W) */
  __IO   uint32_t  RELOAD;        /*!< Offset: 0x008 Reload Value Register  (R/W) */
  union {
    __I    uint32_t  INTSTATUS;   /*!< Offset: 0x00C Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;    /*!< Offset: 0x00C Interrupt Clear Register ( /W) */
    };

} CMSDK_TIMER_TypeDef;

typedef struct
{
      uint32_t irq_en;
      uint32_t enable;
      uint32_t extin;
      uint32_t extinclk;
} CMSDK_TIMER_Configuration;


//////////////////////////////////Timer fucntion driver

//Timer enable interrupt
void CMSDK_TIMER_EN_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER);


//Timer disable interrupt
void CMSDK_TIMER_DIS_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER);

//Timer enable
void CMSDK_TIMER_EN(CMSDK_TIMER_TypeDef *TIMER);

//Timer disable
void CMSDK_TIMER_DIS(CMSDK_TIMER_TypeDef *TIMER);

//Timer enable extin as enable
void CMSDK_TIMER_EXTIN_EN (CMSDK_TIMER_TypeDef *TIMER);

//Timer disable extin as enable
void CMSDK_TIMER_EXTIN_DIS (CMSDK_TIMER_TypeDef *TIMER);

//Timer enable extin as clock
void CMSDK_TIMER_EXTIN_EN_CLK (CMSDK_TIMER_TypeDef *TIMER);

//Timer disable extin as clock
void CMSDK_TIMER_EXTIN_DIS_CLK (CMSDK_TIMER_TypeDef *TIMER);


//Timer return control register configuration
uint32_t CMSDK_TIMER_READ_CTRL (CMSDK_TIMER_TypeDef *TIMER);

//Timer set value register
void CMSDK_TIMER_SET_VALUE(CMSDK_TIMER_TypeDef *TIMER, uint32_t value);


//Timer read value register
uint32_t CMSDK_TIMER_READ_VALUE(CMSDK_TIMER_TypeDef *TIMER);


//Timer set reload register
void CMSDK_TIMER_SET_RELOAD(CMSDK_TIMER_TypeDef *TIMER, uint32_t value);

//Timer read reload register
uint32_t CMSDK_TIMER_READ_RELOAD(CMSDK_TIMER_TypeDef *TIMER);


//Timer clear interrupt
void CMSDK_TIMER_CLR_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER);


//Timer read interrupt status
uint32_t  CMSDK_TIMER_STATUS_INTERRUPT(CMSDK_TIMER_TypeDef *TIMER);


//Timer full configuration
void CMSDK_TIMER_CONFIG (CMSDK_TIMER_TypeDef *TIMER , CMSDK_TIMER_Configuration *CONFIG);


//Timer IRQ handler
void CMSDK_TIMER_IRQ_HANDLER (void);

#ifdef __cplusplus
}
#endif