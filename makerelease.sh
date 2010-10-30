#!/bin/sh
# makerelease.sh: Creates a release suitable for distribution.
#
# Based on the distfiles.atheme.org distribution script which can be found at
# http://hg.atheme.org/atheme/atheme/file/f94f834946aa/scripts/makerelease.sh
# 
# Copyright (c) 2007 atheme.org
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

if [ "x$1" = "x" ]; then
	echo "usage: $0 tag [--automatic]"
	exit
else
	TAG="$1"
fi

if [ "x$2" = "x--automatic" ]; then
	AUTOMATIC="yes"
fi

WRKDIR=`pwd`

echo "Making release named $TAG"

echo
echo "Building $TAG.tar"
git archive -o $TAG.tar $TAG

echo "Compressing $TAG.tar to $TAG.tar.gz"
gzip -c -9 $TAG.tar > $TAG.tar.gz

echo "Compressing $TAG.tar to $TAG.tar.bz2"
bzip2 -k -9 $TAG.tar

PUBLISH="yes"

ok="0"
if [ "x$AUTOMATIC" != "xyes" ]; then
	echo
	echo "Would you like to publish these releases now?"
	while [ $ok -eq 0 ]; do
		echo -n "[$PUBLISH] "

		read INPUT
		case $INPUT in
			[Yy]*)
				PUBLISH="yes"
				ok=1
				;;
			[Nn]*)
				PUBLISH="no"
				ok=1
				;;
		esac
	done
fi

if [ "x$PUBLISH" = "xyes" ]; then
	scp $TAG.tar.gz distfiles.woomoo.org:/srv/distfiles
	scp $TAG.tar.bz2 distfiles.woomoo.org:/srv/distfiles

	echo
	echo "The releases have been published, and will be available to the entire"
	echo "distribution network within 15 minutes."
fi

echo
echo "Done. If you have any bugs to report, report them against"
echo "http://github.com/woomoo/buildtools/issues"
echo "Thanks!"
echo
