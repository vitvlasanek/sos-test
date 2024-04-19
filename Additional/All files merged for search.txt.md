mkdir /home/vsichni #vytvorit slozku
groupadd -g 666 vsichni #vytvorit skupinu  // číslo hocijaké unique ID https://www.computerhope.com/unix/groupadd.htm
usermod -G vsichni ucet01 #pridat uzivatele do skupiny //https://www.tecmint.com/usermod-command-examples/
chgrp -R vsichni /home/vsichni #zmeni skupinu rekurzivne //https://www.computerhope.com/unix/uchgrp.htm

chmod g+s /home/vsichni #nove vytvorene hovna jsou ve “vsichni” group


-------------------------------------------------------------------
4. Vytvořte 2 uživatele pro Samba sdílené úložiště:
- Vytvoříme nového usera - sudo useradd -M -d /samba/MAJ0123 -s /user/sbin/nologin -G sambashare MAJ0123A
- Vytvoříme nového usera -sudo useradd -M -d /samba/MAJ0123 -s /user/sbin/nologin -G sambashare MAJ0123B
- Vytvoříme shared složku s našim loginem - sudo mkdir /samba/MAJ0123
- Přidáme práva userovi A - sudo chown MAJ0123A:sambashare /samba/MAJ0123
- Přidáme práva userovi B -  sudo chown MAJ0123B:sambashare /samba/MAJ0123
- Nastavíme práva na složce - sudo chmod 2770 /samba/MAJ0123
- Nastavíme heslo pro usera A - sudo smbpasswd -a MAJ0123A
- Nastavíme heslo pro usera B -  sudo smbpasswd -a MAJ0123B
- zapneme usera  sudo smbpasswd -e MAJ0123A
- zapneme userasudo smbpasswd -e MAJ0123B
- Restart smb  sudo systemctl restart smbd
- Restart smb sudo systemctl restart nmbd





https://youtu.be/rdRy1V8esl0
------------------------------

apt-get install apache2
apt-get install libapache2-mod-php
/sbin/service apache2 restart

--- dôkaz inštalácie php
cd /var/www/html/
ls
... mal by tu byť index.html
mv index.html index.php

vim.tiny index.php


<?php phpinfo(); ?>

w3m localhost
-------------------------

cd/etc/apache2/mods-avaible
/sbin/a2enmod userdir        ..... alebo ssl čo treba

----------
apt-get install default-mysql-server

apt-get install wget

cd /var/www/html
wget https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.1.tar.gz

ln -s mediawiki... wiki		......... vytvorenie symbolického odkazu

apt search mbstring
apt-get install php-mbstring
apt-get install php-xml
apt-get install php-mysql
/sbin/service apache2 restart


raid... raid, spare disk, ako funguje, aká bude kapacita poľa
diskové kvóty... ukázať kvótu užívateľa, ako zmeniť, hardcode, softcode
zdieĽanie ... uživateľské práva rwx pre subor\ zložku rws, t bit

v akom stave je webový server apache systemctl, utilitka service, 

firewall, čo to je default politika, či záleží na poradí, source destination, vytvorte jednotku

system d

