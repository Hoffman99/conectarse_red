#!/usr/bin/env bash

trash="$HOME/.trash"
meta="$trash/.metadata"

ayuda() {
    echo "Uso: $(basename $0) archivo"
    echo "Recupera el archivo desde ~/.trash a su ruta original."
    echo "Parámetros:"
    echo "  archivo: es el archivo a recuperar"
}

reportar_error() {
    local mensaje="$1"
    local fun_ayuda="$2"
    echo "$mensaje" >&2
    "$fun_ayuda"
    exit 1
}

archivo="$1"
test -z "$archivo" && reportar_error "Debes pasar el nombre original" ayuda

# Buscar el archivo más reciente en la papelera
archivo_recuperar=$(ls -t "$trash/$archivo"* 2>/dev/null | head -n 1)

test -z "$archivo_recuperar" && reportar_error "No se encontró $archivo en la papelera" ayuda

# Buscar la ruta original en metadata
ruta=$(grep "$(basename "$archivo_recuperar")|" "$meta" | tail -n 1 | cut -d'|' -f2)

test -z "$ruta" && reportar_error "No se encontró la ruta original en metadata" ayuda

mv "$archivo_recuperar" "$ruta/$archivo"

exit 0
