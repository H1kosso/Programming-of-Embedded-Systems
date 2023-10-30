################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../source/LPC55S69_ProjectMOLAB3.c \
../source/oled.c \
../source/semihost_hardfault.c 

C_DEPS += \
./source/LPC55S69_ProjectMOLAB3.d \
./source/oled.d \
./source/semihost_hardfault.d 

OBJS += \
./source/LPC55S69_ProjectMOLAB3.o \
./source/oled.o \
./source/semihost_hardfault.o 


# Each subdirectory must supply rules for building sources it contributes
source/%.o: ../source/%.c source/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -D__REDLIB__ -DCPU_LPC55S69JBD100 -DCPU_LPC55S69JBD100_cm33 -DCPU_LPC55S69JBD100_cm33_core0 -DSDK_OS_BAREMETAL -DSERIAL_PORT_TYPE_UART=1 -DSDK_DEBUGCONSOLE=1 -DCR_INTEGER_PRINTF -DPRINTF_FLOAT_ENABLE=0 -D__MCUXPRESSO -D__USE_CMSIS -DDEBUG -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/board" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/source" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/drivers" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/device" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/CMSIS" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/utilities" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/component/uart" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/component/serial_manager" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/component/lists" -I"/Users/ki_15/Documents/MCUXpressoIDE_11.8.0_1165/workspace/LPC55S69_ProjectMOLAB3/startup" -O0 -fno-common -g3 -Wall -c -ffunction-sections -fdata-sections -ffreestanding -fno-builtin -fmerge-constants -fmacro-prefix-map="$(<D)/"= -mcpu=cortex-m33 -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -D__REDLIB__ -fstack-usage -specs=redlib.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-source

clean-source:
	-$(RM) ./source/LPC55S69_ProjectMOLAB3.d ./source/LPC55S69_ProjectMOLAB3.o ./source/oled.d ./source/oled.o ./source/semihost_hardfault.d ./source/semihost_hardfault.o

.PHONY: clean-source

