#!/bin/bash
#$1 - IP address - 192.168.0.10 or 192.168.0.11
#$2 - port 3333 or 3334 (USB STlink)

#NO_INIT(static uint32_t FUS_Command); - ox20000130
#NO_INIT(static uint32_t N_FUS_Command); - ox20000134
#NO_INIT(static uint32_t FUS_is_idle); - ox20000138
#
#var FUS_Command = 0x20000130
#var N_FUS_Command = 0x20000134
#var FUS_is_idle = 0x20000138

#var FUS_COMMAND_FWDELETE = 0x11FF11FF
#var N_FUS_COMMAND_FWDELETE = 0xEE00EE00
#var FUS_COMMAND_FWUPGRADE = 0x55FF55FF
#var N_FUS_COMMAND_FWUPGRADE = 0xAA00AA00
#var FUS_COMMAND_STARTWS = 0x55005500
#var N_FUS_COMMAND_STARTWS = 0xAAFFAAFF
#define FUS_COMMAND_FWDELETE               ((uint32_t) 0x11FF11FF)
#define N_FUS_COMMAND_FWDELETE             ((uint32_t) 0xEE00EE00)
#define FUS_COMMAND_FWUPGRADE              ((uint32_t) 0x55FF55FF)
#define N_FUS_COMMAND_FWUPGRADE            ((uint32_t) 0xAA00AA00)
#define FUS_COMMAND_STARTWS                ((uint32_t) 0x55005500)
#define N_FUS_COMMAND_STARTWS              ((uint32_t) 0xAAFFAAFF)
#gdb-multiarch --eval-command="target remote $1:$2" "/home/rftomas/RPi_network/FUS_update/FUS_Operator_Lite.elf" --eval-command="load /home/rftomas/RPi_network/FUS_update/FUS_Operator_Lite.hex" --eval-command="break main.c:299" --eval-command="c" --eval-command="set {int}0x20000130 = 0x11FF11FF" --eval-command="set {int}0x20000134 = 0xEE00EE00" --eval-command="c" -batch
now=$(date)
echo "$now"
timeout 30 gdb-multiarch --eval-command="target remote $1:$2" "FUS_Operator_Lite.elf" --eval-command="load FUS_Operator_Lite.hex" --eval-command="break main.c:299" --eval-command="c" --eval-command="set {int}0x20000130 = 0x11FF11FF" --eval-command="set {int}0x20000134 = 0xEE00EE00" --eval-command="c" -batch
EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
    echo "error detected"
    exit
fi
echo "delete done, exit status $?"
#gdb-multiarch --eval-command="target remote $1:$2" "/home/rftomas/RPi_network/FUS_update/FUS_Operator_Lite.elf" --eval-command="load /home/rftomas/RPi_network/FUS_update/FUS_Operator_Lite.hex" -batch
echo "load stack hex file"
echo ""
#--eval-command="monitor reset halt" --eval-command="monitor sleep 50" --eval-command="monitor reset run" --eval-command="monitor sleep 1000"
timeout 30 gdb-multiarch --eval-command="target remote $1:$2" "FUS_Operator_Lite.elf" --eval-command="monitor reset halt" --eval-command="monitor sleep 50" --eval-command="monitor reset run" --eval-command="monitor sleep 500" --eval-command="load STM32WB5x_v1.13.2/stm32wb5x_BLE_Stack_full_fw.hex" -batch
EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
    echo "error detected"
    exit
fi
echo ""
echo "stack hex loaded, exit status $?"
echo "process with FUS"
echo ""
timeout 30 gdb-multiarch --eval-command="target remote $1:$2" "FUS_Operator_Lite.elf" --eval-command="load FUS_Operator_Lite.hex"  --eval-command="break main.c:299" --eval-command="c" --eval-command="set {int}0x20000130 = 0x55FF55FF" --eval-command="set {int}0x20000134 = 0xAA00AA00" --eval-command="c" -batch
EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
    echo "error detected"
    exit
fi
echo ""
echo "ended FUS operation, exit status $?"
echo ""
timeout 30 gdb-multiarch --eval-command="target remote $1:$2" "FUS_Operator_Lite.elf" -eval-command="break main.c:299" --eval-command="c" -batch
EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
    echo "error detected"
    exit
fi

now=$(date)
echo "$now"
#--eval-command="monitor reset halt" --eval-command="shell sleep 1" --eval-command="monitor reset run"
#--eval-command="load /home/rftomas/RPi_network/FUS_update/FUS_Operator_Lite.hex"
#gdb-multiarch --eval-command="target remote $1:$2" "/home/rftomas/RPi_network/FUS_update/FUS_Operator_Lite.elf" --eval-command="load /home/rftomas/RPi_network/FUS_update/STM32WB5x_v1.13.2/stm32wb5x_BLE_Stack_full_fw.hex"
