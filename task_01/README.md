# Instalacja Debiana na VM

Parametry VM:
- 1 CPU
- min. 1GB RAM
- min. 10GB HDD
- UEFI lub BIOS
- **sieć: bridge z głównym interfejsem**

<https://ftp.debian.org/debian/dists/trixie/main/installer-amd64/current/images/netboot/mini.iso>

Instalacja dropbear:

```
$ apt-get install dropbear-initramfs mc
```

Konfiuracja dropbear:

## /etc/dropbear/initramfs/dropbear.conf

```
DROPBEAR_OPTIONS="-p 2022"
```

## /etc/dropbear/initramfs/authorized\_keys

Wrzucamy klucz publiczny, poprawiamy `chmod`
