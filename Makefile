#COMPILE_OPTS = -mcpu=cortex-m3 -mthumb -Wall -pedantic -g -Os -fno-common -msoft-float 
COMPILE_OPTS =  -mcpu=cortex-m3 -mthumb -Wall -g -Os -fno-common
INCLUDE_DIRS = -I. -Istm32f10x_lib/inc -ICM530_HW/inc -ICM530_APP/inc
#INCLUDE_DIRS = -I.
LIBRARY_DIRS = -Lstm32f10x_lib

# For WinAVR:
# TCHAIN_PREFIX=arm-eabi-

# For GNU ARM Toolchain - Linux
TCHAIN_PREFIX=arm-none-eabi-


CC = $(TCHAIN_PREFIX)gcc
CFLAGS = $(COMPILE_OPTS) $(INCLUDE_DIRS) 

CXX = $(TCHAIN_PREFIX)g++
CXXFLAGS = $(COMPILE_OPTS) $(INCLUDE_DIRS) 

AS = $(TCHAIN_PREFIX)gcc
ASFLAGS = $(COMPILE_OPTS) -c 

LD = $(TCHAIN_PREFIX)gcc
#LDFLAGS = -Wl,--gc-sections,-Map=$@.map,-cref,-u,Reset_Handler $(INCLUDE_DIRS) $(LIBRARY_DIRS) -T stm32.ld  -lm $(COMPILE_OPTS) 
LDFLAGS =  -Wl,--gc-sections,-Map=$@.map,-cref,-u,Reset_Handler $(INCLUDE_DIRS) $(LIBRARY_DIRS) -T stm32.ld

OBJCP = $(TCHAIN_PREFIX)objcopy
OBJCPFLAGS_HEX = -O ihex
OBJCPFLAGS_BIN = -O binary

OBJDUMP = $(TCHAIN_PREFIX)objdump
OBJDUMPFLAGS = -h -S -C -D


AR = $(TCHAIN_PREFIX)ar
ARFLAGS = cr

MAIN_OUT = CM530
MAIN_OUT_ELF = $(MAIN_OUT).elf
MAIN_OUT_HEX = $(MAIN_OUT).hex
MAIN_OUT_BIN = $(MAIN_OUT).bin
MAIN_OUT_LSS = $(MAIN_OUT).lss


# all

all: $(MAIN_OUT_ELF) $(MAIN_OUT_HEX) $(MAIN_OUT_BIN) $(MAIN_OUT_LSS)

# main

MAIN_OBJS = \
 CM530_APP/src/main.o \
 CM530_APP/src/stm32f10x_it.o \
 CM530_APP/src/BioloidEx.o \
 CM530_APP/src/serial.o \
 CM530_APP/src/dynamixel.o \
 CM530_APP/src/zigbee.o \
 CM530_HW/src/adc.o \
 CM530_HW/src/button.o \
 CM530_HW/src/led.o \
 CM530_HW/src/mic.o \
 CM530_HW/src/system_func.o \
 CM530_HW/src/system_init.o \
 CM530_HW/src/usart.o \
 
 

$(MAIN_OUT_ELF): $(MAIN_OBJS) stm32f10x_lib/libstm32.a
	$(LD) $(LDFLAGS) $(MAIN_OBJS) stm32f10x_lib/libstm32.a --output $@

$(MAIN_OUT_HEX): $(MAIN_OUT_ELF)
	$(OBJCP) $(OBJCPFLAGS_HEX) $< $@

$(MAIN_OUT_BIN): $(MAIN_OUT_ELF)
	$(OBJCP) $(OBJCPFLAGS_BIN) $< $@

$(MAIN_OUT_LSS): $(MAIN_OUT_ELF)
	$(OBJDUMP) $(OBJDUMPFLAGS) $< > $@


# libstm32.a

LIBSTM32_OUT = stm32f10x_lib/libstm32.a

LIBSTM32_OBJS = \
 stm32f10x_lib/src/stm32f10x_adc.o \
 stm32f10x_lib/src/stm32f10x_bkp.o \
 stm32f10x_lib/src/stm32f10x_can.o \
 stm32f10x_lib/src/stm32f10x_dma.o \
 stm32f10x_lib/src/stm32f10x_exti.o \
 stm32f10x_lib/src/stm32f10x_flash.o \
 stm32f10x_lib/src/stm32f10x_gpio.o \
 stm32f10x_lib/src/stm32f10x_i2c.o \
 stm32f10x_lib/src/stm32f10x_iwdg.o \
 stm32f10x_lib/src/stm32f10x_lib.o \
 stm32f10x_lib/src/stm32f10x_nvic.o \
 stm32f10x_lib/src/stm32f10x_pwr.o \
 stm32f10x_lib/src/stm32f10x_rcc.o \
 stm32f10x_lib/src/stm32f10x_rtc.o \
 stm32f10x_lib/src/stm32f10x_spi.o \
 stm32f10x_lib/src/stm32f10x_systick.o \
 stm32f10x_lib/src/stm32f10x_tim.o \
 stm32f10x_lib/src/stm32f10x_tim1.o \
 stm32f10x_lib/src/stm32f10x_usart.o \
 stm32f10x_lib/src/stm32f10x_wwdg.o \
 stm32f10x_lib/src/cortexm3_macro.o \
 stm32f10x_lib/src/stm32f10x_vector.o

$(LIBSTM32_OUT): $(LIBSTM32_OBJS)
	$(AR) $(ARFLAGS) $@ $(LIBSTM32_OBJS)

$(LIBSTM32_OBJS): stm32f10x_conf.h


clean:
	-rm $(MAIN_OBJS) $(LIBSTM32_OBJS) $(LIBSTM32_OUT) $(MAIN_OUT_ELF) $(MAIN_OUT_HEX) $(MAIN_OUT_BIN) $(MAIN_OUT_LSS) $(MAIN_OUT_ELF).map
