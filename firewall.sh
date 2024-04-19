#!/bin/bash

# Nastavte výchozí politiku DROP pro INPUT a OUTPUT na všech rozhraních
iptables -P INPUT DROP
iptables -P OUTPUT DROP

# Povolte SSH (port 22 TCP) a NFS (port 2049 TCP, UDP) pouze z rozhraní "Host-only network"
iptables -A INPUT -i "Host-only network" -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i "Host-only network" -p udp --dport 2049 -j ACCEPT
iptables -A INPUT -i "Host-only network" -p tcp --dport 2049 -j ACCEPT
iptables -A OUTPUT -o "Host-only network" -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -o "Host-only network" -p udp --dport 2049 -j ACCEPT
iptables -A OUTPUT -o "Host-only network" -p tcp --dport 2049 -j ACCEPT

# Povolte HTTP a HTTPS ze všech rozhraní a IP adres
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT

# Povolte ICMP (INPUT, OUTPUT) na všech rozhraních
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

# Nakonfigurujte překlad síťových adres (source NAT) na rozhraní připojeném k síti NAT
iptables -t nat -A POSTROUTING -o "enp0s3" -j MASQUERADE

# Uložit pravidla firewallu
iptables-save > /etc/iptables.rules

# Demonstrace funkčnosti firewallu
iptables -L -v

# Vytvořit jednotku systemd pro spuštění skriptu při startu systému
cat << EOF > /etc/systemd/system/firewall.service
[Unit]
Description=Firewall Script
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash /root/firewall.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl enable firewall.service
