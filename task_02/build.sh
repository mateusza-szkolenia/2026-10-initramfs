#!/bin/bash

pushd /build

mkdir -p output
rm -rf tmp
mkdir -p tmp

pushd tmp
mkdir -p initramfs

pushd initramfs
mkdir -p bin

cp /bin/busybox bin
ln -s busybox bin/sh

cat > init << EOF
#!/bin/sh

echo "Welcome to myinitramfs!"
sh
EOF

chmod +x init

find . | cpio --owner=0:0 -H newc -o > "../../output/initrd"

popd # initramfs
popd # tmp

KERNEL=(/boot/vmlinuz-*)
cp "$KERNEL" ./output/kernel

popd # /build
