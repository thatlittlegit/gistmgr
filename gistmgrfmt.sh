#!/bin/sh
#
# GistMGR-FMT formats URL-based lists outputted from `gistmgr list`.
#
# This program is under the GNU General Public License, 3.0.
# It is distributed in the hope that it can be useful,
# but with NO WARRANTY OR LIABILITY.
#
# A copy of the license should have been included with
# this software; if not, see http://gnu.org/licenses/gpl-3.0.txt
#
. ~/.gistmgrrc

[ -z "$GISTMGR_FORMATS" ] || fmtpath=$GISTMGR_FORMATS
[ -z "$GISTMGR_URLFILE" ] || urlfile=$GISTMGR_URLFILE

usage() {
    echo "GistMGR-FMT - by thatlittlegit

$0 <mode>"

    [ -z "$fmtpath" ] || echo "
where <mode> can be one of:
$(ls $fmtpath | grep -ve '.awk$' | awk -F. {'print "'\\t'"$1'})"
    [ -z "$fmtpath" ] && echo "
where <mode> can be one of:
      (unknown)"
}
if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    usage
else

    [ -z "$fmtpath" ] && [ -z "$urlfile" ] && echo "$0: no fmtpath or urlfile in .gistmgrrc, abort!" >&2 && exit 2
    [ -z "$fmtpath" ] && echo "$0: no fmtpath in .gistmgrrc, using directory of $urlfile!" >&2 && fmtpath=$(dirname $urlfile)

    [ ! -f "$fmtpath/$1.awk" ] && echo "$0: script $fmtpath/$1.awk not found, abort!" >&2 && exit 4
    exec cat - | awk -f "$fmtpath/$1.awk"
fi
    