systemctl ukazuje service-i
----------------------
 3  apt-get install mdadm
    4  lsblk
    5  /sbin/mdadm --create /dev/md127 --level=5 --raid-device=3 /dev/sdb /dev/sdc /dev/sdd --spare-devices=0
    6  lsblk
    7  /sbin/fdisk /dev/md127
    8  lsblk
    9  /sbin/mkfs.ext4 /dev/md127p1
   10  mount /dev/md127p1 /mnt
   11  cp -a /home/* /mnt/
   12  mount /dev/md127p1 /home/
   13  nano /etc/fstab
   14  umount /mnt/
   15  umount /home
   16  mount -a
   17  lsblk
-------------------------kvóty
#!/bin/bash
from=0
to=40
login="usr"
zero="0"

for (( i=$from; i<=$to; i++ ))
do
	if [ $i -lt 10 ]
	then
		name=$login$zero$i
		/sbin/useradd -m -s /bin/bash $name
		passwd -e $name
		/sbin/setquota $name 100 200 10 15 -a /home
	else
		name=$login$i
		/sbin/useradd -m -s /bin/bash $name
		passwd -e $name
		/sbin/setquota $name 100 200 10 15 -a /home
	fi
done

---enable quota
touch /aquota.user /aquota.group
chmod 600 /aquota.*
mount -o remount /

quotacheck -avugm
quotaon -avug
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

nano /etc/fstab
mkfs.ext4 /dev/sdb1

mdadm --manage /dev/md0 --fail /dev/sdb1
mdadm --manage /dev/md0 --remove /dev/sdb1
mdadm --manage /dev/md0 --add /dev/sdb1

cat /proc/mdstat

3. home zložka
/dev/VolGroup00/LogVol02¬†¬†¬†¬† /home¬†¬†¬†¬† ext3¬†¬†¬†¬† defaults, usrquota¬†¬†¬†¬† 1 2
mount -o remount /home

quotacheck -cu

quota -vs usr00

useradd -m vytvorenie zložky
useradd -s /bin/bash shell?
passwd -e $usr

cat /etc/passwd

4. 
mkdir /home/vsichni #vytvorit slozku
groupadd -g 666 vsichni #vytvorit skupinu
chmod g+s /home/vsichni 
groups linuxize

stat /home

5.
Apache - /var/www/html
/etc/apache2/
lynx https://IP
lynx IP
lynx 192.168.62.106/~sut0018 

ls -ls /home/sdileni

6.
apt-get install default-mysql-server
apt-get install wget
apt install php-mbstring
https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.1.tar.gz


/var/lib/mysql

/etc/mysql/my.cnf

Drives, RAID
0. apt install mdadm
1. fdisk -l
2. mkfs.ext4 drive
3. cfdisk - partitioning
4. /etc/fstab - mount after boot
5. mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc 
   --spare-devices=1 /dev/sdd


Quotas
1. apt install quota
2. mount -o remount,usrquota,grpquota /home
3. service quota start
4. quotacheck /dev/sdb1
5. quotaon /dev/sdb1
6. edquota user
7. setquota -u user 10 20 5 10 -a /home
8. quota -u user

Users and groups
1. groupadd groupname
2. usermod -G groupname username
3. useradd -m -s /bin/bash -c "desc" -p `echo pwd | openssl passwd -1 -stdin` username
4. passwd -e username - to expire
5. passwd -d username - to delete pwd

Permissions
1. chmod XXX file
2. chgrp grp filename
3. chmod g+s



Apache with PHP and SSL
1. install apache2 
 - webfiles in /var/www/html/
 - apache config in /etc/apache2/
2. instal libapache2-mod-php
3. enable ssl - /usr/sbin/a2enmod ssl
4. enable https site - /usr/sbin/a2ensite default-ssl
5. enable userdir - a2enmod userdir



MariaDB and MediaWiki
1. apt install default-mysql-server
2. wget the file from mediawiki, tar -xf
3. link the folder for easier access, move it to the /html/ folder first
4. setup database

# mysql -u root -p
MariaDB [(none)]> use mysql
MariaDB [mysql]> CREATE USER 'wiki'@'localhost' IDENTIFIED BY 'wiki';
MariaDB [mysql]> \q

# mysql -u root
MariaDB [(none)]> CREATE DATABASE wiki;
MariaDB [(none)]> use wiki
MariaDB [wiki]> GRANT ALL ON wiki.* TO wiki@localhost;
Query OK, 0 rows affected (0.01 sec)
MariaDB [wiki]>\q

5. install missing components, php-mbstring, php-xml
6. configure the database in lynx
7. install php-mysql if needed
8. copy LocalSettings.php into /var/www/html/wiki/



NFS server
1. apt install nfs-kernel-server
2. config /etc/exports
3. exportfs check, list of exports
4. apt install nfs-common (to be able to mount shared FS)
5. on client pc, mount the shared FS-> mount IP:/folder folder



DHCP server
1. you can check network  settings /etc/network/interfaces
2. apt install isc-dhcp-server
3. config - /etc/default/isc-dhcp-server
   here you should config the interface name for DHCP to be running at
4. /etc/dhcp/dhcpd.conf
   here you can do a lot of advanced config, create DNS, default lease time,...
   subnets - ...



Network
1. Network config - ip command, /etc/network/interfaces

	allow-hotplug enp0s8
	iface enp0s8 inet static
		address XXXX
		netmask XXXX
		gateway XXXX
		...
2. ifdown, ifup, ...
3. echo 1 > /proc/sys/net/ipv4/ip_forward - enable packet forwarding between
   interfaces
	alternative = /etc/sysctl.conf




Firewall
1. /usr/sbin/iptables -L -list all 
   example - /usr/sbin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT  
2. allowing SSH for certain IP
	allow all outgoing SSH connections
		iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
	allow only certain incomming SSH conn
		iptables -A INPUT -p tcp -s X.X.X.X/24 --sport 22 -j ACCEPT
3.apt install iptables-persistent
4. iptables-save, can be redirected to a file
5. /etc/iptables/rules.v4
	 - stores settings to be loaded after boot automatically


exportfs -v
mount
mdamd -D /dev/md127
cat /etc/passwd
ip a
etc/fstab
etc/network/interfaces
etc
ls -al /projekty
192.168.0.100/~'uzivatel'-userdit
192.168.0.100/info.php
https://192.168.0.100/
etc/dhcp/dhcpd.conf
-x uzivatel.sh
quotacheck -v
repquota -a
groupmems -l -g projekty-seznam uziv
getent group projekty
ip route show
showmount -e 127.0.0.1
members projekty
dhcp-lease-list --all
mount | grep nfs - kontrola pripojeni
getent group
edquota 
Tbit -na adresar, zabrani uzivatelum aby mazali soubory, ktere nevlastni jako uzivatel 
Sbit -na adresar, zajisti ze vsechny soubory v nem jsou vlastneny skupinovym vlastnikem adresare.
owner -1-3
group -4-6
other -7-9
file /root/
edquota uzivi
apachectl -M


#Tvorba sluzby
nano /etc/systemd/system/fwtest.service

-----------------------------------
[Unit]
Description=Firewall sluzba

[Service]
Type=oneshot
WorkingDirectory=/root
ExecStart=/root/firewall.sh				#Spousteci skript
ExecStop=/root/firewall_stop.sh			#Vypinaci skript
RemainAfterExit=yes						#Po dokonceni ponechat sluzbu aktivni
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


#Skript pro start firewall.sh	
-----------------------------------
#!/bin/bash

iptables -P INPUT DROP;
iptables -P OUTPUT DROP;

iptables -A INPUT  -i enp0s8 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT  -i enp0s8 -p tcp --dport 2049 -j ACCEPT
iptables -A INPUT  -i enp0s8 -p udp --dport 2049 -j ACCEPT

iptables -A INPUT  -p tcp -m multiport --dports 80,443 -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT

iptables -A OUTPUT -p icmp -j ACCEPT



-----------------------------------

#Skript pro stop firewall_stop.sh	
-----------------------------------
#!/bin/bash

iptables -F
-----------------------------------

#pred spustenim nejsou nastaveny quoty na home
apt install quota
mount -o remount,usrquota,grpquota /dev/md127p1
service quota start
quotaon /home

#editovani quoty
quota username
edquota username

edquota -p userprototype newuser; #upraveni quoty podle prototypu

#kde najdu info o uzivatelich
cat /etc/passwd

#je script spustitelny?
ls -l script

#spustit script
./script parametry

#Skript pro uzivatele
chmod +x skriptname.sh		#aby sel VSEMI spustit skript
https://pastebin.com/vBFKxXq8

-----------------------------------
#!/bin/bash

if ! [[ $1 =~ ^[0-9]+$ ]]
then
    echo "Neni cislo";
	exit;
fi;

if [ -z $1 ] || [ $1 -gt 999 ] || [ $1 -lt 1 ]; then
    echo "nulovy znak, vetsi nez 999, mensi nez 1";
	exit;
fi;

a=1
to=$1

prefix="uz"

while [[ a -le to ]]
do
   name="$prefix$a" 
   echo $name
	
   #-m specifikuje vytvoreni domovskeho adresare v /home
   #-s specifikuje shell
   #-c je comment (full name)
   #-p je password 
   
   useradd -m -s /bin/bash -c "$name" -p "" $name  
   #useradd -m -s /bin/bash -c "$name" -p `echo $1 | openssl passwd -1 -stdin` $name
   chage -d 0 "$name"				#nebo passwd -e user
   setquota $name 100 200 10 15 -a /home

   a=$(($a+1))
done
-----------------------------------

#Otestovani quota
repquota /dev/md127
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
mkdir /projekty				#nova slozka pro sdileni
addgroup projekty 		#nova skupina se jmenem 

adduser user1
adduser user2

usermod -a -G projekty user1	#pridani uzivatele do skupiny
usermod -a -G projekty user2
...............
chgrp projekty /projekty #vlastnikem slozky je skupina
chmod -R 2770 /projekty #rekurzivni zmena prav (vlastnikem je skupina)


#informace o userech
cat /etc/passwd
cat /etc/group

ls -ld prava adresare

Zakomentovat radek v

vi /etc/apt/sources.list

sjet na radek a pak
i - insert mode
dat tam #

pak sjet na prazdny radek
shift + �

:wq quit se savem
q!  quit bez savu


apt install mcedit
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
apt update 
apt install apache2 php libapache2-mod-php php-mcrypt

a2enmod ssl  #zapnuti ssl

/etc/apache2/sites-available/000-default.conf  #nastaveni ssl

# Instalace weboveho serveru Apache s provozem http a modulem userdir
apt update
apt install libapache2-mod-php
a2enmod userdir
systemctl restart apache2
## v druhe konzoli
mkdir public_html
cp /var/www/html/index.html ./public_html/

#Pokud chceme vlozit i soubor s ukazkou funknosti.

#Nastaveni a restart serveru
ls /etc/apache2/mods-enabled

/etc/apache2/mods-enabled/dir.conf 			#prehodit poradi index.php pred index.html

#Vytvorit soubor index.php
/var/www/html/index.php

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


service isc-dhcp-server restart�

service isc-dhcp-server status

dhcp-lease-list


zapnout druhy pocitac 
dhclient enp0s8
dhcpd -d
#Zakladn� postup
Vypnout virtu�l
Pridat disky

#Prikazy 
fdisk -l 					#vypis disku
mcedit /etc/fstab
cat /proc/mdstat	
lsblk			

#Balicek na instalaci RAID
apt update			#aktualizace balicku
apt-get install mdadm		#instalace balicku

#Udelat partitiony pro kazdy disk
fdisk /dev/sdX      	#zapnuti nataveni disku
n ENTER					#new
p ENTER					#primary
ENTER, ENTER,.. 		#dalsi nastaveni
t ENTER fd ENTER		#nevim nejake nastaveni
w ENTER					#save nastaveni

#Tvorba RAID
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
            

#Alternativa p��mo se sparem
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc --spare-devices=1 /dev/sdd	

#Partition
cfdisk /dev/md0
gpt
new
write

#Propojeni s /home/

mkfs.ext4 /dev/md0p1

mount /dev/md0p1 /mnt/

cp -a /home/* /mnt/

mount /dev/md0p1 /home/


#Co dat do /etc/fstab, aby se raid udelal i po spusteni
/dev/md127p1	/home	ext4	defaults	0	0


NEZAPOMENOUT, ZE SE PO RESTARTU MENI md0 na md127
TEST
apt-get install mcedit

1) zapnout cho0177 vse loginy, na sda, dat cestinu, pruzkum ne, grub ano /dev/sda

2)fdisk -l pro disky
apt update
apt-get install mdadm
cfdisk /dev/sd(b,c,d) gpt novy enter ulozit ano enter konec
fdisk-l pro kontrolu
se spare diskem mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1 
mdadm --detail /dev/md0			#Stav raidu
mkfs.ext4 /dev/md0				#Zavedeni souboroveho systemu

//copy home
mount /dev/sdxy /mnt
cp -r /home/* /mnt
umount /dev/sdxy
mount /dev/sdxy /home

//bezcopyhome
mkdir /home/raid
mount /dev/md0 /home/raid

//checkout mount point
df -h

//dat permanentne mount
blkid | grep -i "/dev/md0" >> /etc/fstab
UUID=45445 /home/raid ext4 defaults 0 0

3)
cat /etc/passwd pro uzivatele vypis
apt-get install openssl quota
 pravy alt+strednik(vlevonahore jebla uvozovka)
u scriptu passwd je to 1 ne l

userdel -r jmeno;

systemctl start quota
systemctl enable quota - zapne quoty!!!!!

mcedit /etc/fstab dat grpquota,usrquota na disk kterem
 chci quoty(tam kde je home?)(tam kde chci quoty takze treba / nebo /dev/md0 127)
 za remount-ro, nebo za defaults

quotacheck / -fm (klidne /dev/md0nebo127) podle toho kde mas nastavene quoty
repquota / (nebo md0 nebo /sda)


reboot

vytvor script chmod +x na nej
insert script

4)

//test group ls -la

mkdir /home/vsichni
groupadd vsichni
usermod -a -G vsichni user00-10
chgrp vsichni /home/vsichni
chmod -R 2770 /home/vsichni

5)
apt update
apt install apache2 php libapache2-mod-php mcrypt

//zapnu ssl
a2enmod ssl

//vytvorim klic
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt		 #Tvorba klice


8)
chmod +x na script*-*-
date +%F datum vee formatu
mkdir -p file bez prepisu
touch -m bez modifikace
tar -rvf /backup/
tar -tf /backup/.tar ukaze content

script je v slozcegoogle

/etc/systemd/system vytvor timer a service podle obrazku

systemctl daemon-reload
systemctl start backups.timer
systemctl list-timers --all




#! /bin/bash
# script pro vytvoreni uzivatelu

if [ -z $1 ];
then
    HESLO=""
elif [ ${#1} -lt 5 ];
then
    echo "Kratke heslo";
    exit 1;
else
    HESLO=$1;
fi

for i in $(seq 0 2);
do
    number=$i

    if [ $number -lt 10 ];
    then
        # vytvor user
        user=user0$number;
    else
        # vytvor usera
        user=user$number;
    fi

    useradd -m -s /bin/bash -c "$user" -p `echo $HESLO | openssl passwd -1 -stdin` $user;
    setquota $user 100 200 10 10 -a /
done;

iptables -L							#seznam pravidel
iptables -P OUTPUT DROP						#defaultní politika pro output je drop

#povolí ssh z dané ip
iptables -A INPUT -p tcp --dport 22 -s 192.168.57.1/32	-j ACCEPT
iptables -A INPUT -p tcp --sport 22 -d 192.168.57.1/32	-j ACCEPT

#povolí http(s)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT




-p protokol - TCP/UDP



[tvojLogin]@ki-vi-ucebna1-gw.vsb.cz heslo jako edison
pak login na ssh z tamtemrdky
#instalace apache --------------------------------------------------------------------------------------------------
apt-get install apache2 					#nainstaluje apache
#už to můžeme najít na ip adrese příadně i v tom lynx

#zprovoznění php -------------------------------------------------------------------------------------------------
apt-get install libapache2-mod-php 				#nainstaluje php
service apache2 restart 					#musí restartovat
mv /var/www/html/index.html /var/www/html/index.php  		#místo toho aby se Seidl jebal s pořadím tak to prostě přejmenoval :D
#TODO přidáš nějakou PHP funkci abys demonstroval funkčnost

#povolení ssl -------------------------------------------------------------------------------------------------------
a2enmod ssl							#povolí ssl
systemctl restart apache2					#restart apache
a2ensite dafault-ssl						#povolí https stránku
systemctl reload apache2					#restart apache
#už pojede stránka i přes https
a
a
a jede

#povolení userdir --------------------------------------------------------------------------------------------------------------
a2enmod userdir							#povolí userdir
systemctl restart apache2					#restart apache
#přepnu na u6ivatele sli0094
mkdir /home/uziv/public_html						#musí být public_html (souhlasti s tím co je v /etc/apache2/mods-enabled/userdir.conf a musí být v domovském adresáři
echo AHOJ > public_html/index.php				#napíše ahoj do souboru index.php ve složce index_html
#když se přepnu na stránku a dám ip/~sli0094 (lynx localhost/~sli0094) měl bych vidět AHOJ

#instalace MySQL ------------------------------------------------------------------------------------------------------------------
apt-get install default-mysql-server				#nainstaluje mysql (reálně mariadb)
apt install wget						#stáhne wget aby mohl stahovat soubory
wget https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.1.tar.gz
mv mediawiki-1.34.1.tar.gz /var/www/html/			#přesuneme tam kde je index
tar -xvf mediawiki-1.34.1.tar.gz				#rozbalí do aktuální složky
ln -s mediawiki-1.34.1 wiki				#vytvoří symlink do složky (abychom nemuseli psát do url verzi)

mysql -u root -p								#připojí do db
MariaDB [(none)]> use mysql							#použije mysql (může tam být i třeba sqllite tak asi proto)
MariaDB [mysql]> CREATE USER 'wiki'@'localhost' IDENTIFIED BY 'wiki';		#vytvoří uživatele
MariaDB [(none)]> CREATE DATABASE wiki;						#vytvoří db
MariaDB [(none)]> use wiki;							#použije db
MariaDB [wiki]> GRANT ALL ON wiki.* TO wiki@localhost;				#dá přístup uživateli wiki do db wiki
MariaDB [wiki]>\q								#opustí db

apt install php-mbstring					#přidá do php extension mbstring
apt install php-xml						#přidá do php extension xml
service apache2 restart	
apt install php-mysql						#přidá do php extension mysql

lynx localhost/MediaWiki(wiki)
heslo cho0177cho0177 pro usera

#teď by se mělo nainstalovat to media wiki, každopádně nepřišel jsem na to, jak to dělat v tom lynx, respektive mi to hází chybu, takže na to se ho musím doptat
nastavit dalsi blbosti
stahnout localsetting.php movnout do slouzky wiki 
