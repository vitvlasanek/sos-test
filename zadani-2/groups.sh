#!/bin/bash
group_name="studenti"
groupadd $group_name
mkdir /$group_name
chmod 770 /$group_name
chown root:$group_name /$group_name
umask 002
users=$( awk -F ':' '{print $1}' /etc/passwd | grep user -m 10)
for user in $users; do
  sudo usermod -aG $group_name $user
done