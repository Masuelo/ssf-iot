#include <WaspWIFI_PRO_V3.h>

// Seleccionar el socket (SELECCIONAR EL SOCKET DEL USUARIO)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

// Configuración del AP WiFi (CAMBIAR A LA CONFIGURACIÓN DEL AP DEL USUARIO)
///////////////////////////////////////
char SSID[] = "SSID-Name";
char PASSW[] = "passwd";
///////////////////////////////////////

// Definir variables
uint8_t error;
uint8_t status;
unsigned long previous;

void setup()
{
  USB.println(F("Inicio del programa"));

  //////////////////////////////////////////////////
  // 1. Encender el módulo WiFi
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.ON(socket);

  if (error == 0)
  {
    USB.println(F("1. WiFi encendido"));
  }
  else
  {
    USB.println(F("1. WiFi no se inicializó correctamente"));
  }

  //////////////////////////////////////////////////
  // 2. Restablecer a los valores predeterminados
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.resetValues();

  if (error == 0)
  {
    USB.println(F("2. WiFi restablecido a valores predeterminados"));
  }
  else
  {
    USB.print(F("2. Error al restablecer WiFi a valores predeterminados: "));
    USB.println(error, DEC);
  }

  //////////////////////////////////////////////////
  // 3. Configurar el modo (Estación o AP)
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.configureMode(WaspWIFI_v3::MODE_STATION);

  if (error == 0)
  {
    USB.println(F("3. WiFi configurado correctamente"));
  }
  else
  {
    USB.print(F("3. Error al configurar WiFi: "));
    USB.println(error, DEC);
  }

  // Obtener el tiempo actual
  previous = millis();

  //////////////////////////////////////////////////
  // 4. Configurar SSID y contraseña y habilitar la conexión automática
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.configureStation(SSID, PASSW, WaspWIFI_v3::AUTOCONNECT_ENABLED);

  if (error == 0)
  {
    USB.println(F("4. SSID de WiFi configurado correctamente"));
  }
  else
  {
    USB.print(F("4. Error al configurar el SSID de WiFi: "));
    USB.println(error, DEC);
  }

  if (error == 0)
  {
    USB.println(F("5. WiFi conectado al AP correctamente"));

    USB.print(F("SSID: "));
    USB.println(WIFI_PRO_V3._essid);
    
    USB.print(F("Canal: "));
    USB.println(WIFI_PRO_V3._channel, DEC);

    USB.print(F("Intensidad de la señal: "));
    USB.print(WIFI_PRO_V3._power, DEC);
    USB.println(" dB");

    USB.print(F("Dirección IP: "));
    USB.println(WIFI_PRO_V3._ip);

    USB.print(F("Dirección de GW: "));
    USB.println(WIFI_PRO_V3._gw);

    USB.print(F("Máscara de red: "));
    USB.println(WIFI_PRO_V3._netmask);

    WIFI_PRO_V3.getMAC();

    USB.print(F("Dirección MAC: "));
    USB.println(WIFI_PRO_V3._mac);
  }
  else
  {
    USB.print(F("5. Error al conectar WiFi: "));
    USB.println(error, DEC);

    USB.print(F("Estado de desconexión: "));
    USB.println(WIFI_PRO_V3._status, DEC);

    USB.print(F("Razón de desconexión: "));
    USB.println(WIFI_PRO_V3._reason, DEC);

    /*
      enum ConnectionFailureReason{
        REASON_INTERNAL_FAILURE = 1,
        REASON_AUTH_NO_LONGER_VALID = 2,
        REASON_DEAUTH_STATION_LEAVING = 3,
        REASON_DISASSOCIATED_INACTIVITY = 4,
        REASON_DISASSOCIATED_AP_HANDLE_ERROR = 5,
        REASON_PACKET_RECEIVED_FROM_NONAUTH_STATION = 6,
        REASON_PACKET_RECEIVED_FROM_NONASSOC_STATION = 7,
        REASON_DISASSOCIATED_STATION_LEAVING = 8,
        REASON_STATION_REQUEST_REASSOC = 9,
        REASON_DISASSOCIATED_PWR_CAPABILITY_UNACCEPTABLE = 10,
        REASON_DISASSOCIATED_SUPPORTED_CHANNEL_UNACCEPTABLE = 11,
        REASON_INVALID_ELEMENT = 13,
        REASON_MIC_FAILURE = 14,
        REASON_FOUR_WAY_HANDSHAKE_TIMEOUT = 15,
        REASON_GROUP_KEY_HANDSHAKE_TIMEOUT = 16,
        REASON_ELEMENT_IN_FOUR_WAY_HANDSHAKE_DIFFERENT = 17,
        REASON_INVALID_GROUP_CIPHER = 18,
        REASON_INVALID_PAIRWISE_CIPHER = 19,
        REASON_AKMP = 20,
        REASON_UNSUPPORTED_RSNE_CAPABILITIES = 21,
        REASON_INVALID_RSNE_CAPABILITIES = 22,
        REASON_IEEE_AUTH_FAILED = 23,
        REASON_CIPHER_SUITE_REJECTED = 24,
        REASON_STATION_LOST_BEACONS_CONTINUOUSLY = 200,
        REASON_STATION_FAILED_TO_SCAN_TARGET_AP = 201,
        REASON_STATION_AUTH_FAILED_NOT_TIMEOUT = 202,
        REASON_STATION_AUTH_FAILED_NOT_TIMEOUT_NOT_MANY_STATIONS = 203,
        REASON_HANDHASKE_FAILED = 204,
      };
    */
  }
}

void loop()
{
  // Verificar si el módulo está conectado
  if (WIFI_PRO_V3.isConnected() == true)
  {
    USB.print(F("WiFi está conectado correctamente"));
    USB.print(F(" Tiempo(ms):"));
    USB.println(millis() - previous);

    USB.println(F("\n*** El programa se detiene ***"));
    while (1)
    {}
  }
  else
  {
    USB.print(F("Error al conectar WiFi"));
    USB.print(F(" Tiempo(ms):"));
    USB.println(millis() - previous);
  }

  delay(10000);
}