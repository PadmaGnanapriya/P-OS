
#   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.
#   Read the full article from here: 
#   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f
#   Get full source code here:
#   https://github.com/PadmaGnanapriya/P-OS/

echo " We compile all files and create new iso files for each versions."

cd version_1
sudo sh run_1.sh
cd ..
cd version_2
sudo sh run_2.sh
cd ..
cd version_3
sudo sh run_3.sh

cd ..

sleep 0.5
#clear
echo " We compile all files and create new iso files for each versions."
echo ' '
echo '>>> You have created CD-ROM ISO images successfully.'
echo '>>> For preview in QEMU machine emulator & virtualizer, type on the terminal'
echo '>>> For version_1 :- '
echo '     qemu-system-x86_64 -cdrom version_1/disk_images/pos_1.iso'
echo '>>> For version_2 :- '
echo '     qemu-system-x86_64 -cdrom version_2/disk_images/pos_2.iso'
echo '>>> For version_3 :- '
echo '     qemu-system-x86_64 -cdrom version_3/disk_images/pos_3.iso'
echo ''
echo '->   P-OS is an operating system developed by "Padma Gnanapriya" using Assembly language.'
echo '->   Read the full article from here:' 
echo '->   https://medium.com/@padmaisuru/a-simple-your-own-os-design-implementation-for-reading-hardware-details-e502c49e3d2f'


qemu-system-x86_64 -cdrom version_3/disk_images/pos_3.iso

#To execute all bash commands
read Padma