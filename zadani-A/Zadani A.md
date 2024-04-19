- Instalace
- su -
- ip -a
- dhclient enp0s8
- 
- Host machine: ssh kub0677@192.168.56.101

1 - 3 stejny 

- `systemctl enable` - start on boot
- `systemctl start` - start now

### 2 Manuální konfigurace souboru 

`/etc/network/interfaces`

1. **Otevřete konfigurační soubor**:
    `sudo nano /etc/network/interfaces`
    
2. **Přidejte konfiguraci pro DHCP na rozhraní NAT** (`enp0s3`):
    
```
# Primární síťové rozhraní pro NAT
auto enp0s3
iface enp0s3 inet dhcp # ipv4 enable dhcp
```

    
3. **Přidejte konfiguraci pro statickou IP na Host-only rozhraní** (`enp0s8`):

```
# Sekundární síťové rozhraní pro Host-only síť
auto enp0s8
iface enp0s8 inet static
    address 192.168.56.101
    netmask 255.255.255.0
    network 192.168.56.0
    broadcast 192.168.56.255
```

4. **Uložte a zavřete soubor**.
5. **Restartujte síťové služby** pro aplikaci změn:
    `sudo systemctl restart networking.service`
    
6. **Ověření konfigurace**: Po restartování služeb ověřte, že obě síťová rozhraní mají správnou konfiguraci:
    `ifconfig`    
    Kontrola výpisu vám ukáže, zda rozhraní `enp0s3` dostalo IP adresu z DHCP a zda `enp0s8` má správně nastavenou statickou IP.

### 3 Disky a RAID
1. Přidej disky ve VirtualBoxu
2. 
```
apt-get update
apt-get install mdadm
mdadm --create --verbose /dev/md0 --level=6 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde

mkfs.ext4 /dev/md0 # Formatovat
mkdir /mnt/md0
mount /dev/md0 /mnt/md0

```

1. **Nastavení automatického mountování při startu**:
    - Otevřete `/etc/fstab`:
        `sudo nano /etc/fstab`
    - Přidejte následující řádek:
        `/dev/md0 /mnt/md0 ext4 defaults 0 0`

```
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf # uložení
sudo update-initramfs -u # aby bylo zajištěno, že RAID je správně zaveden při bootu

sudo mdadm --detail /dev/md0 # zkontoluj stav
```

# rozbití disku

```sh
   mdadm --manage /dev/md0 --set-faulty /dev/sdd
```
 vice viz Tutorial
## 4 Uživatele + quotes (kvoty) script


Install
```
apt install quota
```

Set quota for disk to persist restart
- `mcedit /etc/fstab`
	- add options `usrquota,grpquota` LIKE
	  `UUID={XXXX} / ext4 defaults,usrquota,grpquota 1 1`
- add options `mount -o remount /`
```
systemctl daemon-reload
mount -o remount /home

service quota start
quotacheck -cug /home
quotacheck /dev/sdb1
quotaon /dev/sdb1
edquota uzivatel # ukaz/edituj quoty uzivatele
```


chmod +x skriptname.sh	
```
#!/bin/bash
# Skript pro vytvoreni uzivatelskych uctu

# Kontrola, zda byl skriptu predan parametr
if [ -z "$1" ]; then
  echo "Chybi parametr specifikujici pocet uzivatelu."
  exit 1
fi

# Kontrola, zda je parametr cislo a je v rozsahu 1 az 999
if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -le 0 ] || [ "$1" -gt 999 ]; then
  echo "Parametr musi byt cislo od 1 do 999."
  exit 1
fi

# Hlavni smycka pro vytvareni uctu
for (( i=1; i<=10#$1; i++ )); do
  # Formatovani jmena uzivatele
  user_name=$(printf "uz%03d" "$i")

  # Pridani uzivatele do systemu
  useradd -m -s /bin/bash "$user_name"

  # Nastaveni prazdneho hesla a vynuceni zmeny pri prvnim prihlaseni
  passwd -d "$user_name" # Smaze heslo
  passwd -e "$user_name" # Expiruj heslo hned
  # chage -d 0 "$user_name" # Nebo nastav stari heslo na 0day 1.1.1970

  # Vytvoreni souboru READ_ME.txt v domovskem adresari
  echo "Prectete si me" > "/home/$user_name/READ_ME.txt"

  # Nastaveni diskovych kvot pro uzivatele
  setquota -u "$user_name" 100M 200M 0 0 -a /
done

echo "Uzivatele byli vytvoreni."
```


