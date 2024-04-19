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

