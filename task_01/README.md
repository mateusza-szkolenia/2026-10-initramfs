# Instalacja Debiana na VM

Parametry VM:
- 1 CPU
- min. 1GB RAM
- min. 10GB HDD
- UEFI lub BIOS
- **sieć: bridge z głównym interfejsem**

<https://ftp.debian.org/debian/dists/trixie/main/installer-amd64/current/images/netboot/mini.iso>

## Instalacja dropbear:

```
# apt-get install dropbear-initramfs mc
```

## Konfiuracja dropbear:

### `/etc/dropbear/initramfs/dropbear.conf`

```
DROPBEAR_OPTIONS="-p 2022"
```

### `/etc/dropbear/initramfs/authorized\_keys`

Wrzucamy klucz publiczny, poprawiamy `chmod`


## Przebudowa initramfs

(Za każdym razem po zrobieniu zmian)

```
# update-initramfs -k all -u
```

## Konfiguracja ntfy

### `/etc/initramfs-tools/conf.d/ntfy`:

```
NTFYSH_TOPIC=jesien_linuksowa_2026
NTFYSH_HOSTNAME=jesien01-mateusz

export NTFYSH_TOPIC
export NTFYSH_HOSTNAME
```

### `/etc/initramfs-tools/scripts/init-premount`

```
#!/bin/sh

test "$1" = "prereqs" && echo udev && exit 0

(
  attempts=10
  while [ "$attempts" -gt 0 ]; do
    wget -q -T 5 -O /dev/null \
      --post-data="$(uname -r)" \
      --header="Title: ${NTFYSH_HOSTNAME}: dropbear ready" \
      --header='Tags: teddy_bear' \
      "http://ntfy.sh/${NTFYSH_TOPIC}" && break

    attempts=$((attempts - 1))
    [ "$attempts" -gt 0 ] && sleep 5
  done
) &
```
