#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

echo "src-git smartdns https://github.com/pymumu/openwrt-smartdns;master" >> feeds.conf.default
echo "src-git lucismartdns https://github.com/pymumu/luci-app-smartdns.git;master" >> feeds.conf.default
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall;main" >> feeds.conf.default
echo "src-git passwallpackages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> feeds.conf.default

# Add feed sources
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
#sed -i '$a src-git diy https://github.com/CCnut/feed-netkeeper.git;LUCI-LUA-UCITRACK' feeds.conf.default
