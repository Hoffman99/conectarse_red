#!/usr/bin/env bash

conectar_wireless() {
    while true; do
        iw dev "$dev" scan > /tmp/scan.txt
        grep -i "ssid:" /tmp/scan.txt | cut -d':' -f2 | tr -d ' ' > /tmp/redes.txt
        echo "Redes disponibles:"
        cat -n /tmp/redes.txt
        read -rp "Seleccione numero de red o 'r' para re-escanear: " eleccion
        if test "$eleccion" = "r"; then
            continue
        fi
        red_Seleccionada=$(awk "NR==$eleccion" /tmp/redes.txt)
        if test "$red_Seleccionada"; then
            break
        fi
        echo "Opción inválida" >&2
    done

    if grep "RSN" /tmp/scan.txt > /dev/null 2>&1; then
        read -rsp "Ingresa la contraseña: " red_passwd
        echo ""
    else
        red_passwd=""
    fi

    conf="/etc/wpa_supplicant/wpa_supplicant-$dev.conf"

    if test "$red_passwd"; then
        cat > "$conf" << EOF
network={
    ssid="$red_Seleccionada"
    psk="$red_passwd"
}
EOF
    else
        cat > "$conf" << EOF
network={
    ssid="$red_Seleccionada"
    key_mgmt=NONE
}
EOF
    fi
    chmod 600 "$conf"
    
    intentos=0
    while true; do
        pkill wpa_supplicant 2>/dev/null
        sleep 1
        wpa_supplicant -B -D nl80211 -c "$conf" -i "$dev"
        sleep 8

        if iw dev "$dev" link | grep -q "Connected"; then
            echo "Conectado exitosamente!"
            break
        fi

        echo "No se pudo conectar" >&2
        if test "$red_passwd"; then
            read -rsp "Ingresa la contraseña nuevamente: " red_passwd
            echo ""
            cat > "$conf" << EOF
network={
    ssid="$red_Seleccionada"
    psk="$red_passwd"
}
EOF
        fi
        # matar wpa_supplicant para reintentar
        pkill wpa_supplicant
        sleep 1
        ((intentos++))
        if test "$intentos" -eq 3; then
            echo "Se han superado el numero de intentos" >&2
            exit 1
        fi
    done
    systemctl enable wpa_supplicant@"$dev"
    systemctl start wpa_supplicant@"$dev"
    systemctl enable dhcpcd@"$dev"
    dhcpcd "$dev"

    rm /tmp/scan.txt
    rm /tmp/redes.txt
}

validar_ip() {
    local -n variable="$1"
    local mensaje="$2"
    while true; do
        read -rp "$mensaje" ip_input
        if [[ "$ip_input" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            variable="$ip_input"
            break
        fi
        echo "IP inválida, intenta de nuevo" >&2
    done
}

conectar_cableada() {
    local direccion_ip=""
    local gateway=""
    local dns=""
    local mascara=""
    local tipo=""
    while true; do
        read -rp "Configuracion estatica o dinamica (static/dhcp): " tipo
        if test "$tipo" = "static" || test "$tipo" = "dhcp"; then
            break
        fi
        echo "Opción inválida, escribe static o dhcp" >&2
    done
    if test "$tipo" = "dhcp"; then
        systemctl enable networking
        dhcpcd "$dev"
        cat >> /etc/network/interfaces << EOF
auto $dev
iface $dev inet dhcp
EOF
    else
        validar_ip direccion_ip "IP (192.168.1.100): "
        while true; do
            read -rp "Mascara (24): " mascara
            if [[ "$mascara" =~ ^[0-9]+$ ]] && test "$mascara" -le 32; then
                break
            fi
            echo "Mascara inválida, debe ser un numero entre 0 y 32" >&2
        done
        validar_ip gateway "Gateway (192.168.1.1): "
        validar_ip dns "DNS (8.8.8.8): "
        ip addr add "$direccion_ip/$mascara" dev "$dev"
        ip route add default via "$gateway"
        echo "nameserver $dns" > /etc/resolv.conf
        if ping -c 1 "$gateway" > /dev/null 2>&1; then
            echo "Conexión exitosa!"
            systemctl enable networking
            cat >> /etc/network/interfaces << EOF
auto $dev
iface $dev inet static
    address $direccion_ip
    netmask $mascara
    gateway $gateway
    dns-nameservers $dns
EOF
        else
            echo "No se pudo conectar, verifica los datos" >&2
            exit 1
        fi
    fi
}

ayuda() {
    echo "$(basename "$0") dir"
    echo "El scrip te conecta a internet de forma interactiva"
    echo "mostrandote Interfaces para subiras o bajarlas"
    echo "dependiendo de cual utilices te permite conectarte por"
    echo "Wireless / Ethernet"
    echo "Para utilizar el scrip es necesario ejecutarlo como \"Sudo\""
}

#ayuda
if test "$1" = "-h" || test "$1" = "--help"; then
    ayuda
    exit 0
fi

#Identificar interfaces
echo "Interfaces disponibles"
ip -o link show | awk '{print NR". " $2, $9}' | tr -d ':'

#Selección de interfaz
while true; do
    read -rp "Seleccione el numero de interfaz: " eleccion
    dev=$(ip -o link show | awk "NR==$eleccion {print \$2}" | tr -d ':')
    if test "$dev"; then
        break
    fi
    echo "Opción inválida, intenta de nuevo" >&2
done

#Subir o bajar interfaz
while true; do
    read -rp "Subir o Bajar interfaz (up/down): " estado
    if test "$estado" = "up"; then
        if ! ip link set dev "$dev" up; then
            echo "Hubo un fallo al encender la interfaz, corrobora permisos" >&2
            exit 1
        fi
        break
    elif test "$estado" = "down"; then
        if ! ip link set dev "$dev" down; then
            echo "Hubo un fallo al bajar la interfaz, corrobora permisos" >&2
            exit 1
        fi
        exit 0
    fi
    echo "Opción inválida, escribir \"up\" o \"down\"" >&2
done

if iw dev "$dev" info > /dev/null 2>&1; then
    conectar_wireless
else
    conectar_cableada
fi