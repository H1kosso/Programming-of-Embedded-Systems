/***********************************************************************************************************************
 * This file was generated by the MCUXpresso Config Tools. Any manual edits made to this file
 * will be overwritten if the respective MCUXpresso Config Tools is used to update this file.
 **********************************************************************************************************************/

/* clang-format off */
/* TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
!!GlobalInfo
product: Peripherals v13.0
processor: LPC55S69
package_id: LPC55S69JBD100
mcu_data: ksdk2_0
processor_version: 14.0.0
board: LPCXpresso55S69
functionalGroups:
- name: BOARD_InitPeripherals_cm33_core0
  UUID: 61d0725d-b300-49cb-9c66-b5edfbf8ffc1
  called_from_default_init: true
  selectedCore: cm33_core0
- name: BOARD_InitPeripherals_cm33_core1
  UUID: e2041cd4-ebb6-45a5-807f-e0c2dc047d48
  selectedCore: cm33_core1
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS **********/

/* TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
component:
- type: 'system'
- type_id: 'system'
- global_system_definitions:
  - user_definitions: ''
  - user_includes: ''
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS **********/

/* TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
component:
- type: 'uart_cmsis_common'
- type_id: 'uart_cmsis_common_9cb8e302497aa696fdbb5a4fd622c2a8'
- global_USART_CMSIS_common:
  - quick_selection: 'default'
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS **********/

/* TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
component:
- type: 'gpio_adapter_common'
- type_id: 'gpio_adapter_common_57579b9ac814fe26bf95df0a384c36b6'
- global_gpio_adapter_common:
  - quick_selection: 'default'
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS **********/
/* clang-format on */

/***********************************************************************************************************************
 * Included files
 **********************************************************************************************************************/
#include "peripherals.h"

/***********************************************************************************************************************
 * BOARD_InitPeripherals_cm33_core0 functional group
 **********************************************************************************************************************/
/***********************************************************************************************************************
 * NVIC initialization code
 **********************************************************************************************************************/
/* clang-format off */
/* TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
instance:
- name: 'NVIC'
- type: 'nvic'
- mode: 'general'
- custom_name_enabled: 'false'
- type_id: 'nvic_57b5eef3774cc60acaede6f5b8bddc67'
- functional_group: 'BOARD_InitPeripherals_cm33_core0'
- peripheral: 'NVIC'
- config_sets:
  - nvic:
    - interrupt_table:
      - 0: []
    - interrupts: []
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS **********/
/* clang-format on */

/* Empty initialization function (commented out)
static void NVIC_init(void) {
} */

/***********************************************************************************************************************
 * CTIMER2 initialization code
 **********************************************************************************************************************/
/* clang-format off */
/* TEXT BELOW IS USED AS SETTING FOR TOOLS *************************************
instance:
- name: 'CTIMER2'
- type: 'ctimer'
- mode: 'PWM'
- custom_name_enabled: 'false'
- type_id: 'ctimer_44573e4bbd77c18d33bceb2e7900a074'
- functional_group: 'BOARD_InitPeripherals_cm33_core0'
- peripheral: 'CTIMER2'
- config_sets:
  - fsl_ctimer:
    - ctimerConfig:
      - mode: 'kCTIMER_TimerMode'
      - clockSource: 'FunctionClock'
      - clockSourceFreq: 'BOARD_BootClockPLL150M'
      - timerPrescaler: '15000'
    - EnableTimerInInit: 'true'
    - pwmConfig:
      - pwmPeriodChannel: 'kCTIMER_Match_3'
      - pwmPeriodValueStr: '100'
      - enableInterrupt: 'true'
      - pwmChannels:
        - 0:
          - pwmChannelPrefixId: 'PWM_1'
          - pwmChannel: 'kCTIMER_Match_1'
          - pwmDutyValueStr: '50'
          - enableInterrupt: 'false'
        - 1:
          - pwmChannelPrefixId: 'PWM_2'
          - pwmChannel: 'kCTIMER_Match_2'
          - pwmDutyValueStr: '50'
          - enableInterrupt: 'false'
    - interruptCallbackConfig:
      - interrupt:
        - IRQn: 'CTIMER2_IRQn'
        - enable_priority: 'true'
        - priority: '0'
      - callback: 'kCTIMER_SingleCallback'
      - singleCallback: 'cbTimer_Match'
 * BE CAREFUL MODIFYING THIS COMMENT - IT IS YAML SETTINGS FOR TOOLS **********/
/* clang-format on */
const ctimer_config_t CTIMER2_config = {
  .mode = kCTIMER_TimerMode,
  .input = kCTIMER_Capture_0,
  .prescale = 14999
};
/* Single callback functions definition */
ctimer_callback_t CTIMER2_callback[] = {cbTimer_Match};

static void CTIMER2_init(void) {
  /* CTIMER2 peripheral initialization */
  CTIMER_Init(CTIMER2_PERIPHERAL, &CTIMER2_config);
  /* Interrupt vector CTIMER2_IRQn priority settings in the NVIC. */
  NVIC_SetPriority(CTIMER2_TIMER_IRQN, CTIMER2_TIMER_IRQ_PRIORITY);
  /* PWM channel 1 of CTIMER2 peripheral initialization */
  CTIMER_SetupPwmPeriod(CTIMER2_PERIPHERAL, CTIMER2_PWM_PERIOD_CH, CTIMER2_PWM_1_CHANNEL, CTIMER2_PWM_PERIOD, CTIMER2_PWM_1_DUTY, false);
  /* PWM channel 2 of CTIMER2 peripheral initialization */
  CTIMER_SetupPwmPeriod(CTIMER2_PERIPHERAL, CTIMER2_PWM_PERIOD_CH, CTIMER2_PWM_2_CHANNEL, CTIMER2_PWM_PERIOD, CTIMER2_PWM_2_DUTY, false);
  /* Enable interrupt of PWM channel 3 that determinates the PWM period */
  CTIMER_EnableInterrupts(CTIMER2_PERIPHERAL, kCTIMER_Match3InterruptEnable);
  CTIMER_RegisterCallBack(CTIMER2_PERIPHERAL, CTIMER2_callback, kCTIMER_SingleCallback);
  /* Enable interrupt CTIMER2_IRQn request in the NVIC. */
  EnableIRQ(CTIMER2_TIMER_IRQN);
  /* Start the timer */
  CTIMER_StartTimer(CTIMER2_PERIPHERAL);
}

/***********************************************************************************************************************
 * Initialization functions
 **********************************************************************************************************************/
void BOARD_InitPeripherals_cm33_core0(void)
{
  /* Initialize components */
  CTIMER2_init();
}

/***********************************************************************************************************************
 * BOARD_InitBootPeripherals function
 **********************************************************************************************************************/
void BOARD_InitBootPeripherals(void)
{
  BOARD_InitPeripherals_cm33_core0();
}
