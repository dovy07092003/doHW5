#!/bin/bash
# A small Bash script to set up User LED3 to be turned on or off from 
#  Linux console. Written by Derek Molloy (derekmolloy.ie) for the 
#  book Exploring BeagleBone.

# The script will accept two new command-line arguments blink and an integer n
# The LED will blink n times
# The LED still remains on for 1 second and off for 1 second
# The LED will be turned on by using echo "1" >> "$LED3_PATH/brightness"
# Turn the LED on: ./led-hw5.sh on
# Turn the LED off:./led-hw5.sh off
# Flashing the LED: sudo ./led-hw5.sh flash
# Status for the LED: ./led-hw5.sh status
# Blinking for the LED: ./led-hw5.sh status


LED3_PATH=/sys/class/leds/beaglebone:green:usr3

# Example bash function
function removeTrigger
{
  echo "none" >> "$LED3_PATH/trigger"
}

echo "Starting the LED Bash Script"
if [ $# -eq 0 ]; then
  echo "There are no arguments. Usage is:"
  echo -e " bashLED Command \n  where command is one of "
  echo -e "   on, off, flash or status  \n e.g. bashLED on "
  exit 2
fi
echo "The LED Command that was passed is: $1"
if [ "$1" == "on" ]; then
  echo "Turning the LED on"
  removeTrigger
  echo "1" >> "$LED3_PATH/brightness"
elif [ "$1" == "off" ]; then
  echo "Turning the LED off"
  removeTrigger
  echo "0" >> "$LED3_PATH/brightness"
elif [ "$1" == "flash" ]; then
  echo "Flashing the LED"
  removeTrigger
  echo "timer" >> "$LED3_PATH/trigger"
  sleep 1
  echo "100" >> "$LED3_PATH/delay_off"
  echo "100" >> "$LED3_PATH/delay_on"
elif [ "$1" == "status" ]; then
  cat "$LED3_PATH/trigger";
elif [ "$1" == "blink" ];then
	blink_time=$2
	echo "Blinking the LED $2 times"
	removeTrigger
	while [ $blink_time -gt 0 ]
	do
	  sleep 1
	  echo "1" >> "$LED3_PATH/brightness"
	  sleep 1
	  echo "0" >> "$LED3_PATH/brightness"
	  blink_time=$(($blink_time -1))
	done
fi
echo "End of the LED Bash Script"
