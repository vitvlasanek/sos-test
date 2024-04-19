Sources:
https://stackoverflow.com/
https://unix.stackexchange.com/
https://askubuntu.com/
https://serverfault.com/tour
https://tldp.org/
man cmd

 

# Linux Command Cheat Sheet - Volume I
## Basic Command Line Operations
### cat, cut, grep, sort, tr, echo

```bash
# Display content of a file
cat file.txt
  
# Cut out selected portions of each line of a file
cut -d':' -f1 /etc/passwd
  
# Search for a pattern in a file
grep 'pattern' file.txt
  
# Sort lines in a file
sort file.txt
  
# Translate or delete characters
tr 'a-z' 'A-Z' < input.txt > output.txt
  
# Display a line of text
echo "Hello, world"
```
### Redirection and Piping

```bash
# Redirect output to a file, overwriting the file
command > file.txt
  
# Append output to a file
command >> file.txt
  
# Pipe the output of one command to another command
command1 | command2
```
## Scripting with BASH
### Control Structures
```bash
# If statement
if [ condition ]; then
    echo "True"
else
    echo "False"
fi
  
# For loop
for i in {1..5}; do
    echo "Number $i"
done
  
# While loop
while [ condition ]; do
    command
done
  
# Until loop
until [ condition ]; do
    command
done
```

### Special Variables

```bash
# Script name
echo $0
  
# First, second, third command line argument
echo $1 $2 $3
  
# All positional parameters
echo $@
  
# Number of positional parameters
echo $#
  
# Process ID of the current script
echo $$
```
  
## Systemd and Services
### Creating and Managing Systemd Units

```ini
[Unit]
Description=My Custom Service
After=network.target
  
[Service]
Type=simple
ExecStart=/usr/bin/env python3 /path/to/script.py
  
[Install]
WantedBy=multi-user.target
```
  
### Managing System Services with systemctl

```bash
# Start a service
systemctl start servicename
  
# Enable a service to start at boot
systemctl enable servicename
  
# Check the status of a service
systemctl status servicename
  
# Reload all service units without reboot
systemctl daemon-reload
```
## Networking Tools
### Setting Up Network Interfaces

```bash
# Configure a static IP address
auto eth0
iface eth0 inet static
address 192.168.1.100
netmask 255.255.255.0
gateway 192.168.1.1
  
# Restart network service
systemctl restart networking
```
### iptables Basics

```bash
# Block an IP address
iptables -A INPUT -s 123.123.123.123 -j DROP
  
# Allow HTTP traffic
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

 
# Save iptables rules
iptables-save > /etc/iptables/rules.v4
```
  
## Disk and User Management
### Managing Users and Groups

```bash
# Add a new user
useradd -m -s /bin/bash username
  
# Delete a user
userdel -r username
  
# Add a user to a group
usermod -aG groupname username
```
### Disk Quotas

```bash
# Edit quotas for user
edquota -u username
  
# Turn on quotas for filesystem
quotaon /home
```
## Additional Essential Commands

  

### File Permissions and Ownership

```bash
# Change file permissions
chmod 755 script.sh
  
# Change file owner and group
chown user:group file.txt
```

### System Monitoring and Performance

```bash
# Display CPU and memory usage
top
  
# Show disk usage
df -h
  
# Show free memory
free -m
```
# Linux Command Cheat Sheet - Volume II

## Disk Management and Filesystems

  ### LVM (Logical Volume Management) Commands

```bash
# Create a physical volume
pvcreate /dev/sda1

# Create a volume group
vgcreate vgname /dev/sda1

# Create a logical volume
lvcreate -L 100G -n lvname vgname
  
# Extend a volume group
vgextend vgname /dev/sdb1

# Extend a logical volume
lvextend -L +50G /dev/vgname/lvname
 
# Resize the filesystem on the logical volume
resize2fs /dev/vgname/lvname
```

  

### Managing Partitions and Filesystems

```bash
# List all partitions
fdisk -l

# Interactive partitioning tool
cfdisk /dev/sda

# Format a partition with ext4 filesystem
mkfs.ext4 /dev/sda1

# Automatically mount filesystems on boot
echo "/dev/sda1 /data ext4 defaults 0 2" >> /etc/fstab
```

  

## Advanced Systemd Management
### Creating a Complex Systemd Service File

```ini
[Unit]
Description=Advanced Service
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/mydaemon
ExecReload=/bin/kill -HUP $MAINPID
ExecStop=/bin/kill -KILL $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target
```

  

### Systemd Timers (as a cron alternative)

```ini
[Unit]
Description=Runs script every hour

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
```

  

## Networking and Firewalls
### Advanced Networking Configuration

```bash
# Configure network interface with static IP
echo "auto eth0
iface eth0 inet static
address 192.168.1.100
netmask 255.255.255.0
gateway 192.168.1.1" > /etc/network/interfaces

# Restart network interfaces
systemctl restart networking.service
```

  

### Detailed iptables Usage

```bash
# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
  
# Allow all incoming SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow outgoing DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# NAT configuration
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  
# Save rules
iptables-save > /etc/iptables/rules.v4
```
### Routing and Advanced IP Management

```bash
# Add a new route
ip route add 192.168.2.0/24 via 192.168.1.1
  
# Delete a route
ip route del 192.168.2.0/24
  
# Show routing table
ip route show
```

  ## Additional Essential Commands
### File Permissions and Ownership

```bash
# Change file permissions
chmod 755 script.sh
  
# Change file owner and group
chown user:group file.txt
```

  ### System Monitoring and Performance

```bash
# Display CPU and memory usage
top
  
# Show disk usage
df -h
  
# Show free memory
free -m
```