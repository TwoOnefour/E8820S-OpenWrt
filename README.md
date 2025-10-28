## 描述
这是一个中兴ZTE-E8820S自用固件仓库，官方源码采用23.05版本，由于24.10版本有奇怪的重启bug，请见[#issues/19164](https://github.com/openwrt/openwrt/issues/19164)

**但其实openwrt-23.05甚至老毛子或者immortalwrt，我也遇到过很多次断电后重启以后丢wifi的情况，感觉是openwrt固件写的有问题**

## 固件软件包
配置为
- zerotier
- usb
- mt76xx wifi
- passwall (shadowsocks-rust,ssr,ss,xray)
- smartdns
- eip93 (硬件加速）
- kmod-cryptodev (Cryptographic Hardware Accelerators in user level)
- kmod-crypto-* (frequenctly used crypto kmod)
- openssh-sftp-server

## 跑分（单位为MiB/s)

### 纯软件跑分
参数如下
> openssl speed -evp <algorithm>

| Block Size (bytes) | ChaCha20 |   md5 | ChaCha20-Poly1305 | AES-128-CTR |
| -----------------: | -------: | ----: | ----------------: | ----------: |
|                 16 |    14.53 |  1.72 |              9.56 |        9.54 |
|                 64 |    23.42 |  6.17 |             16.10 |       11.57 |
|                256 |    27.15 | 20.45 |             18.72 |       12.11 |
|               1024 |    27.75 | 45.70 |             19.55 |       12.30 |
|               8192 |    28.53 | 72.90 |             19.77 |       12.32 |
|              16384 |    28.58 | 75.44 |             19.83 |       12.34 |

由于mt7621只有ctr的加速，会回落chacha20-poly, 若使用reality等tls类协议，单线程理论上限就是19.83MiB/s上下浮动

### 硬件加速跑分

> openssl speed -elapsed -engine devcrypto <algorithm>

| Block Size (bytes) | ChaCha20-Poly1305      | AES-128-CTR        | AES-128-CTR(硬件加速) |
| -----------------: | ---------------------: | ------------------:| ----------: |
|                 16 |              9.56      |        9.54        |       39.04 |
|                 64 |             16.10      |       11.57        |       52.04 |
|                256 |             18.72      |       12.11        |       91.35 |
|               1024 |             19.55      |       12.30        |       16.80 |
|               8192 |             19.77      |       12.32        |       46.03 |
|              16384 |             19.83      |       12.34        |       54.14 |

若跑专线，建议使用纯ChaCha20或者ctr，否则用reality

## 预览
<img width="1444" height="877" alt="image" src="https://github.com/user-attachments/assets/7a80c0c8-303b-49cf-a001-952f426b76ee" />
