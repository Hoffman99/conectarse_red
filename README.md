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
- Probado en Pop!_OS 24.04 y Ubuntu 24.04# papelera - borrar.sh y recuperar.sh

Scripts interactivos en español para eliminar y recuperar archivos de forma segura en Linux.

## Características

- 100% interactivos y fáciles de usar
- Completamente en español
- Los archivos eliminados se guardan en `~/.trash` y se pueden recuperar
- Recupera archivos a su ruta original automáticamente
- Compatible con cualquier dispositivo Linux
- Manejo de errores claro y descriptivo

## Scripts

### borrar.sh
Mueve el archivo a la papelera `~/.trash` en lugar de eliminarlo permanentemente.
```bash
bash borrar.sh <archivo>
```

### recuperar.sh
Recupera el archivo desde `~/.trash` a su ubicación original.
```bash
bash recuperar.sh <archivo>
```

## Ejemplo
```bash
# eliminar
bash borrar.sh documento.pdf

# recuperar
bash recuperar.sh documento.pdf
```

## Notas

- Los archivos se guardan en `~/.trash`
- Se guarda la ruta original en `~/.trash/.metadata`
- En caso de duplicados se recupera el más reciente
