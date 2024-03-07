#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h" 

#include "system_macros.h"


//////////////////////////////////Register layering of watchdog

typedef struct
{

  __IO    uint32_t  LOAD;          // <h> Watchdog Load Register </h>
  __I     uint32_t  VALUE;         // <h> Watchdog Value Register </h>
  __IO    uint32_t  CTRL;          // <h> Watchdog Control Register
                                   //   <o.1>    RESEN: Reset enable
                                   //   <o.0>    INTEN: Interrupt enable
                                   // </h>
  __O     uint32_t  INTCLR;        // <h> Watchdog Clear Interrupt Register </h>
  __I     uint32_t  RAWINTSTAT;    // <h> Watchdog Raw Interrupt Status Register </h>
  __I     uint32_t  MASKINTSTAT;   // <h> Watchdog Interrupt Status Register </h>
        uint32_t  RESERVED0[762];
  __IO    uint32_t  LOCK;          // <h> Watchdog Lock Register </h>
        uint32_t  RESERVED1[191];
  __IO    uint32_t  ITCR;          // <h> Watchdog Integration Test Control Register </h>
  __O     uint32_t  ITOP;          // <h> Watchdog Integration Test Output Set Register </h>

}CMSDK_WATCHDOG_TypeDef;

typedef struct 
{
      uint32_t irq_en;
      uint32_t resen;

}CMSDK_WATCHDOG_Configuration;


//////////////////////////////////Watchdog fucntion driver

//Watchdog set load
void CMSDK_WATCHDOG_SET_LOAD(CMSDK_WATCHDOG_TypeDef *WATCHDOG , uint32_t value);

//Watchdog read load
uint32_t CMSDK_WATCHDOG_READ_LOAD(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog return value
uint32_t CMSDK_WATCHDOG_READ_VALUE(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog enable interrupt
void CMSDK_WATCHDOG_EN_INTERRUPT (CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog interrupt disable
void CMSDK_WATCHDOG_DIS_INTERRUPT (CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog reset enable
void CMSDK_WATCHDOG_EN_RESET (CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog reset disable
void CMSDK_WATCHDOG_DIS_RESET (CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog read interrupt enable
uint32_t CMSDK_WATCHDOG_READ_CTRL_INTERRUPT (CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog read reset enable
uint32_t CMSDK_WATCHDOG_READ_CTRL_RESET(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog interrupt clear
void CMSDK_WATCHDOG_CLR_INTERRUPT(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog read raw interrupt status
uint32_t CMSDK_WATCHDOG_READ_RAW_INTERRUPT(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog read masked interrupt status
uint32_t CMSDK_WATCHDOG_READ_MASK_INTERRUPT(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog unlock registers
void CMSDK_WATCHDOG_UNLOCK(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog read lock register
uint32_t CMSDK_WATCHDOG_READ_LOCK(CMSDK_WATCHDOG_TypeDef *WATCHDOG);

//Watchdog full configuration
void CMSDK_WATCHDOG_CONFIG (CMSDK_WATCHDOG_TypeDef *WATCHDOG , CMSDK_WATCHDOG_Configuration* CONFIG);


//Watchdog IRQ handler
void CMSDK_WATCHDOG_IRQ_HANDLER (void);

#ifdef __cplusplus
}
#endif
