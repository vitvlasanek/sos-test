2.1
Prvn� s�tova karta je automaticky, v konfigu musi byt DHCP.

2.2
Zjistim rozhrani rrr (posledni v seznamu) - ip link show
Zapnu rozhrani - dhclient rrr
Zjistim IP (aaa.bbb.ccc) - ip address

Nastav�me v souboru - mcedit /etc/network/interfaces 

auto enp0s8 OR allow-hotplug enp0s8			#sitovka se zapne po restartu
iface enp0s8 inet static					#staticka adresa
address 192.168.56.10 				#XXX = t�eba 20
netmask 255.255.255.0
gateway aaa.bbb.ccc.1  ----------tohle tam asi byt nemusi/nema

ip a  ====== rozhrani
ip r  ====== defaultni route