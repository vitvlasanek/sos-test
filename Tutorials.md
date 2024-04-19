2 přednášky/cv odpovídá 1 tutorialu

# 1 Tutorial
[Prvni](http://seidl.cs.vsb.cz/wiki2/index.php/SOS#Co_budete_pot.C5.99ebovat_na_cvi.C4.8Den.C3.AD:~:text=informace%20zcela%20aktu%C3%A1ln%C3%AD!-,Prvn%C3%AD%20p%C5%99edn%C3%A1%C5%A1ka,-Zapn%C4%9Bte%20si%20pros%C3%ADm)

**Klíčová slova:**
```
standardní výstup a standardní chybový výstup, přesměrování, pípa, návratový kód funkce
cat, cut, grep, sort, tr, echo
#!/bin/bash, . , for, switch, while, until, $@, 0 CZK, 23.43 CZK, $$ , $# .....
if...then...else , test, []
```


for i in $(ssh kub0677@192.168.51.1 "ls /"); do touch $i; endif;

Login/Password
- kub0677/kub0677
- root/root

- dhclient enp0s8 - connect / get ip
- Host machine: ssh kub0677@192.168.56.101

- cvičení jsou v /opt/SOS/
- 

Tutorial 2 - CV3/4 

SuperUser s rozširenými přistupy k programým (všechny cesty)
- su -
Hack linux
- in GRUB press "E"
- init=/bin/bash/
- mount -o,remount rw / - umožní write operace na disk
- change password
- exec /sbin/init  - start system services


Partitions
- su -
- cfdisk /dev/sdb - create the partition
- mkfs.ext4 /dev/sdb1 - format the partition
- mount /dev/sdb1 /mnt/ - mount to folder mnt
- mount po startu systemu
	- mcedit /etc/fstab - přidat zaznam o mount disku
	- ? mount -a - asi?
	- ? chybi krok? deamon reload nebo tak neco
	- reload


- mdadm --manage /dev/md127 --set-faulty /dev/sdc
	- uměle vyvolám chybu na disku sdc
- mdadm --manage /dev/md127 --remove /dev/sdc
	- odstranim disk
- mdadm --manage /dev/md127 --add /dev/sdc
	- přidam nový disk

vytvoření raid
- mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 --spare-devices=1 /dev/sdc /dev/sdd /dev/sde
- mkfs.ext4 /dev/md0
- mdadm --detail --scan >> /etc/mdadm/mdadm.conf
- update-initramfs -u

# Tutorial 3
## [Přednáška 5](http://seidl.cs.vsb.cz/wiki2/index.php/SOS#Co_budete_pot.C5.99ebovat_na_cvi.C4.8Den.C3.AD:~:text=dle%20pokyn%C5%AF%20vyu%C4%8Duj%C3%ADc%C3%ADho.-,P%C3%A1t%C3%A1%20p%C5%99edn%C3%A1%C5%A1ka,-Zapn%C4%9Bte%20si%20pros%C3%ADm)
- htop - processes - task manager
- cat - print out file
- cat /etc/shadow - print user passwords (hash)
- cat /etc/passwd - users overview [Guide](https://linuxize.com/post/etc-passwd-file/)
- adduser

**Klíčová slova:**
```bash
apt install openssl quota

adduser, deluser
useradd, userdel

useradd -m -s /bin/bash -c "Bezny Franta Uzivatel" -p `echo "P4sSw0rD" | openssl passwd -1 -stdin` franta

/etc/passwd
/etc/group
/etc/skell
/etc/shadow

mount -o remount,usrquota,grpquota /home    #toto řešení funguje jen do restartu, korektně je nutné editovat /etc/fstab
service quota start                         #nezapomeňte službu povolit, ať se zavádí po startu
quotacheck /dev/sdb1                        
quotaon /dev/sdb1                           
edquota franta

chmod
chown
chgrp

S - Bit
T - Bit
```

### Klíčová slova

- **apt install**: Instalace balíčků, např. `openssl` pro šifrování, `quota` pro diskové kvóty.
- **adduser/deluser**: Přidání nebo odstranění uživatelů interaktivně.
- **useradd/userdel**: Přidání nebo odstranění uživatelů s více možnostmi.
  - Příklad: `useradd -m -s /bin/bash -c "Bezny Franta Uzivatel" -p $(echo "P4sSw0rD" | openssl passwd -1 -stdin) franta`
- **/etc/passwd** a **/etc/group**: Informace o uživatelích a skupinách.
- **/etc/skel**: Šablona pro nové domovské adresáře.
- **/etc/shadow**: Obsahuje šifrovaná hesla uživatelů.
- **Správa kvót**:
  - Příkazy pro práci s kvótami, jako `mount -o remount,usrquota,grpquota /home`, `service quota start`, `quotacheck /dev/sdb1`, `quotaon /dev/sdb1`, a `edquota`.
- **chmod, chown, chgrp**: Změna oprávnění, vlastníka souboru, nebo skupiny.
- **S-Bit / T-Bit**: Speciální oprávnění pro soubory a adresáře.
	- S-bit - 
	- T-bit

- passwd -e - expire the password imeadietly and force user to change it after login

nastaveni quote dodrž tento postup z webu

```bash
mount -o remount,usrquota,grpquota /home    #toto řešení funguje jen do restartu, korektně je nutné editovat /etc/fstab
service quota start                         #nezapomeňte službu povolit, ať se zavádí po startu
quotacheck /dev/sdb1                        
quotaon /dev/sdb1                           
edquota franta
```


- chmod g+w filename
	- g+w - add write permision to group
	- o+w - add write permission for all
	- o-w - remove permission for all (meaning the other users doe not effect hte group nor the user)
- chgrp groupName fileName
	- change the group of file that the permissions are defined for
- whereis program - get path to program

Ukol

Users 
1

```
for i in {1..50}; do
  sudo useradd -m user$i           # Creates a user with a home directory.
  sudo passwd -de user$i           # Deletes the user's password and expires it.
done

```

2
```
sudo groupadd tisk                  # Create the 'tisk' group.
sudo mkdir /tisk                    # Create the '/tisk' directory.
sudo chgrp tisk /tisk               # Change the group ownership to 'tisk'.
sudo chmod 2770 /tisk               # Set the permissions and the setgid bit.

usermod -aG tisk user1 # `-aG` option adds the user to the specified group without removing them from other groups.
```

- Use `ls -ld /tisk` to check the permissions and group ownership of the `/tisk` directory.

Quotes Bash script


```
#!/bin/bash
from=0
to=40
login="usm"
zero="0"

for (( i=from; i<=to; i++ ))
do
    if [[ $i -lt 10 ]]
    then
        name=${login}${zero}${i}
        useradd -m -s /bin/bash $name
        passwd -e $name
        setquota $name 100 200 10 15
    else
        name=${login}${i}
        useradd -m -s /bin/bash $name
        passwd -e $name
        setquota $name 100 200 10 15
    fi
done

```


## [Přednáška 6](http://seidl.cs.vsb.cz/wiki2/index.php/SOS#Co_budete_pot.C5.99ebovat_na_cvi.C4.8Den.C3.AD:~:text=dle%20pokyn%C5%AF%20vyu%C4%8Duj%C3%ADc%C3%ADho.-,%C5%A0est%C3%A1%20p%C5%99edn%C3%A1%C5%A1ka,-Zapn%C4%9Bte%20si%20pros%C3%ADm)
Sít
**Klíčová slova:**

```bash
/etc/network/*

cat /etc/network/interfaces
auto enp0s3
iface enp0s3 inet dhcp

allow-hotplug enp0s3
iface enp0s3 inet static
	address 192.168.0.1
	netmask 255.255.255.0
	broacast 192.168.0.1

ip route add default via 192.168.0.254
ip route del default via 192.168.0.254

route add default gw 192.168.0.1 //přidá defaultní gateway
route del default gw 192.168.0.1 //odebere defaultní gateway

/etc/resolv.conf //konfigurace DNS, základem je řádek _nameserver IP_ADRESA_

Výborný článek se základy zde [[45]](http://www.abclinuxu.cz/blog/Debian_Lenny/2009/10/zakladni-konfigurace-linux-firewallu-pomoci-iptables)
iptabels -t filter, iptabels -t nat, iptabels -t mangle
iptables -P INPUT ACCEPT //defaultní politika
iptables -A INPUT  -i eth0 -j ACCEPT //pustí pakety vstupující do systému přes eth0
iptables -A OUTPUT -o eth0 -j DROP   //zahodí pakety vystupující ze systému přes eth1
iptables -A INPUT -s 192.168.0.100 -j DROP   //zahodí pakety vstupující do systému se zdrojovou IP 192.168.0.100
iptables -A FORWARD -d 192.168.0.0/24 -j ACCEPT   //pustí pakety procházející systémem s cílovými IP 192.168.0.0/24
iptables -A INPUT -p tcp --dport 80 -j DROP //zakáže pakety vstupující do systému s cílovým tcp portem 80
iptables -A OUTPUT -p tcp --dport 80 -j DROP //zakáže pakety vystupující ze systému s cílovým tcp portem 80

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  //zamaskuje pakety vystupující ze systému přes eth0
echo "1" > /proc/sys/net/ipv4/ip_forward //povolí přeposílání paketů

iptables-save > /etc/iptables
iptables-restore /etc/iptables
```



- ovladat ip address a ip route utilities
	- nastaveni default gateway

install iptables
install netcat
testnout si praci s firewall


### Apache
- pro test jak enable
apt install apache2
systemctl status apache2
a2enmod ssl - enable ssl
a2ensite default-ssl - enable ssl site
systemctl restart apache2 - restart

apt search php | grep apache2

ne test
LAMP server setup

ls -la 
ls -ls

- NFS - export
- nfscommon