1. `#!/bin/bash` - This is the shebang line which tells the system to execute this script with the Bash shell.
    
2. Check if a parameter (`$1`, the desired number of users to create) was passed to the script:
    `if [ -z "$1" ]; then   echo "Chybi parametr specifikujici pocet uzivatelu."   exit 1 fi`
    
    If no parameter is passed, the script prints a message indicating that a parameter is missing and exits with status `1`.
    
3. Check if the parameter is a number and less than or equal to 999
    
    `if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -gt 999 ]; then   echo "Parametr musi byt cislo od 1 do 999."   exit 1 fi`
    
    This part uses a regular expression `^[0-9]+$` to check if the parameter is a positive number. Then it checks if this number is greater than `999`. If either check fails, it prints a message and exits.
    
    - The part `10#$1` ensures that the number is treated as a base-10 number, which is important when numbers have leading zeros.
4. The for loop is used to create the specified number of users:
    `for (( i=1; i<=10#$1; i++ )); do`
    
    This loop runs from `1` to the number provided as an argument, inclusive.
    
5. Format the username with leading zeros to ensure it is three digits long:
    `user_name=$(printf "uz%03d" "$i")`
    
6. Add the user to the system:

    `useradd -m -s /bin/bash "$user_name"`
    
7. Set an empty password and force the user to change it upon first login:

    `passwd -d "$user_name" chage -d 0 "$user_name"`
    
8. Create a `READ_ME.txt` file in the user's home directory:

    `echo "Prectete si me" > "/home/$user_name/READ_ME.txt"`
    
9. Set disk quotas for the user:
    
    `setquota -u "`

- `setquota`: The command to set the disk quotas.
- `-u`: Specifies that the quotas are being set for a user (as opposed to a group, which would be `-g`).
- `"$user_name"`: The name of the user for whom the quotas are being set.
- `100M`: The soft limit for disk space usage. The user can exceed this limit for a certain period of time defined by the grace period.
- `200M`: The hard limit for disk space usage. The user cannot exceed this limit.
- `0`: The soft inode limit, which is the maximum number of files and directories (inodes) the user can create. A value of `0` typically means no limit is set.
- `0`: The hard inode limit, similar to the soft limit but enforced strictly without a grace period. Again, `0` usually means no limit is set.
- `-a`: Applies the quotas to all filesystems where quotas are enabled and the user has files. This is instead of specifying a particular filesystem.
- `/`: Specifies the root filesystem. This is used in conjunction with `-a` to apply the quotas across all filesystems mounted under root where quotas are enabled.


### Skupiny


```
#!/bin/bash
# Define a variable for the group name
group_name="projekt"

# Create a new group with the specified name
groupadd $group_name

# Create a new directory in the root directory with the name stored in 'group_name'
mkdir /$group_name

# Set the permissions of the directory to 770
# This gives full permissions to the owner and the group, and no permissions to others
chmod 770 /$group_name

# Change the owner of the directory to 'root' and the group to the newly created group
chown root:$group_name /$group_name

# Set the default file creation mask
# This affects the default permissions of newly created files and directories
# read and write by the owner and group, and read-only by others
umask 002

# Get the first 10 usernames containing 'user' from /etc/passwd and store them in 'users'; awk used for parsing separating by ":" and selecting 1st column
users=$(awk -F ':' '{print $1}' /etc/passwd | grep user -m 999)

# Add each user in 'users' to the 'projekt' group
for user in $users; do
  usermod -aG $group_name $user
done

```


### Apache2


```
apt install apache2
systemctl status apache2
systemctl start apache2
systemctl enable apache2
a2enmod ssl - enable ssl
a2ensite default-ssl - enable ssl site
systemctl restart apache2 - restart
a2enmod php8.2 # enable php version
apt search php | grep apache2
apt-get install -y php libapache2-mod-php
```



