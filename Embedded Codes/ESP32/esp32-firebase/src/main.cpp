


#include <Arduino.h>
#if defined(ESP32)
  #include <WiFi.h>
#elif defined(ESP8266)
  #include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>

#include <WiFiManager.h>
//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "Tolga"
#define WIFI_PASSWORD "skylabharika"

  //API KEY = AIzaSyBkTU_Nxw6zlUKAES_fkq4OqwsKCTKuVbE
  // Api id: 1:211940387045:android:f17c46006e635d78a98c0c
  //Project id = picoxiloscope.firebaseio.com
// Insert Firebase project API Key
#define API_KEY "AIzaSyBkTU_Nxw6zlUKAES_fkq4OqwsKCTKuVbE"

#define PROJECT_ID "picoxiloscope"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://picoxiloscope-default-rtdb.firebaseio.com/" 

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;

/****************************************
 * SETUP
****************************************/
void setup(){
  WiFiManager wm;

  Serial.begin(115200); // Serial for debugging purposes
  Serial2.begin(9600); // Serial1 for ESP32 RX: 16, TX: 17

  bool res;
    // res = wm.autoConnect(); // auto generated AP name from chipid
    // res = wm.autoConnect("AutoConnectAP"); // anonymous ap
    res = wm.autoConnect("AutoConnectAP","password"); // password protected ap

    if(!res) {
        Serial.println("Failed to connect");
        // ESP.restart();
    } 
    else {
        //if you get here you have connected to the WiFi    
        Serial.println("connected...yeey :)");
    }
  /*
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();*/

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
    signupOK = true;
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

struct multimeter{
  float voltage;
  float amper;
  float range;
};

struct multimeter multimeter;
/****************************************
 * LOOP
****************************************/
void loop(){
  // Firebase e sürekli random data gönderiyoruz
     /*
        Seri haberleşmeden gelen veriler su sekilde :

        Voltage = 0.00
        Amper = 0.00

        Buna gore parser kodu asagidaki gibi olacak
   */

    delay(100);

    //TEST KODU
    /*while(1){   
       if (Serial2.available() > 0){
        Serial.println("Serial1 available");
  
        Serial.println(Serial2.readStringUntil('\n'));
    }
    }*/
    //TEST KODU

         /*
        Seri haberleşmeden gelen veriler su sekilde :

        Voltage = 0.00
        Amper = 0.00

        Buna gore parser kodu asagidaki gibi olacak
   */
    if (Serial2.available() > 0){
        Serial.println("Serial1 available");
        String data = Serial2.readStringUntil('\n');
        Serial.println(data);
        int index = data.indexOf("=");
        String voltage = data.substring(index+1, data.indexOf("\n"));
        Serial.println(voltage);
        multimeter.voltage = voltage.toFloat();
        Serial.println(multimeter.voltage);
        Serial.println("Voltage ok");
        data = Serial2.readStringUntil('\n');
        Serial.println(data);
        index = data.indexOf("=");
        String amper = data.substring(index+1, data.indexOf("\n"));
        Serial.println(amper);
        multimeter.amper = amper.toFloat();
        Serial.println(multimeter.amper);
        Serial.println("Amper ok");

        data = Serial2.readStringUntil('\n');
        Serial.println(data);
        index = data.indexOf("=");
        String range = data.substring(index+1, data.indexOf("\n"));
        Serial.println(range);
        multimeter.range = range.toFloat();
        Serial.println(multimeter.range);
        Serial.println("Range ok");
        
    
        
        
  if (Firebase.ready() && signupOK ){ // Sürekli random data gönderiyoruz
    // Write an Float number on the database path test/float



    if (Firebase.RTDB.setFloat(&fbdo, "voltage", multimeter.voltage)){
      Serial.println("PASSED");
      Serial.print("PATH: ");
      Serial.println(fbdo.dataPath());
      Serial.print("TYPE: ");
      Serial.println(fbdo.dataType());
      Serial.println(multimeter.voltage);
     
    }
    else {
      Serial.println("FAILED");
      Serial.print("REASON: ");
      Serial.println(fbdo.errorReason());
    }
    if (Firebase.RTDB.setFloat(&fbdo, "ampere", multimeter.amper)){
      Serial.println("PASSED");
      Serial.print("PATH: ");
      Serial.println(fbdo.dataPath());
      Serial.print("TYPE: ");
      Serial.println(fbdo.dataType());
      Serial.println(multimeter.amper);
     
    }
  }
  else{
    Serial.println("Bağlantı yok");
  }
    }
}

