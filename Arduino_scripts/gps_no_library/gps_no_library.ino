#include <SoftwareSerial.h>
SoftwareSerial mySerial(3,2);   //software serial instance for GPS/GSM module
String latlongtab[5];  // for the purpose of example let array be global
#define DEBUG true 
String state, timegps, latitude, longitude;
void setup() {
  
  mySerial.begin(9600);
  Serial.begin(9600);           //open serial port
  delay(50);
  
  /*We can use old sendData function to print our commands*/
  sendData("AT+CGNSPWR=1",1000,DEBUG);       //Initialize GPS device
  delay(50);
  sendData("AT+CGNSSEQ=RMC",1000,DEBUG);
  delay(150);
}
void loop() {
   sendTabData("AT+CGNSINF",1000,DEBUG);    //send demand of gps localization
   if(state != 0){
    /*we just dont want to print empty signs so we wait until 
     * gps module will have connection to satelite.
    
     * when whole table returned:
   for(int i = 0; i < (sizeof(latlongtab)/sizeof(int)); i++){
      Serial.println(latlongtab[i]); // print 
    }*/
    Serial.println("State: "+state+" Time: "+timegps+"  Latitude: "+latitude+" Longitude "+longitude);
   }else{
    Serial.println("GPS initializing");
   }
   
}
void sendTabData(String command, const int timeout, boolean debug){
 
    mySerial.println(command); 
    long int time = millis();
    int i = 0;   
    
    while((time+timeout) > millis()){
      while(mySerial.available()){       
        char c = mySerial.read();
        if(c != ','){ //read characters until you find comma, if found increment
          latlongtab[i]+=c;
          delay(100);
        }else{
          i++;        
        }
        if(i == 5){
          delay(100);
          goto exitL;
        }       
      }    
    }exitL:    
    if(debug){ 
      /*or you just can return whole table,in case if its not global*/ 
      state = latlongtab[1];     //state = recieving data - 1, not recieving - 0
      timegps = latlongtab[2];
      latitude = latlongtab[3];  //latitude
      longitude = latlongtab[4]; //longitude
    }    
}
String sendData(String command, const int timeout, boolean debug){
  
    String response = "";    
    mySerial.println(command); 
    long int time = millis();
    int i = 0;  
     
    while( (time+timeout) > millis()){
      while(mySerial.available()){       
        char c = mySerial.read();
        response+=c;
      }  
    }    
    if(debug){
      Serial.print(response);
    }    
    return response;
}
