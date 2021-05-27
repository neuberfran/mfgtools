#!/bin/bash

# partition size in MB
BOOTLOAD_RESERVE=8
BOOT_ROM_SIZE=16
SYSTEM_ROM_SIZE=512
ODM_A_SIZE=512
ODM_B_SIZE=512
BOOT_ROM_B_SIZE=16
SYSTEM_ROM_B_SIZE=512
MISC_SIZE=1
FBMISC_SIZE=1

help() {

bn=`basename $0`
cat << EOF
usage $bn <option> device_node

options:
  -h				displays this help message
  -s				only get partition size
  -np 				not partition.
  -f soc_name			flash android image.
EOF

}

# parse command line
moreoptions=1
node="na"
soc_name=""
cal_only=0
flash_images=0
not_partition=0
not_format_fs=0
while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
	case $1 in
	    -h) help; exit ;;
	    -s) cal_only=1 ;;
	    -f) flash_images=1 ;;
	    -np) not_partition=1 ;;
	    -nf) not_format_fs=1 ;;
	    *)  moreoptions=0; node=$1 ;;
	esac
	[ "$moreoptions" = 0 ] && [ $# -gt 1 ] && help && exit
	[ "$moreoptions" = 1 ] && shift
done

if [ ! -e ${node} ]; then
	help
	exit
fi

sfdisk_version=`sfdisk -v | awk '{print $4}' | awk -F '.' '{print $2}'`
if [ $sfdisk_version -ge "26" ]; then
    opt_unit=""
    unit_mb="M"
else
    opt_unit="-uM"
    unit_mb=""
fi

# call sfdisk to create partition table
# get total card size
seprate=40
total_size=`sfdisk -s ${node}`
total_size=`expr ${total_size} / 1024`
boot_rom_sizeb=`expr ${BOOT_ROM_SIZE} + ${BOOTLOAD_RESERVE}`
extend_size=`expr ${SYSTEM_ROM_SIZE} + ${ODM_B_SIZE} + ${BOOT_ROM_B_SIZE} + ${SYSTEM_ROM_B_SIZE} + ${MISC_SIZE} + ${FBMISC_SIZE} + ${seprate}`
data_size=`expr ${total_size} - ${boot_rom_sizeb} - ${ODM_A_SIZE} - ${extend_size}`

# create partitions
if [ "${cal_only}" -eq "1" ]; then
cat << EOF
BOOT   : ${boot_rom_sizeb}MB
ODM_A: ${ODM_A_SIZE}MB
SYSTEM : ${SYSTEM_ROM_SIZE}MB
ODM_B  : ${ODM_B_SIZE}MB
DATA   : ${data_size}MB
BOOT_B   : ${SYSTEM_ROM_B_SIZE}MB
SYSTEM_B : ${BOOT_ROM_B_SIZE}MB
SLOTMETA : ${MISC_SIZE}MB
FBMISC   : ${FBMISC_SIZE}MB 
EOF
exit
fi

function format_android
{
    echo "formating android data partition"
    mkfs.ext4 -b 4096 -m 0 -O ^flex_bg,^uninit_bg ${node}${part}4 -L data
}


# destroy the partition table
dd if=/dev/zero of=${node} bs=1024 count=1

sfdisk --force ${opt_unit}  ${node} << EOF
,${boot_rom_sizeb}${unit_mb},83
,${ODM_A_SIZE}${unit_mb},83
,${extend_size}${unit_mb},5
,${data_size}${unit_mb},83
,${SYSTEM_ROM_SIZE}${unit_mb},83
,${ODM_B_SIZE}${unit_mb},83
,${BOOT_ROM_B_SIZE}${unit_mb},83
,${SYSTEM_ROM_B_SIZE}${unit_mb},83
,${MISC_SIZE}${unit_mb},83
,${FBMISC_SIZE}${unit_mb},83
EOF

# adjust the partition reserve for bootloader.
# if you don't put the uboot on same SYSTEM_B, you can remove the BOOTLOADER_ERSERVE
# to have 8M space.
# the minimal sylinder for some card is 4M, maybe some was 8M
# just 8M for some big eMMC 's sylinder
sfdisk --force ${opt_unit} ${node} -N1 << EOF
${BOOTLOAD_RESERVE}${unit_mb},${BOOT_ROM_SIZE}${unit_mb},83
EOF

# format the SDCARD/DATA partition
part=""
echo ${node} | grep mmcblk > /dev/null
if [ "$?" -eq "0" ]; then
	part="p"
fi

format_android


# For MFGTool Notes:
# MFGTool use mksdcard-android.tar store this script
# if you want change it.
# do following:
#   tar xf mksdcard-android.sh.tar
#   vi mksdcard-android.sh 
#   [ edit want you want to change ]
#   rm mksdcard-android.sh.tar; tar cf mksdcard-android.sh.tar mksdcard-android.sh
