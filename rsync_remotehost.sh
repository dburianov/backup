#!/bin/bash

BACKUPGITLOG='/var/log/backupgit.log'

date >> ${BACKUPGITLOG}

# SETUP OPTIONS
export SRCDIR="/opt/900"
export remotehost="ftpbackup@85.25.211.153"
export DESTDIR="/home/ftpbackup/rsync"
export THREADS="10"

# RSYNC DIRECTORY STRUCTURE
/usr/bin/rsync -zr -f"+ */" -f"- *" -e 'ssh -c arcfour' $SRCDIR/ $remotehost:/$DESTDIR/
#/usr/bin/rsync -zr -f"+ */" -f"- *" $SRCDIR/ $DESTDIR/
# FOLLOWING MAYBE FASTER BUT NOT AS FLEXIBLE
# cd $SRCDIR; find . -type d -print0 | cpio -0pdm $DESTDIR/
# FIND ALL FILES AND PASS THEM TO MULTIPLE RSYNC PROCESSES
#cd $SRCDIR; find . ! -type d -print0 | xargs -0 -n1 -P$THREADS -I% rsync -az % $DESTDIR/%
#cd $SRCDIR; find . ! -type d -print0 | xargs -0 -n1 -P$THREADS -I% rsync -az -e 'ssh -c arcfour' % $remotehost:/$DESTDIR/%
cd $SRCDIR; find . ! -type d -print0 | xargs -0 -n1 -P$THREADS -I% rsync -a % $remotehost:/$DESTDIR/%

