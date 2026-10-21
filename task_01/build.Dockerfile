FROM debian:13

WORKDIR /build

RUN apt-get update && apt-get install --yes --no-install-recommends \
    bash \
    busybox-static \
    cpio \
    linux-image-amd64

RUN rm -rf /var/lib/apt/lists/*

CMD bash
