/*  Code for using NEO M8N GPS module with Nano using UART interface.
    Nick Anderson
    26 November 2018*/

// Library to read create Software UART interface
#include <SoftwareSerial.h>

// constants for UART interface
#define RXPin 4 // connect to TX of module
#define TXPin 3 // connect to RX of module
#define GPSBaud 9600 // Given on data sheet
#define DEBUG 0
// Create UART Software instance
SoftwareSerial ss(RXPin, TXPin);
char data_byte;
char NMEA_GNGGA_sentence[20];
char NMEA_code[5];
bool read = 0;

void setup() {
  // put your setup code here, to run once:
  pinMode(RXPin, INPUT);
  pinMode(TXPin, OUTPUT);
  Serial.begin(9600);
  ss.begin(GPSBaud);
}

void loop() {
  while (ss.available() > 0){
    if (DEBUG){
      data_byte = ss.read();
      Serial.write(data_byte);
      delay(500);
      Serial.println();
      //Serial.println(ss.read());
    }
    else {
      data_byte = ss.read();
      Serial.write(data_byte);
      delay(500);
      if (data_byte == '$'){
        Serial.println("NMEA Sentence");
        NMEA_code[0] = ss.read();
        NMEA_code[1] = ss.read();
        NMEA_code[2] = ss.read();
        NMEA_code[3] = ss.read();
        NMEA_code[4] = ss.read();      
        if (NMEA_code[0]=='G' and NMEA_code[1]=='N' and NMEA_code[2]=='G' and NMEA_code[3]=='G' and NMEA_code[4]=='A'){
          Serial.println("FOUND");
        }
      }
      else {
        Serial.write(data_byte);
      }
    }
  }
}

char read_NMEA_code() {

  char NMEA_code[5];
  NMEA_code[0] = ss.read();
  NMEA_code[1] = ss.read();
  NMEA_code[2] = ss.read();
  NMEA_code[3] = ss.read();
  NMEA_code[4] = ss.read();
  return NMEA_code;
}
