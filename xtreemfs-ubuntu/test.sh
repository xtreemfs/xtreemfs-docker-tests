#!/bin/bash

#start xtreemfs servers
/etc/init.d/xtreemfs-dir start
/etc/init.d/xtreemfs-mrc start
/etc/init.d/xtreemfs-osd start

#create and mount volume
mkfs.xtreemfs localhost/test-volume
mkdir test_volume
echo "created directory"
mount.xtreemfs localhost/test-volume test_volume
echo "mounted test volume"
#write
dd if=/dev/urandom of=test_volume/test.txt bs=4k count=256
echo "written some random data to test volume"

#unmount volume
umount.xtreemfs test_volume
echo "unmounted test volume"

#stop xtreemfs servers
/etc/init.d/xtreemfs-dir stop
/etc/init.d/xtreemfs-mrc stop
/etc/init.d/xtreemfs-osd stop
