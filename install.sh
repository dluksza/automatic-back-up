#!/bin/sh
# Filename:      install.sh
# Author:        Dariusz Luksza <dariusz@luksza.org>
# Bug-Reports:   https://github.com/dluksza/automatic-back-up/issues
# License:       This file is licensed under the GPL v2.

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

BLKID=`which blkid 2> /dev/null`
if [[ $? -ne 0 ]]; then
	echo "Cannot find blkid command" 1>&2
	exit 1
fi

echo -n "Which device should be used as back up destination (eg. /dev/sdb1) ? "
read backup_dev
if [ ! -e $backup_dev ] || [ ! -b $backup_dev ]; then
	echo "File $backup_dev doesn't exist or it isn't block device"
	exit 1
fi

echo -n "Which user should be informed about started back up process ? "
read user_name
if [ -z "$user_name" ]; then
	echo "User name cannot be empty"
	exit 1
fi

UUID=`$BLKID $backup_dev | sed -e 's/.*UUID="\([0-9a-z-]\{36\}\)".*/\1/'`

echo -n "Writing files ..."
cat ./99-backup.rules | sed -e "s/#UUID#/$UUID/" > /etc/udev/rules.d/99-backup.rules
cat ./backup | sed -e "s/#user_name#/$user_name/" > /lib/udev/backup
echo " DONE."

echo -n "Reloading udev rules ..."
udevadm control --reload-rules
echo " DONE."
