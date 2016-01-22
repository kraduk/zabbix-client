#!/bin/bash

grep -hE "^\s+(kernel|linux16)" /boot/grub/menu.lst /boot/grub2/grub.cfg 2>/dev/null  | 
	while read a b c
		do 
			echo $b
		done | 
	sed -e "s#/vmlinuz-##" | 
	while read a
		do 
			grep -Eq "initrd.*/init.*$a" /boot/grub/menu.lst /boot/grub2/grub.cfg 2>/dev/null || 
			echo $a missing initrd
		 done

