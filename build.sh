#!/usr/bin/env bash

sudo apt update
sudo apt install build-essential clang flex bison g++ gawk \
  gcc-multilib g++-multilib gettext git libncurses5-dev libssl-dev \
  python3-setuptools rsync swig unzip zlib1g-dev file wget

git clone https://github.com/openwrt/openwrt -b openwrt-23.05 openwrt

cp ./config/e8820s-official-openwrt-latest.config openwrt/.config
cd openwrt

chmod a+x ../script/diy-part1.sh
chmod a+x ../script/diy-part2.sh
../script/diy-part1.sh
../script/diy-part2.sh
patch -p0001 < ../patch/0001-ZTE8820S.patch
make defconfig
make download -j$(nproc)
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;

make toolchain/clean
make toolchain/install -j$(nproc) || make toolchain/install -j1 V=sc
make -j$(nproc) || make -j1 || make -j1 V=s
