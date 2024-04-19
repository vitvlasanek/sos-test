# Firewall

## Zadání

Vytvořte skript, který nastaví firewall systému tak, aby defaultní politika pro OUTPUT byla DROP.

Povolte do systému přístup (INPUT, OUTPUT) pro službu SSH pouze z definovaných IP adres.
Povolte přístup (INPUT, OUTPUT) na http a https z libovolné IP adresy.
Povolte provoz ICMP na všech rozhraních.
Nastavte překlad zdrojových síťových adres na rozhraní enp0s3.
Funkčnost firewallu demonstrujte.

Vytvořte jednotku, které zavede pravidla firewalu, vždy po startu systému.

# Postup

1. vytvoření skriptu

   - viz. `firewall.sh`

2. vytvoření služby `> /etc/systemd/system/iptables.service`

   ```sh
   [Unit]
   Description=Load iptables rules at boot

   [Service]
   Type=oneshot
   ExecStart=/usr/bin/bash /root/firewall.sh
   RemainAfterExit=yes

   [Install]
   WantedBy=multi-user.target
   ```

3. start
   ```
   systemctl enable iptables.service
   systemctl start iptables.service
   ```
