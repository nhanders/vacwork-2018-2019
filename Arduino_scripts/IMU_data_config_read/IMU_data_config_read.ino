//#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>
#include <EEPROM.h>

/* This driver uses the Adafruit unified sensor library (Adafruit_Sensor),
   which provides a common 'type' for sensor data and some helper functions.

   To use this driver you will also need to download the Adafruit_Sensor
   library and include it in your libraries folder.

   You should also assign a unique ID to this sensor for use with
   the Adafruit Sensor API so that you can identify this particular
   sensor in any data logs, etc.  To assign a unique ID, simply
   provide an appropriate value in the constructor below (12345
   is used by default in this example).

   Connections
   ===========
   Connect SCL to analog 5
   Connect SDA to analog 4
   Connect VDD to 3-5V DC
   Connect GROUND to common ground

   History
   =======
   2015/MAR/03  - First release (KTOWN)
   2015/AUG/27  - Added calibration and system status helpers
   2015/NOV/13  - Added calibration save and restore
   */

/* Set the delay between fresh samples */
#define BNO055_SAMPLERATE_DELAY_MS (20)
#define BAUDRATE (115200)
Adafruit_BNO055 bno = Adafruit_BNO055(55);
unsigned int time_start;
unsigned int time_1 = 0;
unsigned int counter = 1;

void print_ACCELEROMETER(bool val){
    if (val){
      imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_ACCELEROMETER);
      Serial.print(euler.x());
      Serial.print("\t");
      Serial.print(euler.y());
      Serial.print("\t");
      Serial.print(euler.z());
      Serial.print("\t");
    }
}

void print_MAGNETOMETER(bool val){
    if (val){
      imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_MAGNETOMETER);
      Serial.print(euler.x());
      Serial.print("\t");
      Serial.print(euler.y());
      Serial.print("\t");
      Serial.print(euler.z());
      Serial.print("\t");
    }
}

void print_GYROSCOPE(bool val){
    if (val){
      imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_GYROSCOPE);
      Serial.print(euler.x());
      Serial.print("\t");
      Serial.print(euler.y());
      Serial.print("\t");
      Serial.print(euler.z());
      Serial.print("\t");
    }
}

void print_EULER(bool val){
    if (val){
      imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_EULER);
      Serial.print(euler.x());
      Serial.print("\t");
      Serial.print(euler.y());
      Serial.print("\t");
      Serial.print(euler.z());
      Serial.print("\t");
    }
}

void print_LINEARACCEL(bool val){
    if (val){
      imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_LINEARACCEL);
      Serial.print(euler.x());
      Serial.print("\t");
      Serial.print(euler.y());
      Serial.print("\t");
      Serial.print(euler.z());
      Serial.print("\t");
    }
}

void print_GRAVITY(bool val){
    if (val){
      imu::Vector<3> euler = bno.getVector(Adafruit_BNO055::VECTOR_GRAVITY);
      Serial.print(euler.x());
      Serial.print("\t");
      Serial.print(euler.y());
      Serial.print("\t");
      Serial.print(euler.z());
      Serial.print("\t");
    }
}

void print_QUAT(bool val){
  imu::Quaternion quat = bno.getQuat();
  if (val){
    /* Display the quat data */
    Serial.print(quat.w(), 4);
    Serial.print("\t");
    Serial.print(quat.y(), 4);
    Serial.print("\t");
    Serial.print(quat.x(), 4);
    Serial.print("\t");
    Serial.print(quat.z(), 4);
    Serial.print("\t");
  }
  else{
    Serial.print("0\t0\t0\t0\t");
  }
}

void print_EULER2(bool val){
  if (val){
    /* Convert quaternion to Euler, because BNO055 Euler data is broken */
    imu::Quaternion q = bno.getQuat();
    q.normalize();
    
    /* Quat to Eul from https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles */
    double roll; double pitch; double yaw; 
    double sinr_cosp = +2.0 * (q.w() * q.x() + q.y() * q.z());
    double cosr_cosp = +1.0 - 2.0 * (q.x() * q.x() + q.y() * q.y());
    roll = atan2(sinr_cosp, cosr_cosp);
  
    // pitch (y-axis rotation)
    double sinp = +2.0 * (q.w() * q.y() - q.z() * q.x());
    if (fabs(sinp) >= 1)
      pitch = copysign(M_PI / 2, sinp); // use 90 degrees if out of range
    else
      pitch = asin(sinp);
  
    // yaw (z-axis rotation)
    double siny_cosp = +2.0 * (q.w() * q.z() + q.x() * q.y());
    double cosy_cosp = +1.0 - 2.0 * (q.y() * q.y() + q.z() * q.z());  
    yaw = atan2(siny_cosp, cosy_cosp);
  
    Serial.print(180/M_PI * roll);  // x-axis rotation, cw positive (from -ve x)   O    ^ X
    Serial.print("\t");             //                                                  |
    Serial.print(180/M_PI * pitch); // y-axis rotation, cw positive (from -ve y)      Z o ---> Y 
    Serial.print("\t");
    Serial.print(180/M_PI * yaw);   // z-axis rotation, cw positive (from -ve z)
    Serial.print("\t");
  }
}

