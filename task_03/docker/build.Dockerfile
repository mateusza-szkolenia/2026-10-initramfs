FROM debian:13

WORKDIR /build

RUN apt-get update && apt-get install --yes --no-install-recommends \
    automake \
    bc \
    binutils \
    bison \
    build-essential \
    ca-certificates \
    cpio \
    curl \
    dwarves \
    flex \
    initramfs-tools-core \
    isolinux \
    libelf-dev \
    libssl-dev \
    linux-image-amd64 \
    mmdebstrap \
    mtools \
    parted \
    python3 \
    python3-yaml \
    qemu-utils \
    rsync \
    squashfs-tools \
    syslinux-common \
    systemd-ukify \
    systemd-boot-efi \
    wget \
    xorriso \
    xz-utils \
    zstd

COPY scripts/ scripts/
COPY conf/ conf/

RUN /build/scripts/preinstall-dependencies.sh

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf scripts/ conf/

CMD bash
