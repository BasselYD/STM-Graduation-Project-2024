#include "../include/dma_driver.h"

void DMA_enable(dma_typedef *DMA, bool stop) {
    if (stop)
        DMA->CSR |= 1;
    else
        DMA->CSR &= 0;
}

void DMA_CH_setINT_MSK_A(dma_typedef *DMA, uint32_t interrupt_mask) {
    DMA->INT_MSK_A = interrupt_mask;
}

void DMA_CH_setINT_MSK_B(dma_typedef *DMA, uint32_t interrupt_mask) {
    DMA->INT_MSK_B = interrupt_mask;
}

uint32_t DMA_CH_getINT_MSK_A(dma_typedef *DMA) {
    return DMA->INT_MSK_A;
}

uint32_t DMA_CH_getINT_MSK_B(dma_typedef *DMA) {
    return DMA->INT_MSK_B;
}

void DMA_CH_setCSR(dma_typedef *DMA, dma_ch_csr_config *CH_CSR_Config, int channelNum) {
    uint32_t config = 0;
    config |= (CH_CSR_Config->INE_CHK_DONE << 19) | (CH_CSR_Config->INE_DONE << 18) | (CH_CSR_Config->INE_ERROR << 17) | 
              (CH_CSR_Config->REST_EN << 16) | ((CH_CSR_Config->ChannelPriority & 0x07) << 13) | (CH_CSR_Config->STOP << 9) |
              (CH_CSR_Config->SZ_WB << 8) | (CH_CSR_Config->USE_ED << 7) | (CH_CSR_Config->ARS << 6) | (CH_CSR_Config->MODE << 5) |
              (CH_CSR_Config->INC_SRC << 4) | (CH_CSR_Config->INC_DST << 3) | (CH_CSR_Config->CH_EN);

    DMA->ChannelsConfig[channelNum].CH_CSR = config;
}

void DMA_CH_setSZ(dma_typedef *DMA, uint8_t chk_size, uint16_t total_size, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_SZ = (chk_size << 16) | (total_size & 0xFFF);
}

void DMA_CH_setA0(dma_typedef *DMA, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_A0 = address;
}

void DMA_CH_setAM0(dma_typedef *DMA, uint32_t address_mask, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_AM0 = address_mask;
}

void DMA_CH_setA1(dma_typedef *DMA, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_A1 = address;
}

void DMA_CH_setAM1(dma_typedef *DMA, uint32_t address_mask, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_AM1 = address_mask;
}

void DMA_CH_setDESC(dma_typedef *DMA, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_DESC = address;
}

void DMA_CH_setSWPTR(dma_typedef *DMA, bool enable, uint32_t address, int channelNum) {
    DMA->ChannelsConfig[channelNum].CH_SWPTR = (enable << 31) | (address & 0x7FFFFFFF); 
}
