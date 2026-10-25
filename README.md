# Warsztaty initramfs

## Przygotowanie środowiska pracy

**BYOL** (Bring Your Own Laptop/Linux)

Zainstalować lokalnie (lub na zdalnym serwerze):
- `qemu-system-x86`, `qemu-utils`
- `docker-buildx`, `docker.io`
- VirtualBox (lub inną wirtualizację, np. KVM + virt-manager)

## Ćwiczenia

### 1. VM z Debianem

#### przygotowanie

- [ ] Pobrać mini.iso:  
  <https://ftp.debian.org/debian/dists/trixie/main/installer-amd64/current/images/netboot/mini.iso>
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

### 2. Własny initramfs *from scratch*

- [ ] Zbudować trywialny initramfs (hello world)
- [ ] Uruchomić w `qemu`

### 3. Initramfs z wbudowanym rootfs (LiveCD)

- [ ] Zbudować initramfs z wbudowanym rootfs (Ubuntu lub Debian)
- [ ] Uruchomić w `qemu`
- [ ] Przerobić tar na squashfs
- [ ] Uruchomić w `qemu`

### 4. ISO

- [ ] Zbudować bootowalne ISO z naszym initramfs
- [ ] Uruchomić w VirtualBox lub `qemu`

### 5. UKI

- [ ] Zbudować UKI z naszym initramfs i kernelem
- [ ] Zbudować obraz dysku z partycją ESP
- [ ] Przekonwertować obraz na format VDI
- [ ] Przetestować w VirtualBox
