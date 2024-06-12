#include <WaspSensorEvent_v30.h>

// Variable para almacenar el valor adquirido
uint32_t luxes = 0;

void setup()
{
  // Encender el USB y mostrar un mensaje de start
  USB.ON();
  USB.println(F("Start program"));  
  
  // Encender la Sensor Board
  Events.ON();  
}
 
void loop()
{
  // Parte 1: Leer Valores
  // Leer el sensor de luxes 
  // Opciones:
  //    - OUTDOOR
  //    - INDOOR
  luxes = Events.getLuxes(INDOOR);  
   
  // Parte 2: USB printing
  // Mostrar valores a través del USB
  USB.print(F("Luxes: "));
  USB.print(luxes);
  USB.println(F(" lux"));

  // Comprobar si el valor de luz está por encima o por debajo de los umbrales
  if(luxes >= 300){
    USB.println(F("El valor de luz está por encima del umbral"));
  }
  if(luxes <= 100){
    USB.println(F("El valor de luz está por debajo del umbral"));
  }

  delay(1000);  
}
