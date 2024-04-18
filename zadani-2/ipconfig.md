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

   - v souboru `/etc/network/interfaces` přidat nebo upravit řádky ({iface} nahradit)

     - **pozor, stejný interface se nesmí opakovat**

     ```bash
     auto {iface}
     iface {iface} inet dhcp
     ```

   - `auto {iface}`: Tento řádek informuje systém, že rozhraní enp0s8 má být automaticky aktivováno při spuštění systému.
   - `iface {iface} inet dhcp`:

     - `iface`: Toto klíčové slovo označuje začátek bloku konfigurace pro dané síťové rozhraní..
     - `inet`: Určuje, že se jedná o rozhraní IPv4.
     - `dhcp`: Tento řádek informuje systém, aby pro konfiguraci IP adresy a dalších síťových nastavení použil protokol DHCP. DHCP server automaticky přidělí IP adresu, masku podsíťě, výchozí bránu a další informace o síti.

1. Nastavení statické IP adresy pro **Host-only network**

   - v souboru `/etc/network/interfaces` přidat řádky

     - **pozor, stejný interface se nesmí opakovat**

     ```bash
     auto {iface}
     iface {iface} inet static

     address 192.168.1.100 # Nahraďte zadanou IP adresou
     netmask 255.255.255.0
     # gateway 192.168.1.1 # Nahraďte zadanou bránou ... pravděpodobně nebude
     ```

1. Restart

   - interface

     ```bash
     ifdown {iface}
     ifup {iface}
     ```

   nebo:

   - služby

     ```bash
     sudo systemctl restart networking
     ```

1. Ověření

   ```bash
   ip a
   ```

   ```bash
   ip -c -br link show
   ```
