PROJECT:=main

# Define the output directory
BUILD_DIR := build
BIN_DIR := $(BUILD_DIR)/bin
OBJ_DIR := $(BUILD_DIR)/obj

MODULES := MCAL HAL Common
SRC_DIRS := $(addsuffix /src/,$(MODULES))
INC_PATHS := $(addsuffix /include/,$(MODULES))
INCDIRS := $(addprefix -I,$(INC_PATHS))


ifneq ($(BUILD_DIR),)
  $(shell [ -d $(BUILD_DIR) ] || mkdir -p $(BUILD_DIR))
  $(shell [ -d $(OBJ_DIR) ] || mkdir -p $(OBJ_DIR))
  $(shell [ -d $(BIN_DIR) ] || mkdir -p $(BIN_DIR))
endif

# Specify the unit test source files
UNIT_TESTS := Unit_test/src/dma_test.c Unit_test/src/serial_test.c Unit_test/src/timer_test.c

ifdef SELECTED_TEST
    SELECTED_SRC := $(filter $(SELECTED_TEST),$(UNIT_TESTS))
else
    SELECTED_SRC := APP/src/main.c
endif

SRCS := $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)*.c))
SRCS += $(SELECTED_SRC)
OBJS := $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(SRCS)))

$(info SRC_DIRS: $(SRC_DIRS))
$(info INC_DIRS: $(INC_PATHS))
$(info SRCS: $(SRCS))
$(info OBJS: $(OBJS))

# Output files
TARGET := $(notdir $(basename $(SELECTED_SRC)))
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

CFLAGS:=$(FLAGS) $(OPT) -fno-common -g3 -Wall -Werror -Wextra -MD $(INCDIRS) -flto
#	-fno-common: specifies that the compiler places uninitialized global variables in the BSS section of the object file.
#	-g3: includes debugging information in the generated object files at the highest level (level 3).
#	-Wall -Werror -Wextra:  enable additional warning messages during compilation and treat them as errors (-Werror).
#	 						-Wall enables most warning messages, -Wextra enables additional warnings beyond those enabled by -Wall.

LDFLAGS:=$(FLAGS) -TlinkerScript.ld -nostartfiles --specs=nosys.specs -lnosys -flto
#	-Tminimal.ld: This flag specifies the linker script (minimal.ld).
#	-nostartfiles: Tells the linker not to use the standard system startup files.
#	-nostdlib: Instructs the linker not to use the standard system libraries.
#	-lnosys: Specifies a library (nosys) to link, which provides implementation for some system calls implemented as stubs that return errors when called.


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

$(OBJ_DIR)/%.o: $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)*.c)) $(SELECTED_SRC)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $(filter %/$(notdir $(basename $@)).c,$^) -o $@
# n.o is made automatically from n.c with a recipe of the form ‘$(CC) $(CPPFLAGS) $(CFLAGS) -c’.


.depend: $(SRCS)
	$(CC) $(CFLAGS) -MM $^ > .depend;


clean:
	rm -rf $(BUILD_DIR)

#-include $(DEPS)
