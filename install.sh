#!/bin/bash

echo "Starting installation process..."

# Update and upgrade system
echo "Step 1: Updating package list..."
sudo apt-get update
echo "Package list updated."

echo "Step 2: Upgrading packages..."
sudo apt-get upgrade -y
echo "Packages upgraded."

# Configure Raspberry Pi
echo "Step 3: Configuring Raspberry Pi settings..."
sudo raspi-config nonint do_i2c 0
echo "I2C Bus enabled."

# Install i2c-tools and detect I2C devices
echo "Step 4: Installing i2c-tools..."
sudo apt-get install -y i2c-tools
echo "i2c-tools installed."

echo "Step 5: Detecting I2C devices..."
i2cdetect -y 1
echo "I2C devices detected."

# Install Python pip and adafruit-circuitpython-bmp280
echo "Step 6: Installing Python3 pip..."
sudo apt-get install -y python3-pip
echo "Python3 pip installed."

echo "Step 7: Installing adafruit-circuitpython-bmp280..."
sudo pip3 install adafruit-circuitpython-bmp280
echo "adafruit-circuitpython-bmp280 installed."

# Install and configure InfluxDB
echo "Step 8: Setting up InfluxDB repository..."
curl https://repos.influxdata.com/influxdata-archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/influxdb-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/influxdb-archive-keyring.gpg] https://repos.influxdata.com/debian stable main" | sudo tee /etc/apt/sources.list.d/influxdb.list
echo "InfluxDB repository set up."

echo "Step 9: Updating package list for InfluxDB..."
sudo apt-get update
echo "Package list for InfluxDB updated."

echo "Step 10: Installing InfluxDB..."
sudo apt-get install -y influxdb
echo "InfluxDB installed."

echo "Step 11: Unmasking, enabling, and starting InfluxDB service..."
sudo systemctl unmask influxdb
sudo systemctl enable influxdb
sudo systemctl start influxdb
echo "InfluxDB service started."

echo "Step 12: Checking InfluxDB service status..."
if sudo systemctl is-active --quiet influxdb; then
    echo "InfluxDB is active."
else
    echo "InfluxDB is not active. Please check the service."
fi

# Create
