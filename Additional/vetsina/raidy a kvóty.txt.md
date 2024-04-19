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