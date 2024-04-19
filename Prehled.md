# Setup

Zakomentovat radek v

vi /etc/apt/sources.list

sjet na radek a pak
i - insert mode
dat tam #

pak sjet na prazdny radek
shift + §

:wq quit se savem
q!  quit bez savu


apt install mcedit

# Síť

2.1
První sítova karta je automaticky, v konfigu musi byt DHCP.

2.2
Zjistim rozhrani rrr (posledni v seznamu) - ip link show
Zapnu rozhrani - dhclient rrr
Zjistim IP (aaa.bbb.ccc) - ip address

Nastavíme v souboru - mcedit /etc/network/interfaces 

auto enp0s8 OR allow-hotplug enp0s8			# sitovka se zapne po restartu
iface enp0s8 inet static					# staticka adresa
address 192.168.56.10 				# XXX = třeba 20
netmask 255.255.255.0
gateway aaa.bbb.ccc.1  ----------tohle tam asi byt nemusi/nema

ip a  ====== rozhrani
ip r  ====== defaultni route

## Zakladní postup
Vypnout virtuál
Pridat disky

### Prikazy 
fdisk -l 					# vypis disku
mcedit /etc/fstab
cat /proc/mdstat	
lsblk			

### Balicek na instalaci RAID
apt update			# aktualizace balicku
apt-get install mdadm		# instalace balicku

### Udelat partitiony pro kazdy disk
fdisk /dev/sdX      	# zapnuti nataveni disku
n ENTER					# new
p ENTER					# primary
ENTER, ENTER,.. 		# dalsi nastaveni
t ENTER fd ENTER		# nevim nejake nastaveni
w ENTER					# save nastaveni

### Tvorba RAID
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
            

### Alternativa přímo se sparem
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc --spare-devices=1 /dev/sdd	

# Partition
cfdisk /dev/md0
gpt
new
write

### Propojeni s /home/

mkfs.ext4 /dev/md0p1

mount /dev/md0p1 /mnt/

cp -a /home/* /mnt/

mount /dev/md0p1 /home/


### Co dat do /etc/fstab, aby se raid udelal i po spusteni
/dev/md127p1	/home	ext4	defaults	0	0


NEZAPOMENOUT, ZE SE PO RESTARTU MENI md0 na md127


### pred spustenim nejsou nastaveny quoty na home
apt install quota
mount -o remount,usrquota,grpquota /dev/md127p1
service quota start
quotaon /home

### editovani quoty
quota username
edquota username

edquota -p userprototype newuser; # upraveni quoty podle prototypu

### kde najdu info o uzivatelich
cat /etc/passwd

### je script spustitelny?
ls -l script

### spustit script
./script parametry

### Skript pro uzivatele
chmod +x skriptname.sh		# aby sel VSEMI spustit skript
https://pastebin.com/vBFKxXq8

-----------------------------------

```
#!/bin/bash

if ! [[ $1 =~ ^[0-9]+$ ]]
then
    echo "Neni cislo"; exit;
fi


if [ -z $1 ] || [ $1 -gt 999 ] || [ $1 -lt 1 ]; then
        echo "Asi mas spatny pocet ... nevim no!"; exit;
fi;

echo $1
echo "Tady mas 1 bod Jirko :)";



#service quota start
#mount -o remount,usrquota,grpquota /home
#quotacheck /dev/sdb1
#quotaon /dev/sdb1

a=1
to=$1

prefix="user"
#group="GR"
#groupname="$prefix$group"
#groupadd "$groupname"

while [[ a -le to ]]
do

   name="$prefix$a"
   echo $name

   useradd -m -s /bin/bash -c "$name" -p "" $name
   chage -d 0 "$name"
   #passwd -d $name
   #usermod -a -G "$prefix$group" "$name"
   #edquota -u $name
   setquota $name 5000 5000 5000 5000 -a


   a=$(($a+1))
done
```

-----------------------------------

### Otestovani quota
repquota /dev/md127

### Sdileni slozky
mkdir /projekty				# nova slozka pro sdileni
addgroup projekty 		# nova skupina se jmenem 

adduser user1
adduser user2

usermod -a -G projekty user1	# pridani uzivatele do skupiny
usermod -a -G projekty user2
...............
chgrp projekty /projekty # vlastnikem slozky je skupina
chmod -R 2770 /projekty # rekurzivni zmena prav (vlastnikem je skupina)


# informace o userech
cat /etc/passwd
cat /etc/group

ls -ld prava adresare

apt update 
apt install apache2 php libapache2-mod-php php-mcrypt

a2enmod ssl  # zapnuti ssl

/etc/apache2/sites-available/000-default.conf  # nastaveni ssl

# Instalace weboveho serveru Apache s provozem http a modulem userdir
apt update
apt install libapache2-mod-php
a2enmod userdir
systemctl restart apache2
## v druhe konzoli
mkdir public_html
cp /var/www/html/index.html ./public_html/

### Pokud chceme vlozit i soubor s ukazkou funknosti.

### Nastaveni a restart serveru
ls /etc/apache2/mods-enabled

/etc/apache2/mods-enabled/dir.conf 			# prehodit poradi index.php pred index.html

### Vytvorit soubor index.php
/var/www/html/index.php




# Tvorba sluzby
nano /etc/systemd/system/fwtest.service

-----------------------------------
[Unit]
Description=Firewall sluzba

[Service]
Type=oneshot
WorkingDirectory=/root
ExecStart=/root/firewall.sh				# Spousteci skript
ExecStop=/root/firewall_stop.sh			# Vypinaci skript
RemainAfterExit=yes						# Po dokonceni ponechat sluzbu aktivni
syste
[Install]
WantedBy=multi-user.target
----------------------------------

#Zapnuti sluzby
systemctl enable fwtest


apt update
apt install iptables

iptables -L #zobrazi pravidla
iptables -F #smaze pravidla


# Skript pro start firewall.sh	
-----------------------------------

```
#!/bin/bash

iptables -P INPUT DROP;
iptables -P OUTPUT DROP;

iptables -A INPUT  -i enp0s8 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT  -i enp0s8 -p tcp --dport 2049 -j ACCEPT
iptables -A INPUT  -i enp0s8 -p udp --dport 2049 -j ACCEPT

iptables -A INPUT  -p tcp -m multiport --dports 80,443 -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT

iptables -A OUTPUT -p icmp -j ACCEPT
```




-----------------------------------

# Skript pro stop firewall_stop.sh	
-----------------------------------
#!/bin/bash

iptables -F
-----------------------------------


apt install isc-dhcp-server

mcedit /etc/default/isc-dhcp-server

INTERFACESv4="enp0s8"

mcedit /etc/dhcp/dhcpd.conf

nano /etc/dhcp/dhcpd.conf
> option domain-name "vsb.cz";
  option domain-name-servers 158.196.0.53, 158.196.149.9;
> subnet 192.168.56.0 netmask 255.255.255.0 {
  range 192.168.56.20 192.168.97.120;
  option broadcast-address 192.168.56.255;
  option routers 192.168.56.2;
}


service isc-dhcp-server restart¨

service isc-dhcp-server status

dhcp-lease-list


zapnout druhy pocitac 
dhclient enp0s8
dhcpd -d



# Instalace NFS serveru s exportem slozky /var/www
apt install nfs-kernel-server
nano /etc/exports
> /var/www        192.168.97.0/24(rw,sync,no_subtree_check)
service nfs-kernel-server restart
exportfs
dhcpd -d # pro ziskani IP z meho DHCP
nano /etc/dhcp/dhcpd.conf
## v konzoli druheho PC
apt install nfs-common
mount 192.168.97.102:/var/www /mnt/