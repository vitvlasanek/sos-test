# Quoty

## Vzorové zadání

Vytvořte spustitelný skript v jazyce bash, který do systému přidá 100 uživatelských účtů. Loginy budou user00 až user99, interpret pro všechny uživatele bude /bin/bash a uživatelům se vytvoří domovský adresář ve složce /home. Jako parametr skriptu bude možné zadat defaultní heslo pro vytvářené uživatele. Skript otestuje zdali je heslo delší než 5 znaků. V případě, že nebude zadaný parametr, bude heslo prázdné. Všem uživatelů definujte diskové kvóty.

## Postup

1. nainstalovat quoty a openssl

```sh
apt install openssl
```

```sh
apt install quota
```

1. vytváření uživatelů ve skriptu

- pomocí useradd

  ```sh
  useradd -m -s /bin/bash -c "Bezny Franta Uzivatel" -p $(echo "P4sSw0rD" | openssl passwd -1 -stdin) franta
  ```

- nastavení hesel
  ```sh
  passwd -h
  ```

2. quoty

```sh
mount -o remount,usrquota,grpquota /home    #toto řešení funguje jen do restartu, korektně je nutné editovat /etc/fstab
service quota start                         #nezapomeňte službu povolit, ať se zavádí po startu
quotacheck /dev/sdb1
quotaon /dev/sdb1
edquota franta
```

- kopírování kvót

```sh
edquota -p uživatel-prototyp jiny-uživatel
```

# Zobrazení
