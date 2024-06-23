# STM-Graduation-Project-2024

Final Version of the SoC, containing the following peripherals:
- I-SRAM
- D-SRAM
- DMA (Optional)
- GPIO (With Alternate Functions)
- APB Subsystem:
    - AHB2APB Bridge
    - UART
    - SPI (Optional)
    - Watchdog Timer
    - Timer
    - Dualtimer (Optional)

This version moved all inout signals to the Top-Level ports in the Alternate Function implementation, targeting FPGA flow.
