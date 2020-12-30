#!/bin/bash
# shellcheck disable=SC2046

# REPLACE ME: Absolute path where the root of the toolchain is located
TOOLCHAIN_PATH="/home/pazos/Escritorio/SM-T500/toolchain"

# Relative paths for gcc & llvm toolchains
CROSS_TC="${TOOLCHAIN_PATH}/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
CLANG_BIN="${TOOLCHAIN_PATH}/llvm-arm-toolchain-ship/8.0/bin/clang"

function checkTC {
    if [ ! -f "$1" ]; then
        echo "File $1 doesn't exist, please check your toolchain path"
        exit 1
    fi
}

if [ ! -d $TOOLCHAIN_PATH ]; then
    echo "Toolchain path doesn't exist"
    exit 1
else
    checkTC "${CROSS_TC}gcc"
    checkTC "$CLANG_BIN"
fi

echo "GCC: ${CROSS_TC}gcc"
echo "CLANG: $CLANG_BIN"

[ -d out ] && rm -rf out
mkdir -v out

make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE="$CROSS_TC" REAL_CC="$CLANG_BIN" CLANG_TRIPLE=aarch64-linux-gnu- vendor/gta4lwifi_eur_open_defconfig
make -j8 -C $(pwd) O=$(pwd)/out ARCH=arm64 CROSS_COMPILE="$CROSS_TC" REAL_CC="$CLANG_BIN" CLANG_TRIPLE=aarch64-linux-gnu-

