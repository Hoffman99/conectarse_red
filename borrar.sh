#!/usr/bin/env bash

ayuda() {
    echo "Uso: $(basename $0) archivo"
    echo "El script mueve el archivo pasado a una carpeta oculta ~/.trash"
    echo "Parámetros:"
    echo "  archivo: es el archivo a eliminar (se podrá recuperar después)"
}

reportar_error() {
    local mensaje="$1"
    local fun_ayuda="$2"
    echo "$mensaje" >&2
    "$fun_ayuda"
    exit 1
}

archivo="$1"
test -z "$archivo" && reportar_error "Debes pasar un archivo" ayuda
! test -f "$archivo" && reportar_error "El archivo '$archivo' no existe o no es regular" ayuda

trash="$HOME/.trash"
meta="$trash/.metadata"
mkdir -p "$trash"

basename_archivo=$(basename "$archivo")
timestamp=$(date +%s)
nuevo_nombre="${basename_archivo}.${timestamp}"

# Mover archivo
mv "$archivo" "$trash/$nuevo_nombre"

# Guardar metadata: nombre nuevo -> ruta original
echo "$nuevo_nombre|$(realpath "$(dirname "$archivo")")" >> "$meta"

exit 0

