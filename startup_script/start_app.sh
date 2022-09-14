#!/bin/sh
sudo openocd -f /usr/share/openocd/scripts/interface/openocd_swd.cfg &
sudo openocd -f /usr/share/openocd/scripts/interface/openocd_USB.cfg &
#sleep 30
ser2net -C /etc/ser2net.conf
ser2net