/**************************************************************************/
/*
    Arduino setup function (automatically called at startup)
    */
/**************************************************************************/
void setup(void)
{
    Serial.begin(BAUDRATE);

    /* Initialise the sensor */
    if (!bno.begin())
    {
        /* There was a problem detecting the BNO055 ... check your connections */
        Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
        while (1);
    }

    int eeAddress = 0;
    long bnoID;
    bool foundCalib = false;

    EEPROM.get(eeAddress, bnoID);

    adafruit_bno055_offsets_t calibrationData;
    sensor_t sensor;

    /*
    *  Look for the sensor's unique ID at the beginning oF EEPROM.
    *  This isn't foolproof, but it's better than nothing.
    */
    bno.getSensor(&sensor);
    if (bnoID != sensor.sensor_id)
    {
        //Serial.println("\nNo Calibration Data for this sensor exists in EEPROM");
        delay(500);
    }
    else
    {
        //Serial.println("\nFound Calibration for this sensor in EEPROM.");
        eeAddress += sizeof(long);
        EEPROM.get(eeAddress, calibrationData);

        //displaySensorOffsets(calibrationData);

        //Serial.println("\n\nRestoring Calibration data to the BNO055...");
        bno.setSensorOffsets(calibrationData);

        //Serial.println("\n\nCalibration data loaded into BNO055");
        foundCalib = true;
    }

    delay(1000);

    /* Display some basic information on this sensor */
    //displaySensorDetails();

    /* Optional: Display current status */
    //displaySensorStatus();

   //Crystal must be configured AFTER loading calibration data into BNO055.
    bno.setExtCrystalUse(true);

    sensors_event_t event;
    bno.getEvent(&event);
    if (foundCalib){
        Serial.println("Move sensor slightly to calibrate magnetometers");
        while (!bno.isFullyCalibrated())
        {
            bno.getEvent(&event);
            delay(10);
        }
    }
    else
    {
        Serial.println("Please Calibrate Sensor: ");
        while (!bno.isFullyCalibrated())
        {
            bno.getEvent(&event);

            Serial.print("X: ");
            Serial.print(event.orientation.x, 4);
            Serial.print("\tY: ");
            Serial.print(event.orientation.y, 4);
            Serial.print("\tZ: ");
            Serial.print(event.orientation.z, 4);

            /* Optional: Display calibration status */
            //displayCalStatus();

            /* New line for the next sample */
            Serial.println("");

            /* Wait the specified delay before requesting new data */
            delay(BNO055_SAMPLERATE_DELAY_MS);
        }
    }

    //Serial.println("\nFully calibrated!");
    //Serial.println("--------------------------------");
    //Serial.println("Calibration Results: ");
    adafruit_bno055_offsets_t newCalib;
    bno.getSensorOffsets(newCalib);
    //displaySensorOffsets(newCalib);

    //Serial.println("\n\nStoring calibration data to EEPROM...");

    eeAddress = 0;
    bno.getSensor(&sensor);
    bnoID = sensor.sensor_id;

    EEPROM.put(eeAddress, bnoID);

    eeAddress += sizeof(long);
    EEPROM.put(eeAddress, newCalib);
    
    Serial.println("Press enter to start recording.");
    while (Serial.available()==0);
    time_start = millis();
    time_1 = millis();
}

void loop() {
    unsigned int time_0 = millis();
    unsigned int time_stamp = time_0-time_start;
    Serial.print(time_stamp/1000.0, 3);
    Serial.print("\t");

    // Possible vector values can be:
    //---------------------------------
    // - VECTOR_ACCELEROMETER - m/s^2
    // - VECTOR_MAGNETOMETER  - uT
    // - VECTOR_GYROSCOPE     - rad/s
    // - VECTOR_EULER         - degrees
    // - VECTOR_LINEARACCEL   - m/s^2
    // - VECTOR_GRAVITY       - m/s^2
    //---------------------------------
    // Set to true to print IMU reading.
    print_LINEARACCEL(true);
    //print_GYROSCOPE(true);
    //print_ACCELEROMETER(true);
    //print_MAGNETOMETER(true);
    //print_EULER(true);
    print_GRAVITY(true);
    //print_QUAT(false);
    //print_EULER(true);
    print_EULER2(true);
    
    Serial.println();
    if (counter==500) while(1);

    unsigned int delay_time = millis()-time_0;
    /* Wait the specified delay before requesting new data */
    delay(abs(BNO055_SAMPLERATE_DELAY_MS-delay_time));
    time_1 = time_0;
    counter++;
}
