#include <WaspSensorEvent_v30.h>

uint8_t value = 0;
float temp;
uint32_t luxes = 0;
pirSensorClass pir(SOCKET_1);

void setup() 
{
  USB.ON();
  USB.println(F("Start program"));
  
  Events.ON();
    
  value = pir.readPirSensor();
  while (value == 1)
  {
    USB.println(F("Se esta estabilizando"));
    delay(1000);
    value = pir.readPirSensor();    
  }
  
  Events.attachInt();
}


void loop() 
{
  value = pir.readPirSensor();
  
  if (value == 1) 
  {
    USB.println(F("Presencia detectada"));
    temp = Events.getTemperature();
    luxes = Events.getLuxes(INDOOR);
    USB.print("Temperatura actual: ");
    USB.printFloat(temp, 2);
    USB.print("Luminosidad. ");
    USB.print(luxes, 1);
    
  } 
  else 
  {
    USB.println(F("Presencia no detectada"));
  }

  USB.println(F("enter deep sleep"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, SENSOR_ON);
  USB.ON();
  USB.println(F("wake up\n"));

  if (intFlag & RTC_INT)
  {
    USB.println(F("-----------------------------"));
    USB.println(F("RTC INT captured"));
    USB.println(F("-----------------------------"));

    intFlag &= ~(RTC_INT);
  }
  
  if (intFlag & SENS_INT)
  {
    Events.detachInt();

    Events.loadInt();

    if (pir.getInt())
    {
      USB.println(F("-----------------------------"));
      USB.println(F("Interruption from PIR"));
      USB.println(F("-----------------------------"));
    }    

    value = pir.readPirSensor();
    
    while (value == 1)
    {
      USB.println(F("...wait for PIR stabilization"));
      delay(1000);
      value = pir.readPirSensor();
    }

    intFlag &= ~(SENS_INT);

    Events.attachInt();
  }
  
}

