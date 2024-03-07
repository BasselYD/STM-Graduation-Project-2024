PROJECT:=main

# Define the output directory
SRC_DIR := src
INC_DIR := include
BUILD_DIR := build
BIN_DIR := build/bin
OBJ_DIR := build/obj


ifneq ($(BUILD_DIR),)
  $(shell [ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR))
  $(shell [ -d $(OBJ_DIR) ] || mkdir -p $(OBJ_DIR))
  $(shell [ -d $(BIN_DIR) ] || mkdir -p $(BIN_DIR))
endif

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

# Output files
TARGET := main
ELF := $(BIN_DIR)/$(TARGET).elf
BIN := $(BIN_DIR)/$(TARGET).bin
HEX := $(BIN_DIR)/$(TARGET).hex
ASM := $(BIN_DIR)/$(TARGET).asm

# toolchain settings
CROSS:=arm-none-eabi-
CC:=$(CROSS)gcc
OBJDUMP:=$(CROSS)objdump
OBJCOPY:=$(CROSS)objcopy

# gcc & ld compiler flags
OPT:=-Og
#	"Optimize for Debugging." It enables optimizations that don't interfere with debugging.

FLAGS:=-mcpu=cortex-m0 -mthumb
#	Cortex M0 with Thumb instructions.

CFLAGS:=$(FLAGS) $(OPT) -fno-common -g3 -Wall -Werror -Wextra -MD -I$(INC_DIR) -flto
#	-fno-common: specifies that the compiler places uninitialized global variables in the BSS section of the object file.
#	-g3: includes debugging information in the generated object files at the highest level (level 3).
#	-Wall -Werror -Wextra:  enable additional warning messages during compilation and treat them as errors (-Werror).
#	 						-Wall enables most warning messages, -Wextra enables additional warnings beyond those enabled by -Wall.

LDFLAGS:=$(FLAGS) -TlinkerScript.ld -nostartfiles -nostdlib -lnosys -flto
#	-Tminimal.ld: This flag specifies the linker script (minimal.ld).
#	-nostartfiles: Tells the linker not to use the standard system startup files.
#	-nostdlib: Instructs the linker not to use the standard system libraries.
#	-lnosys: Specifies a library (nosys) to link, which provides implementation for some system calls implemented as stubs that return errors when called.

# Main source file
#MAIN_SRC := $(SRC_DIR)/main.c

.PHONY: all clean


all: $(ELF) $(BIN) $(HEX) $(ASM)


$(ELF): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
#	python .\insert_newlines.py $(BIN) $(BIN)

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

$(ASM): $(ELF)
	$(OBJDUMP) -S $< > $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@
# n.o is made automatically from n.c with a recipe of the form ‘$(CC) $(CPPFLAGS) $(CFLAGS) -c’.


clean:
	rm -rf $(BUILD_DIR)

-include $(DEPS)
