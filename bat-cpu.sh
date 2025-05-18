#!/bin/bash

# Configuration
ac_adapter="AC"
battery="BAT0"
check_interval=5 # Check every 5 seconds

while true; do
  # Check if the AC adapter is online (indicating charging or charged)
  if [ -f /sys/class/power_supply/"$battery"/status ] && [ "$(cat /sys/class/power_supply/"$battery"/status)" == "Charging" ]; then
    sudo auto-cpufreq --force=performance
    echo "$(date): Charging or AC connected - auto-cpufreq performance"
  elif [ -f /sys/class/power_supply/"$battery"/status ] && [ "$(cat /sys/class/power_supply/"$battery"/status)" == "Discharging" ]; then
    sudo auto-cpufreq --force=powersave
    echo "$(date): Discharging - auto-cpufreq powersave"
  else
    # Handle other states (e.g., Fully charged, Not charging)
    # You might want a different behavior here, or just keep powersave.
    sudo auto-cpufreq --force=powersave
    echo "$(date): Battery status other than discharging - auto-cpufreq powersave"
  fi

  sleep "$check_interval"
done
