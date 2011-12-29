automatic back up
================

Simple udev configuration that automatically mounts given (by UUID) device and starts rsync back up process

Install
=======

First of all you need to get UUID of your back up device/partition:

```
blkid /dev/sdXY
```

Then replace my UUID in 99-backup.rules with one given by blkid command.
In backup file set proper value for USER variable (it should be your UNIX user name)
Finally copy files into proper places and set execution bit to backup script:

```
# cp 99-backup.rules /etc/udev/rules.d/
# cp backup /lib/udev/
# chmod +x /lib/udev/backup
```

Last thing you need to do is to reload udev rules by

```
# udevadm control --reload-rules
```

For Awesome WM users
====================

If you are using [Awesome WM](http://awesome.naquadah.org/) to see notifications you'll need to add [naughty](http://awesome.naquadah.org/wiki/Naughty) library into yours rc.lua

```
require('naughty')
```
