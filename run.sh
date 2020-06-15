#!/bin/sh
# type sudo sh run.sh in terminal to execute pos simple Operating system



if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e disk_images/pos.flp ]
then
#----- Creating new POS floppy image...
	mkdosfs -C disk_images/pos.flp 1440 || exit
fi


#----- Assembling bootloader...
cd source/bootload
nasm -O0 -w+orphan-labels -f bin -o bootload.bin bootload.asm || exit


#----- Assembling POS kernel...

cd ..
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..


#----- Assembling programs...





#----- Adding bootloader to floppy image...

dd status=noxfer conv=notrunc if=source/bootload/bootload.bin of=disk_images/pos.flp || exit



########################################
#----- Copying POS kernel and programs...

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat disk_images/pos.flp tmp-loop && cp source/kernel.bin tmp-loop/



sleep 0.2

#----- Unmounting loopback floppy...

umount tmp-loop || exit

rm -rf tmp-loop


#----- Creating CD-ROM ISO image...
######################


rm -f disk_images/pos.iso
mkisofs -quiet -V 'MIKEOS' -input-charset iso8859-1 -o disk_images/pos.iso -b pos.flp disk_images/ || exit

clear
echo '>>> You have created CD-ROM ISO image successfully'
echo '>>> To preview in QEMU machine emulator and virtualizer, type in terminal :-'
echo '     qemu-system-x86_64 -cdrom disk_images/pos.iso'

qemu-system-x86_64 -cdrom disk_images/pos.iso
