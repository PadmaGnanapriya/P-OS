cd version_1
sudo sh run_1.sh


cd ..
echo ' '
echo '>>> For preview in QEMU machine emulator & virtualizer, type on the terminal'
echo '>>> For version_1 :- '
echo '     qemu-system-x86_64 -cdrom version_1/disk_images/pos_1.iso'



qemu-system-x86_64 -cdrom version_1/disk_images/pos_1.iso

read Padma