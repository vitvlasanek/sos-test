# Konfigurace sítě

## Vzorové zadání

- Nakonfigurujte systém tak, aby síťová karta na rozhraní NAT dostávala IP adresu prostřednictvím protokolu DHCP (z Virtualboxu) a druhá karta bude mít IP adresu nastavenou staticky. Pro konfiguraci obou rozhraní využijte standardní metody používané v distribuci Debian.

## Postup

1. Přidat síťovou kartu ve virtualboxu

   - `Nastavení/Síť/Karta2`
   - povolit
   - vzbrat `host only network`
   - **OK** - zapnout vpc

1. výpis interfaců

   ```bash
   ip a
   ```

1. Nastavení automatického DHCP pro **NAT**

   - v souboru `/etc/network/interfaces` přidat řádky

     ```bash
     auto enp0s8
     iface enp0s8 inet dhcp
     ```

   - `auto <iface>`: Tento řádek informuje systém, že rozhraní enp0s8 má být automaticky aktivováno při spuštění systému.
   - `iface <iface> inet dhcp`:

     - `iface`: Toto klíčové slovo označuje začátek bloku konfigurace pro dané síťové rozhraní..
     - `inet`: Určuje, že se jedná o rozhraní IPv4.
     - `dhcp`: Tento řádek informuje systém, aby pro konfiguraci IP adresy a dalších síťových nastavení použil protokol DHCP. DHCP server automaticky přidělí IP adresu, masku podsíťě, výchozí bránu a další informace o síti.

1. Nastavení statické IP adresy pro **Host-only network**

   - v souboru `/etc/network/interfaces` přidat řádky

     ```bash
     auto eth0
     iface eth0 inet static

     address 192.168.1.100 # Nahraďte zadanou IP adresou
     netmask 255.255.255.0
     gateway 192.168.1.1 # Nahraďte zadanou bránou
     ```

1. restart

   ```bash
   ifdown enp0s8
   ifup enp0s8
   ```

   nebo:

   ```bash
   sudo systemctl restart
   ```
