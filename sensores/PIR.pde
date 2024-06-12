#include <WaspSensorEvent_v30.h>

// Declarar la variable para almacenar el valor del sensor
uint8_t value = 0;

// Crear una instancia del sensor PIR en el socket 1
pirSensorClass pir(SOCKET_1);

void setup() 
{
  // Encender el USB y mostrar un mensaje de inicio
  USB.ON();
  USB.println(F("Start program"));
  
  // Encender la tarjeta de sensores
  Events.ON();
  
  // Inicialmente, esperar la estabilización de la señal PIR
  value = pir.readPirSensor();
  while (value == 1)
  {
    USB.println(F("...wait for PIR stabilization"));
    delay(1000);
    value = pir.readPirSensor();    
  }
  
  // Habilitar interrupciones desde la tarjeta de sensores
  Events.attachInt();
}

void loop() 
{
  ///////////////////////////////////////
  // 1. Leer el nivel del sensor
  ///////////////////////////////////////
  // Leer el sensor PIR
  value = pir.readPirSensor();
  
  // Imprimir la información
  if (value == 1) 
  {
    USB.println(F("Ha pasado una persona"));
  } 
  else 
  {
    USB.println(F("No se ha detectado a nadie"));
  }
  
  ///////////////////////////////////////
  // 2. Entrar en modo de sueño profundo
  ///////////////////////////////////////
  USB.println(F("enter deep sleep"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, SENSOR_ON);
  USB.ON();
  USB.println(F("Se ha detectado a una persona"));
  
  ///////////////////////////////////////
  // 3. Verificar las banderas de interrupción
  ///////////////////////////////////////
  
  // 3.1. Verificar interrupción de la alarma del RTC
  if (intFlag & RTC_INT)
  {
    USB.println(F("-----------------------------"));
    USB.println(F("RTC INT captured"));
    USB.println(F("-----------------------------"));

    // Limpiar la bandera
    intFlag &= ~(RTC_INT);
  }
  
  // 3.2. Verificar interrupción desde la tarjeta de sensores
  if (intFlag & SENS_INT)
  {
    // Deshabilitar interrupciones desde la tarjeta de sensores
    Events.detachInt();
    
    // Cargar la bandera de interrupción
    Events.loadInt();
    
    // En caso de que la interrupción provenga del PIR
    if (pir.getInt())
    {
      USB.println(F("-----------------------------"));
      USB.println(F("Interruption from PIR"));
      USB.println(F("-----------------------------"));
    }    
    
    // El usuario debería implementar algún aviso
    // En este ejemplo, ahora espera la estabilización de la señal
    // para generar una nueva interrupción
    // Leer el nivel del sensor
    value = pir.readPirSensor();
    
    while (value == 1)
    {
      USB.println(F("...wait for PIR stabilization"));
      delay(1000);
      value = pir.readPirSensor();
    }
    
    // Limpiar la bandera de interrupción
    intFlag &= ~(SENS_INT);
    
    // Habilitar interrupciones desde la tarjeta de sensores
    Events.attachInt();
  }
}
