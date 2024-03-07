#include "../include/watchdog_driver.h"


//////////////////////////////////Watchdog fucntion driver

//Watchdog set load
void CMSDK_WATCHDOG_SET_LOAD(CMSDK_WATCHDOG_TypeDef *WATCHDOG , uint32_t value){
	WATCHDOG -> LOAD = value ;
}

//Watchdog read load
uint32_t CMSDK_WATCHDOG_READ_LOAD(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	return WATCHDOG -> LOAD ;
}

//Watchdog return value
uint32_t CMSDK_WATCHDOG_READ_VALUE(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	return WATCHDOG -> VALUE ;
}

//Watchdog enable interrupt
void CMSDK_WATCHDOG_EN_INTERRUPT (CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	WATCHDOG -> CTRL |= WATCHDOG_CTRL_INTEN_Msk ;
}

//Watchdog interrupt disable
void CMSDK_WATCHDOG_DIS_INTERRUPT (CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	WATCHDOG -> CTRL &= ~WATCHDOG_CTRL_INTEN_Msk ;
}

//Watchdog reset enable
void CMSDK_WATCHDOG_EN_RESET (CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	WATCHDOG -> CTRL |= WATCHDOG_CTRL_RESEN_Msk ;
}

//Watchdog reset disable
void CMSDK_WATCHDOG_DIS_RESET (CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	WATCHDOG -> CTRL &= ~ WATCHDOG_CTRL_RESEN_Msk ;
}

//Watchdog read interrupt enable
uint32_t CMSDK_WATCHDOG_READ_CTRL_INTERRUPT (CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	return WATCHDOG -> CTRL &=  WATCHDOG_CTRL_INTEN_Msk ;
}

//Watchdog read reset enable
uint32_t CMSDK_WATCHDOG_READ_CTRL_RESET(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	return WATCHDOG -> CTRL &=  WATCHDOG_CTRL_RESEN_Msk ;
}

//Watchdog interrupt clear
void CMSDK_WATCHDOG_CLR_INTERRUPT(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	WATCHDOG -> INTCLR = WATCHDOG_INTCLR_Msk ;
}

//Watchdog read raw interrupt status
uint32_t CMSDK_WATCHDOG_READ_RAW_INTERRUPT(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	return WATCHDOG -> RAWINTSTAT ;
}

//Watchdog read masked interrupt status
uint32_t CMSDK_WATCHDOG_READ_MASK_INTERRUPT(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	return WATCHDOG -> MASKINTSTAT ;
}

//Watchdog unlock registers
void CMSDK_WATCHDOG_UNLOCK(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	WATCHDOG -> LOCK = WATCHDOG_LOCK_Msk ;
}

//Watchdog read lock register
uint32_t CMSDK_WATCHDOG_READ_LOCK(CMSDK_WATCHDOG_TypeDef *WATCHDOG){
	return WATCHDOG -> LOCK &= 0x1ul ;
}

//Watchdog full configuration
void CMSDK_WATCHDOG_CONFIG (CMSDK_WATCHDOG_TypeDef *WATCHDOG , CMSDK_WATCHDOG_Configuration* CONFIG){
	  uint32_t cntrl = 0;
      if(CONFIG->irq_en == 1) {cntrl |= WATCHDOG_CTRL_INTEN_Msk;}
      if(CONFIG->resen== 1) {cntrl |= WATCHDOG_CTRL_RESEN_Msk;}
	  WATCHDOG -> CTRL |= cntrl ;

}

//Watchdog IRQ handler
void CMSDK_WATCHDOG_IRQ_HANDLER (void){
    CMSDK_WATCHDOG_CLR_INTERRUPT (CMSDK_WATCHDOG);
    CMSDK_WATCHDOG_SET_LOAD (CMSDK_WATCHDOG ,RELOAD_32);
}
