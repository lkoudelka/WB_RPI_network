#!/bin/bash
#$1 - IP address - 192.168.0.10 or 192.168.0.11
#$2 - port 3333 or 3334
gdb-multiarch --eval-command="target remote $1:$2" "WB55_LED_toggle.elf" --eval-command="load GPIO_IOToggle_slow.hex" --batch
