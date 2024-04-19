
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