```
#!/bin/bash
# Skript pro instalaci Apache2 s podporou PHP, HTTPS a userdir

# Aktualizace seznamu balíčků
echo "Aktualizace seznamu balíčků..."
apt-get update

# Instalace Apache2
echo "Instalace Apache2..."
apt-get install -y apache2

# Zajištění, že Apache2 běží a je nastaven jako služba, která se spustí při startu systému
echo "Nastavení Apache2 ke spouštění při startu..."
systemctl start apache2
systemctl enable apache2

# Instalace PHP a modulu pro Apache
echo "Instalace PHP a modulu pro Apache..."
apt-get install -y php libapache2-mod-php

# Nastavení Apache2 pro použití PHP
echo "Nastavení Apache pro zpracování PHP souborů..."
a2enmod php8.2  # Přizpůsobte verzi PHP vašemu systému

# Instalace a konfigurace modulu SSL pro HTTPS
echo "Instalace a konfigurace SSL..."
apt-get install -y ssl-cert
a2enmod ssl
a2ensite default-ssl  # Aktivace defaultní SSL stránky
# defaultni konfigurace v /etc/apache2/sites-available/default-ssl.conf
systemctl reload apache2

# Instalace a aktivace modulu userdir
echo "Instalace a aktivace modulu userdir..."
a2enmod userdir
systemctl restart apache2

echo "Instalace dokončena. Apache2 běží s podporou PHP, HTTPS a userdir."


```


### Další často používané komponenty k Apache2:

