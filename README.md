# conectarse_red.sh

Script interactivo en español para conectarse a redes de internet desde la terminal en Linux.

## Características

- 100% interactivo, el usuario solo debe seguir las instrucciones en pantalla
- Completamente en español
- Compatible con interfaces inalámbricas y cableadas
- Detección automática del tipo de interfaz
- Configuración estática o dinámica (DHCP)
- Guarda la configuración de forma permanente
- Compatible con cualquier dispositivo Linux que tenga las dependencias instaladas

## Dependencias

- `iw`
- `wpa_supplicant`
- `dhcpcd`
- `systemctl`

## Uso
```bash
sudo bash conectarse_red.sh
```

Para ver la ayuda:
```bash
bash conectarse_red.sh --help
```

## Flujo del script

1. Muestra las interfaces de red disponibles y su estado
2. El usuario selecciona una interfaz
3. El usuario decide subirla o bajarla
4. Si es inalámbrica muestra las redes disponibles y se conecta
5. Si es cableada pregunta si la configuración es estática o dinámica
6. Guarda la configuración para que sea permanente al reiniciar

## Notas

- Debe ejecutarse con `sudo`
- Probado en Pop!_OS 24.04 y Ubuntu 24.04

