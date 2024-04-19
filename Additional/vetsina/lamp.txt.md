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