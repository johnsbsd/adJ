#!/bin/ksh
#	$OpenBSD: upgrade.sh,v 1.89 2015/12/23 17:51:08 rpe Exp $
#	$NetBSD: upgrade.sh,v 1.2.4.5 1996/08/27 18:15:08 gwr Exp $
#
# Copyright (c) 1997-2015 Todd Miller, Theo de Raadt, Ken Westerback
# Copyright (c) 2015, Robert Peichaer <rpe@openbsd.org>
#
# All rights reserved.
#
# Copyright (c) 1996 The NetBSD Foundation, Inc.
# All rights reserved.
#
# This code is derived from software contributed to The NetBSD Foundation
# by Jason R. Thorpe.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

#	OpenBSD upgrade script.

# install.sub needs to know the MODE.
MODE=upgrade

# include common subroutines and initialization code.
. install.sub

# Have the user confirm that $ROOTDEV is the root filesystem.
get_rootinfo
while :; do
	ask "�Subpartici�n raiz?" $ROOTDEV
	resp=${resp##*/}
	[[ -b /dev/$resp ]] && break
	echo "$resp no es dispositivo por bloques."
done
ROOTDEV=$resp

echo -n "Revisando subpartici�n ra�z (fsck -fp /dev/$ROOTDEV)..."
fsck -fp /dev/$ROOTDEV >/dev/null 2>&1 || { echo "FALL�."; exit; }
echo "Listo."

echo -n "Montando subpartici�n raiz... (mount -o ro /dev/$ROOTDEV /mnt)..."
mount -o ro /dev/$ROOTDEV /mnt || { echo "FAILED."; exit; }
echo "Listo."

for _f in /mnt/etc/{fstab,hosts,myname}; do
	[[ -f $_f ]] || { echo "No $_f!"; exit; }
	cp $_f /tmp/${_f##*/}
done
hostname $(stripcom /tmp/myname)
THESETS="$THESETS site$VERSION-$(hostname -s).tgz"

enable_network

startcgiinfo

munge_fstab

check_fs

umount /mnt || { echo "No puede montar $ROOTDEV!"; exit; }
mount_fs

feed_random

install_sets

finish_up
