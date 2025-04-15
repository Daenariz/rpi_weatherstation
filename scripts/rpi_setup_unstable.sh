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

# Load 1-Wire Kernel Modules 

echo "Loading 1-Wire kernel modules..."
sudo modprobe w1-gpio || error_exit "Loading w1-gpio module failed."
sudo modprobe w1-therm || error_exit "Loading w1-therm module failed." 

# Verify 1-Wire Sensor 

echo "Verifying 1-Wire sensor..."
SENSOR_BASE="/sys/bus/w1/devices" 

shopt -s nullglob
sensor_dirs=("SENSORB​ASE"/28−∗)if[{#sensor_dirs[@]} -gt 0 ]; then
    SENSOR_DIR="${sensor_dirs[0]}"
    echo "1-Wire sensor detected in directory: $SENSOR_DIR"
    if [ -f "$SENSOR_DIR/w1_slave" ]; then
       cat "$SENSOR_DIR/w1_slave"
    else
       echo "File w1_slave not found in sensor directory."
    fi
else
    echo "1-Wire sensor not detected. Please check your wiring and sensor."
fi
shopt -u nullglob
echo "1-Wire configuration completed." 

# Docker Installation 

#echo "Installing Docker..."
#curl -sSL https://get.docker.com  | sh || error_exit "Docker installation failed."
#sudo usermod -aG docker "USER"∣∣errore​xit"AddingusertoDockergroupfailed."groups"{USER}"
#sudo systemctl enable docker || error_exit "Enabling Docker service failed." 

# Verify Docker Installation 

#echo "Verifying Docker installation..."
#docker --version || error_exit "Docker does not appear to be installed correctly."
#sudo docker run hello-world || error_exit "Running the hello-world container failed."
#docker images 

# Optional: Docker Compose Setup 

#if [ "$1" == "--withdockercompose" ]; then
#  echo "Executing Docker Compose setup..." 
#Check if Docker Compose is available 
#
#  if ! docker compose version >/dev/null 2>&1; then
#    echo "Docker Compose does not seem to be installed. Installing..."
#    # Insert installation steps for Docker Compose if needed.
#    error_exit "Docker Compose installation should be implemented here."
#  else
#    echo "Docker Compose is already installed."
#    echo "Starting containers with Docker Compose..."
#    sudo docker compose up -d || error_exit "Starting Docker Compose containers failed."
#  fi
#else
#  echo "Skipping Docker Compose setup (--withdockercompose flag not set)."
#fi 

# Edit Raspberry Pi Configuration File 

#echo "Opening Raspberry Pi configuration file for editing..."
#sudo nano /boot/firmware/config.txt 

echo "Script completed successfully." 
