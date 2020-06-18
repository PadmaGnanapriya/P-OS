echo " We compile all files and create new iso files for each versions."

cd version_1
sudo sh run_1.sh
cd ..
cd version_2
sudo sh run_2.sh


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
echo '     qemu-system-x86_64 -cdrom version_1/disk_images/pos_2.iso'



qemu-system-x86_64 -cdrom version_2/disk_images/pos_2.iso

read Padma