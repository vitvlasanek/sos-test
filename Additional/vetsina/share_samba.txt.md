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




