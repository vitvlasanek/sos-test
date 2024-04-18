# RAID

## Vzorové zadání

Do virtualizovaného PC přidejte další čtyři pevné disky o kapacitě alespoň 200MB. Z těchto disků vytvořte v systému RAID, který bude odolný proti výpadku jednoho disku. Na tomto RAID poli vytvořte jeden oddíl a ten naformátujte souborovým systémem ext4. Nakonfigurujte systém tak, aby se oddíl vytvořený na RAID poli připojoval jako složka /home po startu systému. Využijte standardní systémovou konfiguraci, pro identifikaci raidu použijte UUID.

## Postup

1.  Vypsání disků

    ```bash
    lsblk
    ```

1.  instalace mdadm

    - pokud není nainstalován pak nainstalovat (se `sudo` nebo `su -`)

      ```sh
      apt install mdadm
      ```

1.  test

    - example pro 3 disky

      ```sh
      mdadm --examine /dev/sdb /dev/sdc /dev/sdd
      ```

1.  vytvoření raidu

    - help

      ```sh
      man mdadm --create -h
      ```

    - Command pro vytvoření RAIDU

      ```sh
      mdadm --create <nazev> --level=<level> --raid-devices=<drives> --spare-devices=<spares> [/dev/<drive1> /dev/<drive2> ...]
      ```

    - example RAID1

      ```sh
      mdadm --create /dev/md0 --level=5 --raid-devices=4 --spare-devices=1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
      ```

    - check
      ```sh
      mdadm --status /dev/md0
      ```

1.  format RAIDu

    - Vytvořte oddíl na RAID poli:

      ```sh
      sudo fdisk /dev/md0
      ```

    - pomocí commandu se naformátujte raid `/dev/md0` na **ext4** (nahradit název pokud je jiný)

      ```sh
      mkfs.ext4 /dev/md0
      ```

1.  přidat ve `/etc/fstab`

    - pomocí editoru nano nebo jiný (vi, mcedit ...)

      ```sh
      nano /etc/fstab
      ```
