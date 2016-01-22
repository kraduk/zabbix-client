#!/bin/sh

case `uname -s` in
SunOS)
 echo -e   "############# System overview ###########\n\n"
 prtdiag
 echo -e   "\n\n"
 prtconf 2>/dev/null | head -2 | awk '/^Memory/ { print $(NF-1), $NF}'
 smbios -t 16 | grep "Max.*Capacity"
 echo -e   "\n\n\n######### zpool info ######\n\n"
 zpool status
 echo -e   "\n\n\n######### drive info ######\n\n"
 egrep -i "^(da|ad|mfid|LSI)" /var/run/dmesg.boot 
;;

Linux)
 dmidecode -s processor-version 
 dmidecode -s processor-version 4 | grep Version 
 dmidecode -t 16 | grep "Max.*Capacity" 
 echo -e   "\n####### Memory slots #######\n\n"
 dmidecode -t 17 | grep Size  
 echo -e   "\n\n\n######### PCI info ######\n\n"
 lspci
 echo -e   "\n\n\n######### USB info ######\n\n"
 lsusb
 echo -e   "\n\n\n######### partition info ######\n\n"
 fdisk -l
 echo -e   "\n\n\n######### drive info ######\n\n"
 egrep -i "^(da|ad|mfid|LSI)" /var/run/dmesg.boot 

;;

FreeBSD)
 dmidecode -s processor-version 
 dmidecode -t 16 | awk '/Max.*Capacity/ {print $1,$2,$3i,$4} '
 echo -e   "\n####### Memory slots #######\n\n"
 dmidecode -t 17 | awk '/Size/ {print "Slot " $1,$2,$3i,$4} '
 echo -e   "\n\n\n######### PCI  info ######\n\n"
 pciconf -lv
 echo -e   "\n\n\n######### USB info ######\n\n"
 usbdevs 2>/dev/null
 usbconfig 2>/dev/null
 echo -e   "\n\n\n######### partition info ######\n\n"
 if ( uname -r | grep "^[34567]" > /dev/null ) ; then
  ls /dev/  | egrep "^(da|ad|mfid)[0-9]+s[0-9]+$" | 
        while read a
         do 
          bsdlabel /dev/$a
         done
 else
   gpart show
 fi
 echo -e   "\n\n\n######### drive info ######\n\n"
 egrep -i "^(da|ad|mfid|LSI)" /var/run/dmesg.boot 
;;
esac

 df -hi
 echo -e   "\n\n\n######### mounted drives in fstab format ######\n\n"
 mount -p 2>/dev/null || cat /proc/mounts 
 echo -e   "\n\n\n######### /etc/(v)*fstab ######\n\n"
 cat /etc/*fstab


