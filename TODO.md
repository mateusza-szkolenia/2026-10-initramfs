# Warsztaty initramfs

## Przygotowanie

Zainstalować lokalnie (lub na zdalnym serwerze):
- `qemu-system-x86`, `qemu-utils`
- `docker-buildx`, `docker.io`
- VirtualBox (lub inną wirtualizację, np. KVM + virt-manager)

## Plan

### VM z Debianem

#### przygotowanie

- [ ] Pobrać mini.iso: <https://ftp.debian.org/debian/dists/trixie/main/installer-amd64/current/images/netboot/mini.iso>
- [ ] Zainstalować Debiana z pełną enkrypcją.
- [ ] Skonifigurować sieć z bridge.
- [ ] Zainstalować i skonfigurować SSH.

#### zadania
- [ ] Zainstalować i skonfigurować dropbear.
- [ ] Przetestować dropbear (reboot) 
- [ ] Stworzyć hook instalujący konfigurację ntfy.sh
- [ ] Stworzyć skrypt wysyłający powiadomienie o starcie systemu przez ntfy.sh
- [ ] Przetestować notyfikację (reboot)

#### dodatkowe (dla posiadających swój serwer wireguard)

- [ ] Stworzyć hook instalujący wireguard + konfigurację
- [ ] Stworzyć skrypty uruchamiające i zatrzymujące wireguarda
- [ ] Przetestować dropbear przez wireguard (reboot)

### Najprostszy własny initramfs

busybox + hello world


### Initramfs z wbudowanym rootfs
