#pragma once

#ifdef __cplusplus
 extern "C" {
#endif

#include "core_cm0.h"                       
#include "system_CMSDK_CM0.h" 

#include "system_macros.h"


//////////////////////////////////Register layering of dualtimer

typedef struct
{
  __IO uint32_t Timer1Load;   // <h> Timer 1 Load </h>
  __I  uint32_t Timer1Value;  // <h> Timer 1 Counter Current Value <r></h>
  __IO uint32_t Timer1Control;// <h> Timer 1 Control
                              //   <o.7> TimerEn: Timer Enable
                              //   <o.6> TimerMode: Timer Mode
                              //     <0=> Freerunning-mode
                              //     <1=> Periodic mode
                              //   <o.5> IntEnable: Interrupt Enable
                              //   <o.2..3> TimerPre: Timer Prescale
                              //     <0=> / 1
                              //     <1=> / 16
                              //     <2=> / 256
                              //     <3=> Undefined!
                              //   <o.1> TimerSize: Timer Size
                              //     <0=> 16-bit counter
                              //     <1=> 32-bit counter
                              //   <o.0> OneShot: One-shoot mode
                              //     <0=> Wrapping mode
                              //     <1=> One-shot mode
                              // </h>
  __O  uint32_t Timer1IntClr; // <h> Timer 1 Interrupt Clear <w></h>
  __I  uint32_t Timer1RIS;    // <h> Timer 1 Raw Interrupt Status <r></h>
  __I  uint32_t Timer1MIS;    // <h> Timer 1 Masked Interrupt Status <r></h>
  __IO uint32_t Timer1BGLoad; // <h> Background Load Register </h>
       uint32_t RESERVED0;
  __IO uint32_t Timer2Load;   // <h> Timer 2 Load </h>
  __I  uint32_t Timer2Value;  // <h> Timer 2 Counter Current Value <r></h>
  __IO uint32_t Timer2Control;// <h> Timer 2 Control
                              //   <o.7> TimerEn: Timer Enable
                              //   <o.6> TimerMode: Timer Mode
                              //     <0=> Freerunning-mode
                              //     <1=> Periodic mode
                              //   <o.5> IntEnable: Interrupt Enable
                              //   <o.2..3> TimerPre: Timer Prescale
                              //     <0=> / 1
                              //     <1=> / 16
                              //     <2=> / 256
                              //     <3=> Undefined!
                              //   <o.1> TimerSize: Timer Size
                              //     <0=> 16-bit counter
                              //     <1=> 32-bit counter
                              //   <o.0> OneShot: One-shoot mode
                              //     <0=> Wrapping mode
                              //     <1=> One-shot mode
                              // </h>
  __O  uint32_t Timer2IntClr; // <h> Timer 2 Interrupt Clear <w></h>
  __I  uint32_t Timer2RIS;    // <h> Timer 2 Raw Interrupt Status <r></h>
  __I  uint32_t Timer2MIS;    // <h> Timer 2 Masked Interrupt Status <r></h>
  __IO uint32_t Timer2BGLoad; // <h> Background Load Register </h>
       uint32_t RESERVED1[945];
  __IO uint32_t ITCR;         // <h> Integration Test Control Register </h>
  __O  uint32_t ITOP;         // <h> Integration Test Output Set Register </h>
} CMSDK_DUALTIMER_BOTH_TypeDef;



typedef struct 
{
     uint32_t irq_en1;
     uint32_t oneshot1;
     uint32_t freerunning1; 
     uint32_t prescale1;
     uint32_t enable1; 
     uint32_t bits1; 
     uint32_t irq_en2;
     uint32_t oneshot2;
     uint32_t freerunning2; 
     uint32_t prescale2;
     uint32_t enable2; 
     uint32_t bits2;
} CMSDK_DUALTIMER_Configuration;




//////////////////////////////////Dualtimer driver

//Dual timer 1 set load register
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_LOAD (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH ,uint32_t value);

//Dual timer 1 read load register
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER1_LOAD (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 read value register
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER1_VALUE (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 set one shoot mode
void CMSDK_DUALTIMER_BOTH_EN_TIMER1_ONESHOT (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 set wrapping mode
void CMSDK_DUALTIMER_BOTH_DIS_TIMER1_ONESHOT (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 set to 32 bits
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_MAX (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 set to 16 bits
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_HALF (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 enable interrupt
void CMSDK_DUALTIMER_BOTH_EN_TIMER1_INTERRUPT (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );


//Dual timer 1 disable interrupt
void CMSDK_DUALTIMER_BOTH_DIS_TIMER1_INTERRUPT (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 set prescale to 256
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_PRESCALE_256 (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 set prescale to 16
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_PRESCALE_16 (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );


//Dual timer 1 disable prescale
void CMSDK_DUALTIMER_BOTH_DIS_TIMER1_PRESCALE (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );;

//Dual timer 1 set periodic mode
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_PERIODIC (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );


//Dual timer 1 set free running mode
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_FREERUNNUNG (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 enable timer
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_EN (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 disable timer
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_DIS (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );


//Dual timer 1 read control bits
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER1_CTRL (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 interrupt clear
void CMSDK_DUALTIMER_BOTH_TIMER1_CLR_INTERUPT (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 read raw interrupt status
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER1_RIS (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 read masked interrupt status
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER1_MIS (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

//Dual timer 1 set back ground load
void CMSDK_DUALTIMER_BOTH_SET_TIMER1_BGLOAD (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH ,uint32_t value );

//Dual timer 1 read background load
uint32_t CMSDK_DUALTIMER_BOTH_GET_TIMER1_BGLOAD (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH );

// Dual timer 2 set load register
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_LOAD(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH, uint32_t value);

// Dual timer 2 read load register
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER2_LOAD(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 read value register
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER2_VALUE(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set one-shot mode
void CMSDK_DUALTIMER_BOTH_EN_TIMER2_ONESHOT(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set wrapping mode
void CMSDK_DUALTIMER_BOTH_DIS_TIMER2_ONESHOT(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set to 32 bits
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_MAX(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set to 16 bits
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_HALF(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 enable interrupt
void CMSDK_DUALTIMER_BOTH_EN_TIMER2_INTERRUPT(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 disable interrupt
void CMSDK_DUALTIMER_BOTH_DIS_TIMER2_INTERRUPT(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set prescale to 256
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_PRESCALE_256(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set prescale to 16
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_PRESCALE_16(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 disable prescale
void CMSDK_DUALTIMER_BOTH_DIS_TIMER2_PRESCALE(CMSDK_DUALTIMER_BOTH_TypeDef *CMSDK_DUALTIMER_BOTH);

// Dual timer 2 set periodic mode
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_PERIODIC(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set free running mode
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_FREERUNNING(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 enable timer
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_EN(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 disable timer
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_DIS(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 read control bits
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER2_CTRL(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 interrupt clear
void CMSDK_DUALTIMER_BOTH_TIMER2_CLR_INTERUPT(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 read raw interrupt status
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER2_RIS(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 read masked interrupt status
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER2_MIS(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);

// Dual timer 2 set background load
void CMSDK_DUALTIMER_BOTH_SET_TIMER2_BGLOAD(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH, uint32_t value);

// Dual timer 2 read background load
uint32_t CMSDK_DUALTIMER_BOTH_READ_TIMER2_BGLOAD(CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH);


//Dual timer full configuration

void CMSDK_DUALTIMER_CONFIG (CMSDK_DUALTIMER_BOTH_TypeDef *DUALTIMER_BOTH, CMSDK_DUALTIMER_Configuration *CONFIG);


//Dual timer combined IRQ handler
void CMSDK_DUALTIMER_IRQ_HANDLER_COMBINED (void);;

#ifdef __cplusplus
}
#endif











