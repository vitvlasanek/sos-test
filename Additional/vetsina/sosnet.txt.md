iptables -L       listne politiky
nainštaluj iptables-persistent

ip addr add 192.168.61.100/24 dev ens192

iptables-save > /home/tomas/tabulky   ..... uloží aktuálne pravidlá
iptables -F
iptables-restore (cesta)
cat /etc/iptables/rules.v4  .......... pravidlá pri spustení
---------perm uloženie pravidediel
iptables-save > /etc/iptables/rules.v4
----------------
vim.tiny /etc/network/interfaces   ... config po štarte