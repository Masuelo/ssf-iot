#include <WaspSensorEvent_v30.h>

// Creamos las variables que vamos a utilizar
float temp;
float humd;
float pres;
float value;

void setup() 
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program")); 
}

void loop() 
{
  
  ///////////////////////////////////////
  // 1. Read BME280 Values
  ///////////////////////////////////////
  // Turn on the sensor board
  Events.ON();
  //Temperature
  temp = Events.getTemperature();
  //Humidity
  humd = Events.getHumidity();
  //Pressure
  pres = Events.getPressure();

  ///////////////////////////////////////
  // 2. Print BME280 Values
  ///////////////////////////////////////
  USB.println("-----------------------------");
  USB.print("Temperature: ");
  USB.printFloat(temp, 2);
  USB.println(F(" Celsius"));
  USB.print("Humidity: ");
  USB.printFloat(humd, 1); 
  USB.println(F(" %")); 
  USB.print("Pressure: ");
  USB.printFloat(pres, 2); 
  USB.println(F(" Pa")); 
  USB.println("-----------------------------");  
  
  ///////////////////////////////////////
  // 3. Go to deep sleep mode
  ///////////////////////////////////////
  USB.println(F("enter deep sleep"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  // Si la Temperatura es superior a los 25 grados mandamos la señal para que se encienda el A/C
  USB.ON();
  USB.println(F("wake up\n"));
  if (temp >=25){
    USB.println(F("Activando aire acondicionado")
  }
}



