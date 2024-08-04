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

# Create InfluxDB database
echo "Step 13: Creating InfluxDB database 'environment'..."
influx -execute "CREATE DATABASE environment"
echo "InfluxDB database 'environment' created."

# Install Python InfluxDB client
echo "Step 14: Installing Python InfluxDB client..."
sudo /usr/bin/python3 -m pip install influxdb
echo "Python InfluxDB client installed."

# Create systemd service for the environment monitoring script
SERVICE_FILE="/etc/systemd/system/environment.service"
echo "Step 15: Creating systemd service file for environment monitoring..."

sudo bash -c "cat > $SERVICE_FILE" << 'EOF'
[Unit]
Description=Environment
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/matthew/bmp280/main.py
WorkingDirectory=/home/matthew/bmp280
StandardOutput=inherit
StandardError=inherit
Restart=always
User=root
Group=root
AmbientCapabilities=CAP_NET_RAW

[Install]
WantedBy=default.target
EOF

echo "Systemd service file created."

# Download the monitoring script
echo "Step 16: Downloading environment monitoring script..."
mkdir -p /home/matthew/bmp280
curl -o /home/matthew/bmp280/main.py https://raw.githubusercontent.com/etlmwwn/bmp280_environment_monitor/main/main_influx_v2_standalone.py
echo "Environment monitoring script downloaded."

# Enable and start the environment monitoring service
echo "Step 17: Reloading systemd daemon..."
sudo systemctl daemon-reload
echo "Systemd daemon reloaded."

echo "Step 18: Enabling environment monitoring service..."
sudo systemctl enable environment.service
echo "Environment monitoring service enabled."

echo "Step 19: Starting environment monitoring service..."
sudo systemctl start environment.service
echo "Environment monitoring service started."

echo "Step 20: Checking environment monitoring service status..."
if sudo systemctl is-active --quiet environment.service; then
    echo "Environment monitoring service is active."
else
    echo "Environment monitoring service is not active. Please check the service."
fi

# Query the latest measurements and print to screen
echo "Step 21: Querying latest measurements from InfluxDB..."
LATEST_MEASUREMENTS=$(influx -database 'environment' -execute 'SELECT * FROM "measurement_name" ORDER BY time DESC LIMIT 1' -format 'csv')
echo "Latest measurements:"
echo "$LATEST_MEASUREMENTS"

echo "Installation process completed."
