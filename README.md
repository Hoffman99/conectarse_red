# papelera - borrar.sh y recuperar.sh

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
