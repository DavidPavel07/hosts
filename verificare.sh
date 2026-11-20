
#!/bin/bash

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

    if ! nslookup "$name" 8.8.8.8 | sed -n '/Name:/,$p' | grep -q "Address: $ip"; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done

