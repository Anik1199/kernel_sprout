#!/bin/bash
#
# Copyright © 2015, Anik Khan "Anik1199" <anik9280@gmail.com> 
#
# Custom Build Script For One Kernel
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#

# Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

# Resources
THREAD="-j8"
KERNEL="zImage"
DEFCONFIG="sprout_defconfig"

# Kernel Details
BASE_ONE_VER="One_kernel"
VER="-1.2"
ONE_VER="$BASE_ONE_VER$VER"

# Vars
export CROSS_COMPILE="${HOME}/kernel/Toolchain/bin/arm-eabi-"
export LOCALVERSION=-`echo $ONE_VER`
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="Anik"
export KBUILD_BUILD_HOST="Phoenix"

# Paths
HOME="/android/personal/anik"
KERNEL_DIR=`pwd`
REPACK_DIR="${HOME}/kernel/One_kernel"
ZIP_MOVE="${HOME}/kernel/release/One_kernel"
ZIMAGE_DIR="${HOME}/kernel/kernel_sprout/arch/arm/boot"
UPLOAD_FOLDER="${HOME}/kernel/upload/One_kernel"

echo -e "${green}"
echo "Script For Building One Kernel:"
echo
echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$ONE_VER"; echo -e "${restore}";

echo -e "${green}"
echo "-----------------"
echo "Making One Kernel:"
echo "-----------------"
echo -e "${restore}"

DATE_START=$(date +"%s")

# Clean
echo -e "${green}"
echo
echo "[..........Cleaning up..........]"
echo
echo -e "${restore}"

rm -rf $REPACK_DIR/tools/zImage
rm -rf $ZIMAGE_DIR/$KERNEL
make clean && make mrproper

# Build
echo -e "${green}"
echo
echo "[....Building `echo $ONE_VER`....]"
echo
echo -e "${restore}"

make $DEFCONFIG
make $THREAD
cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/tools

# Make ZIP
echo -e "${green}"
echo
echo "[....Make `echo $ONE_VER`.zip....]"
echo
echo -e "${restore}"

cd $REPACK_DIR
zip -9 -r `echo $ONE_VER`.zip .
mv  `echo $ONE_VER`.zip $ZIP_MOVE
cd $KERNEL_DIR

# Move
echo -e "${green}"
echo
echo "[.....Moving `echo $ONE_VER`.....]"
echo
echo -e "${restore}"
cd $ZIP_MOVE
cp -vr  `echo $ONE_VER`.zip $UPLOAD_FOLDER
cd $KERNEL_DIR

# Upload
echo -e "${green}"
echo
echo "[.....Uploading `echo $ONE_VER`.zip.....]"
echo
echo -e "${restore}"
cd $UPLOAD_FOLDER
. upload.sh
cd $KERNEL_DIR

# Finalize
echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
