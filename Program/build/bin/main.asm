
build/bin/main.elf:     file format elf32-littlearm


Disassembly of section .text:

00000000 <VectorTable>:
   0:	00 00 10 20 c1 00 00 00 fd 00 00 00 ff 00 00 00     ... ............
  10:	41 01 00 00 41 01 00 00 41 01 00 00 41 01 00 00     A...A...A...A...
  20:	41 01 00 00 41 01 00 00 41 01 00 00 01 01 00 00     A...A...A.......
  30:	41 01 00 00 41 01 00 00 03 01 00 00 05 01 00 00     A...A...........
  40:	07 01 00 00 09 01 00 00 0b 01 00 00 0d 01 00 00     ................
  50:	0f 01 00 00 11 01 00 00 13 01 00 00 15 01 00 00     ................
  60:	17 01 00 00 19 01 00 00 1b 01 00 00 1d 01 00 00     ................
  70:	1f 01 00 00 21 01 00 00 23 01 00 00 25 01 00 00     ....!...#...%...
  80:	27 01 00 00 39 01 00 00 3b 01 00 00 3d 01 00 00     '...9...;...=...
  90:	3f 01 00 00 49 01 00 00 29 01 00 00 2b 01 00 00     ?...I...)...+...
  a0:	5b 01 00 00 2d 01 00 00 31 01 00 00 2f 01 00 00     [...-...1.../...
  b0:	35 01 00 00 33 01 00 00 37 01 00 00 41 01 00 00     5...3...7...A...

000000c0 <Reset_Handler>:
{
     /* Copy init values from text to data */
    uint32_t *init_values_ptr = &_etext;
    uint32_t *data_ptr = &_sdata;

    if (init_values_ptr != data_ptr) {
  c0:	4a09      	ldr	r2, [pc, #36]	; (e8 <Reset_Handler+0x28>)
  c2:	4b0a      	ldr	r3, [pc, #40]	; (ec <Reset_Handler+0x2c>)
  c4:	429a      	cmp	r2, r3
  c6:	d007      	beq.n	d8 <Reset_Handler+0x18>
    uint32_t *data_ptr = &_sdata;
  c8:	4b08      	ldr	r3, [pc, #32]	; (ec <Reset_Handler+0x2c>)
    uint32_t *init_values_ptr = &_etext;
  ca:	4a07      	ldr	r2, [pc, #28]	; (e8 <Reset_Handler+0x28>)
  cc:	e001      	b.n	d2 <Reset_Handler+0x12>
        for (; data_ptr < &_edata;) {
            *data_ptr++ = *init_values_ptr++;
  ce:	ca02      	ldmia	r2!, {r1}
  d0:	c302      	stmia	r3!, {r1}
        for (; data_ptr < &_edata;) {
  d2:	4907      	ldr	r1, [pc, #28]	; (f0 <Reset_Handler+0x30>)
  d4:	428b      	cmp	r3, r1
  d6:	d3fa      	bcc.n	ce <Reset_Handler+0xe>
        }
    }

    /* Clear the zero segment */
    for (uint32_t *bss_ptr = &_sbss; bss_ptr < &_ebss;) {
        *bss_ptr++ = 0;
  d8:	4b06      	ldr	r3, [pc, #24]	; (f4 <Reset_Handler+0x34>)
  da:	e001      	b.n	e0 <Reset_Handler+0x20>
  dc:	2200      	movs	r2, #0
  de:	c304      	stmia	r3!, {r2}
    for (uint32_t *bss_ptr = &_sbss; bss_ptr < &_ebss;) {
  e0:	4a05      	ldr	r2, [pc, #20]	; (f8 <Reset_Handler+0x38>)
  e2:	4293      	cmp	r3, r2
  e4:	d3fa      	bcc.n	dc <Reset_Handler+0x1c>

    /* Branch to main function */
    main();

    /* Infinite loop */
    while (1);
  e6:	e7fe      	b.n	e6 <Reset_Handler+0x26>
  e8:	00000168 	.word	0x00000168
  ec:	20000000 	.word	0x20000000
  f0:	20000000 	.word	0x20000000
  f4:	20000000 	.word	0x20000000
  f8:	20000000 	.word	0x20000000

000000fc <NMI_Handler>:

//  Watchdog Interrupt
void __attribute__((used)) NMI_Handler(void)
{

}
  fc:	4770      	bx	lr

000000fe <HardFault_Handler>:


void __attribute__((used)) HardFault_Handler(void)
{

}
  fe:	4770      	bx	lr

00000100 <SVC_Handler>:

void __attribute__((used)) SVC_Handler(void)
{


}
 100:	4770      	bx	lr

00000102 <PendSV_Handler>:


// Handler for PendSV (Context Switching)
void __attribute__((used)) PendSV_Handler(void) {

}
 102:	4770      	bx	lr

00000104 <Systick_Handler>:


void __attribute__((used)) Systick_Handler(void)
{

}
 104:	4770      	bx	lr

00000106 <GPIO_INT_00_Handler>:


void __attribute__((used)) GPIO_INT_00_Handler(void)
{

}
 106:	4770      	bx	lr

00000108 <GPIO_INT_01_Handler>:

void __attribute__((used)) GPIO_INT_01_Handler(void)
{

}
 108:	4770      	bx	lr

0000010a <GPIO_INT_02_Handler>:

void __attribute__((used)) GPIO_INT_02_Handler(void)
{

}
 10a:	4770      	bx	lr

0000010c <GPIO_INT_03_Handler>:

void __attribute__((used)) GPIO_INT_03_Handler(void)
{

}
 10c:	4770      	bx	lr

0000010e <GPIO_INT_04_Handler>:

void __attribute__((used)) GPIO_INT_04_Handler(void)
{

}
 10e:	4770      	bx	lr

00000110 <GPIO_INT_05_Handler>:

void __attribute__((used)) GPIO_INT_05_Handler(void)
{

}
 110:	4770      	bx	lr

00000112 <GPIO_INT_06_Handler>:

void __attribute__((used)) GPIO_INT_06_Handler(void)
{

}
 112:	4770      	bx	lr

00000114 <GPIO_INT_07_Handler>:

void __attribute__((used)) GPIO_INT_07_Handler(void)
{

}
 114:	4770      	bx	lr

00000116 <GPIO_INT_08_Handler>:

void __attribute__((used)) GPIO_INT_08_Handler(void)
{

}
 116:	4770      	bx	lr

00000118 <GPIO_INT_09_Handler>:

void __attribute__((used)) GPIO_INT_09_Handler(void)
{

}
 118:	4770      	bx	lr

0000011a <GPIO_INT_10_Handler>:

void __attribute__((used)) GPIO_INT_10_Handler(void)
{

}
 11a:	4770      	bx	lr

0000011c <GPIO_INT_11_Handler>:

void __attribute__((used)) GPIO_INT_11_Handler(void)
{

}
 11c:	4770      	bx	lr

0000011e <GPIO_INT_12_Handler>:

void __attribute__((used)) GPIO_INT_12_Handler(void)
{

}
 11e:	4770      	bx	lr

00000120 <GPIO_INT_13_Handler>:

void __attribute__((used)) GPIO_INT_13_Handler(void)
{

}
 120:	4770      	bx	lr

00000122 <GPIO_INT_14_Handler>:

void __attribute__((used)) GPIO_INT_14_Handler(void)
{

}
 122:	4770      	bx	lr

00000124 <GPIO_INT_15_Handler>:

void __attribute__((used)) GPIO_INT_15_Handler(void)
{

}
 124:	4770      	bx	lr

00000126 <GPIO_COMB_INT_Handler>:

void __attribute__((used)) GPIO_COMB_INT_Handler(void)
{

}
 126:	4770      	bx	lr

00000128 <UART0_RX_INT_Handler>:


void __attribute__((used)) UART0_RX_INT_Handler(void)
{

}
 128:	4770      	bx	lr

0000012a <UART0_TXOV_INT_Handler>:


void __attribute__((used)) UART0_TXOV_INT_Handler(void)
{

}
 12a:	4770      	bx	lr

0000012c <UART0_COMB_INT_Handler>:


void __attribute__((used)) UART0_COMB_INT_Handler(void)
{

}
 12c:	4770      	bx	lr

0000012e <UART1_RX_INT_Handler>:

void __attribute__((used)) UART1_RX_INT_Handler(void)
{

}
 12e:	4770      	bx	lr

00000130 <UART1_TX_INT_Handler>:

void __attribute__((used)) UART1_TX_INT_Handler(void)
{

}
 130:	4770      	bx	lr

00000132 <UART1_RXOV_INT_Handler>:

void __attribute__((used)) UART1_RXOV_INT_Handler(void)
{

}
 132:	4770      	bx	lr

00000134 <UART1_TXOV_INT_Handler>:

void __attribute__((used)) UART1_TXOV_INT_Handler(void)
{

}
 134:	4770      	bx	lr

00000136 <UART1_COMB_INT_Handler>:


void __attribute__((used)) UART1_COMB_INT_Handler(void)
{

}
 136:	4770      	bx	lr

00000138 <TIMER_INT_Handler>:

void __attribute__((used)) TIMER_INT_Handler(void)
{

}
 138:	4770      	bx	lr

0000013a <DUALTIMER_INT1_Handler>:

void __attribute__((used)) DUALTIMER_INT1_Handler(void)
{

}
 13a:	4770      	bx	lr

0000013c <DUALTIMER_INT2_Handler>:

void __attribute__((used)) DUALTIMER_INT2_Handler(void)
{

}
 13c:	4770      	bx	lr

0000013e <DUALTIMER_COMB_INT_Handler>:

void __attribute__((used)) DUALTIMER_COMB_INT_Handler(void)
{

}
 13e:	4770      	bx	lr

00000140 <Default_Handler>:

void __attribute__((used)) Default_Handler(void)
{

}
 140:	4770      	bx	lr

00000142 <CMSDK_uart_ClearTxIRQ>:
}

//Uart clear transmitter interrupt
void CMSDK_uart_ClearTxIRQ(CMSDK_UART_TypeDef *UART)
{
      UART->INTCLEAR = UART_INTCLEAR_TX_IRQ_Msk;
 142:	2301      	movs	r3, #1
 144:	60c3      	str	r3, [r0, #12]
}
 146:	4770      	bx	lr

00000148 <UART0_TX_INT_Handler>:
{
 148:	b510      	push	{r4, lr}
    CMSDK_uart_ClearTxIRQ(CMSDK_UART0);
 14a:	2080      	movs	r0, #128	; 0x80
 14c:	05c0      	lsls	r0, r0, #23
 14e:	f7ff fff8 	bl	142 <CMSDK_uart_ClearTxIRQ>
}
 152:	bd10      	pop	{r4, pc}

00000154 <CMSDK_uart_ClearRxIRQ>:

//Uart clear receiver interrupt
void CMSDK_uart_ClearRxIRQ(CMSDK_UART_TypeDef *UART)
{
      UART->INTCLEAR = UART_INTCLEAR_RX_IRQ_Msk;
 154:	2302      	movs	r3, #2
 156:	60c3      	str	r3, [r0, #12]
}
 158:	4770      	bx	lr

0000015a <UART0_RXOV_INT_Handler>:
{
 15a:	b510      	push	{r4, lr}
    CMSDK_uart_ClearRxIRQ(CMSDK_UART1);
 15c:	4801      	ldr	r0, [pc, #4]	; (164 <UART0_RXOV_INT_Handler+0xa>)
 15e:	f7ff fff9 	bl	154 <CMSDK_uart_ClearRxIRQ>
}
 162:	bd10      	pop	{r4, pc}
 164:	40004000 	.word	0x40004000
