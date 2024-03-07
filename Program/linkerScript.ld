ENTRY(Reset_Handler)

MEMORY
{												
	IRAM (rx) : ORIGIN = (0x00000000), LENGTH = 0x100000
	DRAM (rwx)  : ORIGIN = (0x20000000), LENGTH = 0x100000
}

SECTIONS
{

	.text :
	{
		/* interrupt vector table at the start of flash */
		. = ALIGN(4);
		KEEP(*(.vtor));
		. = ALIGN(4);

		/* rest of code & const data */
		*(.text*)
		*(.rodata*)

		_etext = .;
	} >IRAM
	
	
	.data :
	{
		_sdata = .;

		*(.data*)

		_edata = .;
	} > DRAM


	.bss (NOLOAD):
	{
		_sbss = .;

		*(.bss*)
		*(COMMON)

		StackTop = ORIGIN(DRAM) + LENGTH(DRAM);

		_ebss = .;
	} > DRAM
}
