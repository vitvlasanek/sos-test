## dhcp

1. Přidat síťovou kartu ve virtualboxu

   - `Nastavení/Síť/Karta2`
   - povolit
   - vzbrat `host only network`
   - **OK** - zapnout vpc

1. výpis interfaců

   ```bash
   auto enp0s8
   iface enp0s8 inet dhcp
   ```

1. nastavení automatického DHCP

- v souboru `/etc/network/interfaces` přidat řádky
  ```bash
  auto enp0s8
  iface enp0s8 inet dhcp
  ```

potom

```bash
ifdown enp0s8
ifup enp0s8
```

# nebo

```bash
sudo systemctl restart
```

networking
