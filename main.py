import time
from datetime import datetime
from influxdb import InfluxDBClient
import board
import busio
import adafruit_bmp280

# InfluxDB settings
INFLUXDB_HOST = '192.168.137.143'
INFLUXDB_PORT = 8086
INFLUXDB_DB = 'environment'

# Measurement interval (seconds)
MEASUREMENT_INTERVAL = 1

# Initialize I2C bus and BMP280 sensor with the correct address
i2c = busio.I2C(board.SCL, board.SDA)
bmp280 = adafruit_bmp280.Adafruit_BMP280_I2C(i2c, address=0x76)

# Initialize InfluxDB client without authentication
client = InfluxDBClient(
    host=INFLUXDB_HOST,
    port=INFLUXDB_PORT,
    database=INFLUXDB_DB
)

while True:
    # Get sensor data
    temperature = bmp280.temperature
    pressure = bmp280.pressure
    altitude = bmp280.altitude

    # Print sensor data
    print(f"Temperature: {temperature:.2f} C, Pressure: {pressure:.2f} hPa, Altitude: {altitude:.2f} m")

    # Create a data point
    json_body = [
        {
            "measurement": "environment",
            "tags": {
                "location": "your_location"
            },
            "time": datetime.utcnow().isoformat(),
            "fields": {
                "temperature": temperature,
                "pressure": pressure,
                "altitude": altitude
            }
        }
    ]

    # Write data to InfluxDB
    client.write_points(json_body)

    # Wait for the next measurement
    time.sleep(MEASUREMENT_INTERVAL)
