#!/bin/bash 

set -e 
# Function for error output and exit 

error_exit() {
  echo "Error: $1" >&2
  exit 1
} 

# System Update and Package Installation 

echo "Starting system update, upgrade and installation of Git and Vim..."
sudo apt-get update || error_exit "apt-get update failed."
sudo apt-get -y upgrade || error_exit "apt-get upgrade failed."
sudo apt-get -y install git vim || error_exit "Installation of git and vim failed." 

# Enable 1-Wire Interface 

echo "Enabling 1-Wire interface..."
sudo raspi-config nonint do_onewire 0 || error_exit "Enabling the 1-Wire interface failed." 

# Configure GPIO for 1-Wire on GPIO Pin 17
echo "Configuring GPIO for 1-Wire on GPIO17..."
sudo cp /boot/firmware/config.txt /boot/firmware/config_backup.txt
sudo sed -i '/^dtoverlay=w1-gpio/ s/.*/dtoverlay=w1-gpio,gpiopin=17/' /boot/firmware/config.txt || echo "dtoverlay=w1-gpio,gpiopin=17" | sudo tee -a /boot/firmware/config.txt
# Maybe use pinctrl set 17 pu

# Load 1-Wire Kernel Modules 

echo "Loading 1-Wire kernel modules..."
sudo modprobe w1-gpio || error_exit "Loading w1-gpio module failed."
sudo modprobe w1-therm || error_exit "Loading w1-therm module failed." 

# Verify 1-Wire Sensor ###not working because reboot is needed. Maybe wen can use this snippet somehow else
#
#echo "Verifying 1-Wire sensor..."
#SENSOR_BASE="/sys/bus/w1/devices" 
#
#shopt -s nullglob
#sensor_dirs=("SENSOR_BASE"/28−*)
#if [ ${#sensor_dirs[@]} -gt 0 ]; then
#    SENSOR_DIR="${sensor_dirs[0]}"
#    echo "1-Wire sensor detected in directory: $SENSOR_DIR"
#    if [ -f "$SENSOR_DIR/w1_slave" ]; then
#       cat "$SENSOR_DIR/w1_slave"
#    else
#       echo "File w1_slave not found in sensor directory."
#    fi
#else
#    echo "1-Wire sensor not detected. Please check your wiring and sensor."
#fi
#shopt -u nullglob
echo "1-Wire configuration completed." 
echo "Script completed successfully. Please reboot." 