1. **SSL/TLS Certifikáty**: Kromě samotného modulu `ssl` můžete chtít na testu generovat a konfigurovat vlastní SSL certifikáty nebo použít certbot (Let's Encrypt) pro získání platných certifikátů.
    `sudo apt-get install -y certbot python-certbot-apache sudo certbot --apache  # Spustí průvodce pro získání a instalaci certifikátů`
    
2. **Mod_rewrite**: Často používaný modul pro přepisování URL adres na serveru, což je užitečné pro SEO a přátelské URL.
    `sudo a2enmod rewrite`
    
3. **Mod_security**: Modul zabezpečení, který funguje jako firewall pro aplikace běžící na Apache.
    `sudo apt-get install -y libapache2-mod-security2 sudo a2enmod security2`
    
4. **Mod_headers**: Pro manipulaci s hlavičkami HTTP v odpovědích serveru.
    `sudo a2enmod headers`

 `default-ssl.conf` Adjustments

```
<IfModule mod_ssl.c>
  <VirtualHost _default_:443>
    ...
    ...
    ...
    # Certificate Authority (CA):
    SSLCACertificatePath /etc/ssl/certs/
    SSLCACertificateFile /etc/apache2/ssl.crt/ca-bundle.crt

    # SSL Cipher Suite:
    SSLCipherSuite HIGH:!aNULL:!MD5
    SSLProtocol all -SSLv2 -SSLv3
    SSLHonorCipherOrder on

    <Directory /var/www/html>
      Options Info FollowSymLinks
      AllowOverride All
      Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
  </VirtualHost>
</IfModule>

```

- Modul `userdir` v Apache2 umožňuje uživatelům hostovat webové stránky přímo z jejich domovských adresářů. To je velmi užitečné pro situace, kde chcete umožnit individuálním uživatelům na jednom serveru spravovat vlastní webový obsah bez potřeby zasahovat do hlavních webových adresářů serveru.
Jak modul `userdir` funguje:
- Když je tento modul povolen, Apache automaticky vyhledává webové stránky v podadresáři `public_html` v domovském adresáři každého uživatele. Například, pokud uživatel s jménem `jan` chce hostovat svou webovou stránku, umístí své HTML soubory do `~/jan/public_html`, a tyto stránky budou dostupné na URL adrese `http://<server>/~jan/`.
- `/etc/apache2/mods-enabled/userdir.conf`.



### Firewall


```bash
#!/bin/bash
# Skript pro nastavení firewallu systému

# Nastavení defaultních politik pro INPUT, OUTPUT a FORWARD
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Povolení SSH přístupu (port 22/tcp) pouze na rozhraní pro Host-only network (enp0s8)
iptables -A INPUT -i enp0s8 -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -o enp0s8 -p tcp --sport 22 -j ACCEPT

# Povolení NFS (port 2049 tcp/udp) pouze na rozhraní pro Host-only network (enp0s8)
iptables -A INPUT -i enp0s8 -p tcp --dport 2049 -j ACCEPT
iptables -A INPUT -i enp0s8 -p udp --dport 2049 -j ACCEPT
iptables -A OUTPUT -o enp0s8 -p tcp --sport 2049 -j ACCEPT
iptables -A OUTPUT -o enp0s8 -p udp --sport 2049 -j ACCEPT

# Povolení HTTP (port 80) a HTTPS (port 443) pro všechna rozhraní
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT

# Povolení ICMP provozu na všech rozhraních
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

# Konfigurace Source NAT pro rozhraní připojené k síti NAT (enp0s3)
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# Uložení pravidel, aby přetrvala restarty
iptables-save > /etc/iptables.rules

echo "Firewall pravidla byla nastavena a uložena."

```


#### Vytvoření systemd jednotky pro automatické načítání pravidel

- `mcedit /etc/systemd/system/my_service.service`
- save file
- `systemctl daemon-reload`
```
systemctl enable my_service.service
systemctl start my_service.service
systemctl status my_service.service
```



```bash
echo "[Unit]
Description=Load iptables rules at boot

[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore < /etc/iptables.rules
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/iptables.service

systemctl enable iptables.service
systemctl start iptables.service
```

#### Kroky k demonstraci funkčnosti firewallu:

1. **SSH Přístup**: Otestujte připojení přes SSH pouze z počítačů v "Host-only network" (rozhraní `enp0s8`). Přístup z ostatních sítí by měl být odmítnut.
    
2. **NFS Služba**: Zkontrolujte přístup k NFS na portu 2049 z "Host-only network". NFS by nemělo být dostupné z jiných rozhraní.

```
mount -t nfs <IP-adresa-virtualniho-stroje>:/path/to/shared /mnt
```

    
3. **Web HTTP a HTTPS**: Ověřte, že webové stránky jsou dostupné na portech 80 a 443 z jakékoli sítě.
    
4. **ICMP (Ping)**: Proveďte ping na server z různých sítí a ujistěte se, že ICMP provoz je povolen.
    
5. **NAT Funkcionalita**: Z rozhraní NAT (`enp0s3`) zkontrolujte, že máte přístup na internet a že NAT funguje správně.
- `curl http://google.com`



### DHCP server


```
apt-get update
apt-get install -y isc-dhcp-server
```

Manual steps

```
mcedit /etc/default/isc-dhcp-server
```
edit line
```
INTERFACESv4="enp0s8"
```

```
mcedit /etc/dhcp/dhcpd.conf
```
edit - add at the end of file
```
subnet 192.168.56.0 netmask 255.255.255.0 {
    range 192.168.56.100 192.168.56.199;
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    option routers 192.168.56.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.168.56.255;
    default-lease-time 600;
    max-lease-time 7200;
}
```


```
systemctl restart isc-dhcp-server
systemctl status isc-dhcp-server
```

### NFS server


```
apt-get update
apt-get install -y nfs-kernel-server
```

Manual steps

```
mcedit /etc/exports
```
add line
```
/var/www/html 192.168.56.0/24(rw,sync,no_subtree_check)
```
- `rw`: Umožňuje čtení i zápis na sdílené složce.
- `sync`: Zajišťuje, že odpovědi serveru jsou synchronizovány s diskem pro konzistenci dat.
- `no_subtree_check`: Zlepšuje výkon tím, že eliminuje potřebu kontroly, zda soubory skutečně existují v exportovaném adresáři.

```
systemctl restart nfs-kernel-server
systemctl status nfs-kernel-server

showmount -e # > `/var/www/html`

systemctl enable nfs-kernel-server
```

Test
Na host pc v host only siti, jestli mohu mountnout

```
# Pro linux
mount -t nfs 192.168.56.2:/var/www/html /mnt
touch /mnt/test_file.txt

# Pro windows po instalaci Feature Client NFS
mount \\192.168.56.2\var\www\html Z: # not tested
# Use this
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\192.168.56.2\var\www\html"

# Remove after
Remove-PSDrive -Name Z


```
