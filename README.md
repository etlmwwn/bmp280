# Raspberry Pi & BMP280 Environment Monitoring Setup

This repository contains a script to set up an environment monitoring system on a Raspberry Pi running Debian Bullseye. The setup includes configuring I2C, installing necessary packages, setting up InfluxDB and Grafana, and configuring a systemd service to monitor and log environmental data.

## Platform

- Raspberry Pi 3
- Debian Bullseye

## Features

- Configures I2C interface
- Installs and configures InfluxDB
- Installs and configures Grafana
- Sets up a Python script to read from a BMP280 sensor and log data to InfluxDB
- Provides a Grafana dashboard for visualizing the data

## Installation Steps

1. **Update and Upgrade System**
   - Updates the package list and upgrades installed packages.

2. **Configure Raspberry Pi I2C**
   - Enables the I2C interface using `raspi-config`.

3. **Install i2c-tools**
   - Installs `i2c-tools` and detects connected I2C devices.

4. **Install Python3 pip and adafruit-circuitpython-bmp280**
   - Installs Python3 pip and the Adafruit BMP280 library.

5. **Install and Configure InfluxDB**
   - Adds the InfluxDB repository, installs InfluxDB, configures it to listen on all network interfaces, and starts the service.

6. **Create InfluxDB Database**
   - Creates a database named `environment`.

7. **Install Python InfluxDB Client**
   - Installs the InfluxDB client for Python.

8. **Create and Configure Systemd Service for Environment Monitoring**
   - Creates a systemd service to run the environment monitoring script.

9. **Download Environment Monitoring Script**
   - Downloads the Python script for monitoring the environment.

10. **Enable and Start Environment Monitoring Service**
    - Enables and starts the systemd service for environment monitoring.

11. **Install and Configure Grafana**
    - Adds the Grafana repository, installs Grafana, and starts the Grafana server.

12. **Wait for Grafana to be Fully Up**
    - Waits for the Grafana web API to be fully up and running.

13. **Import Grafana Dashboard**
    - Imports a default dashboard from a JSON file.

## Installation Instructions

1. **Clone the Repository**
    ```bash
    git clone https://github.com/yourusername/yourrepository.git
    cd yourrepository
    ```

2. **Run the Installation Script**
    ```bash
    bash install.sh
    ```

3. **Access Grafana**
    - Open your web browser and go to `http://<your-raspberry-pi-ip>:3000`.
    - The default login credentials are `admin`/`admin`.

## File Descriptions

- `install.sh`: The main installation script.
- `README.md`: This readme file.

## Grafana Dashboard

- A default Grafana dashboard is imported during installation. You can customize it or import a new one as needed.

## Troubleshooting

- Ensure your Raspberry Pi is connected to the internet.
- Verify that the I2C device is properly connected.
- Check the status of the systemd services if there are issues (`influxdb.service`, `grafana-server.service`, `environment.service`).

## License

This project is licensed under the MIT License.
