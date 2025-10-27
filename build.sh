#!/usr/bin/env bash
set -euo pipefail

# ========= 0) 基础设置 =========
JOBS="$(nproc)"
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"   # 脚本所在目录
OPENWRT_BRANCH="openwrt-23.05"
REPO_URL="https://github.com/openwrt/openwrt"
BUILD_USER="builder"

# ========= 1) 用 root/sudo 安装系统依赖（仅这一步用 sudo）=========
sudo apt update
sudo apt install -y build-essential clang flex bison g++ gawk \
  gcc-multilib g++-multilib gettext git libncurses5-dev libssl-dev \
  python3-setuptools rsync swig unzip zlib1g-dev file wget

# ========= 2) 确保存在 builder 用户（若已有会跳过）=========
if ! id -u "${BUILD_USER}" >/dev/null 2>&1; then
  sudo useradd -m "${BUILD_USER}"
  echo "=== 已创建用户 ${BUILD_USER}（未授予 sudo）。如需 sudo 自行添加到组 ==="
fi

# ========= 3) 以 builder 身份执行后续所有编译相关步骤 =========
sudo -u "${BUILD_USER}" -H bash -lc "
  set -euo pipefail
  echo '=== 切换到 ${BUILD_USER}，开始准备源码 ==='
  cd ~
  # 3.1 克隆源码（若目录已存在则跳过克隆）
  if [ ! -d openwrt ]; then
    git clone '${REPO_URL}' -b '${OPENWRT_BRANCH}' openwrt
  fi

  # 3.2 放置配置、执行自定义脚本与补丁（使用绝对路径访问原脚本所在目录）
  cp '${BASE_DIR}/config/e8820s-official-openwrt-latest.config' ~/openwrt/.config

  cd ~/openwrt

  chmod a+x '${BASE_DIR}/script/diy-part1.sh'
  chmod a+x '${BASE_DIR}/script/diy-part2.sh'
  '${BASE_DIR}/script/diy-part1.sh'
  '${BASE_DIR}/script/diy-part2.sh'

  # 提醒：你的命令里用的是 -p0001（等价于 -p1）
  patch -p1 < '${BASE_DIR}/patch/0001-ZTE8820S.patch'

  # 3.3 feeds
  ./scripts/feeds clean
  ./scripts/feeds update -a
  ./scripts/feeds install -a

  # 3.4 配置与下载源码包
  make defconfig
  make download -j'${JOBS}'
  find dl -size -1024c -exec ls -l {} \\;
  find dl -size -1024c -exec rm -f {} \\;

  # 3.5 编译（先 toolchain，再全编）
  make toolchain/clean
  make toolchain/install -j'${JOBS}' || make toolchain/install -j1 V=sc
  make -j'${JOBS}' || make -j1 || make -j1 V=s
"

echo "=== 全部步骤完成（编译在 builder 用户下完成）==="
