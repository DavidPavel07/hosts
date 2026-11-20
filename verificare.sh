
#!/bin/bash

verifica_ip() {
    if ! nslookup "$1" "$3" | sed -n '/Name:/,$p' | grep -qFx "Address: $2"; then
        echo "Bogus IP for $1 in /etc/hosts!"
    fi
}

dns_server="8.8.8.8"

cat /etc/hosts | while read ip name rest; do
    if [ -z "$ip" ] || [ "${ip:0:1}" = "#" ] || [ "${name:0:4}" = "ip6-" ]; then
        continue
    fi

    if [ "$name" = "localhost" ] && [ "$ip" = "127.0.0.1" ]; then
        continue
    fi

    if [ "$ip" = "127.0.1.1" ]; then
        continue
    fi

    verifica_ip "$name" "$ip" "$dns_server"
done
