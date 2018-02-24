#!/bin/sh
#
# GistMGR manages URL-based lists that are integrated with Git.
#
# GistMGR is under the GNU General Public License, 3.0.
# it is distributed in the hope that it can be useful,
# but with NO WARRANTY OR LIABILITY.
#
# A copy of the license should have been included with
# this software; if not, see http://gnu.org/licenses/gpl-3.0.txt
#
genrcfile() {
    # We assume we need to make a .gistmgrrc file, and thus won't
    # check for it.
    echo "$0: no gistmgrrc file exists, creating default" 1>&2
    echo "$0: creating local git repo, you'll need to connect it to gist" 1>&2
    mkdir "$HOME/.gistmgr" && cd "$HOME/.gistmgr"
    git init
    echo "# GistMGR" > gistlist
    git add gistlist && git commit -m "[gistmgr] Initial Commit"
    echo "urlfile=$HOME/.gistmgr/gistlist" >>~/.gistmgrrc
}

usage() {
       echo "GistMGR - by thatlittlegit

$0 add <list> <url> [comment]
$0 remove <list> <url>
$0 list <list>

GistMGR is under the GPL 3 License."
    exit 3
}

[ -f ~/.gistmgrrc ] || genrcfile

if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ -z "$1" ]
then
    usage
else
    . ~/.gistmgrrc

    [ -z "$GISTMGR_URLFILE" ] || urlfile=$GISTMGR_URLFILE

    [ -z "$urlfile" ] && echo "$0: No urlfile present, abort!" && exit 2

    urlfolder=$(dirname $urlfile)

    case "#@#" in "$(sed 2q <$urlfile | tail -1)")
		      singlelist=1
    esac
    [ -z "$singlelist" ] && singlelist=0

    if [ "$1" = "list" ]
    then
	if [ "$singlelist" = "1" ]
	then
	    exec grep -ve "^#" $urlfile
	elif [ $# -ne 2 ]
	then
	    echo "$0: invalid number of arguments (got $#, need 2)" >&2
	    echo "$0: Usage: $0 list <list>" >&2
	    exit 3
	else
	    exec grep -e "^$2 " $urlfile
	fi
    elif [ $# -lt 3 ]
    then
	if [ $# -gt 1 ]
	then
	    echo "$0: invalid number of arguments (got $#, need 3)" >&2
	    echo "$0: Usage: $0 $1 <list> <url>" >&2
	else
	    echo "$0: command not found" >&2
	    usage
	fi
    elif [ "$1" = "add" ]
    then
	if [ "$singlelist" = "1" ]
	then
	    echo "$(echo $2 | sed 's/ /%20/g') $3" >> $urlfile
	else
	    echo "$2 $(echo $3 | sed 's/ /%20/g') $4" >> $urlfile
	fi

	cd $urlfolder

	if [ "$singlelist" = "1" ]
	then
	    exec git commit -avm "[gistmgr] Add $2" | sed '1q'
	else
	    exec git commit -avm "[gistmgr] Add $3 to $2" | sed '1q'
	fi
    elif [ "$1" = "remove" ]
    then
	if [ "$singlelist" = "1" ]
	then
	    grep -ve "^$2" $urlfile >/tmp/gistmgr-$(whoami)
	else
	    grep -ve "^$2 $(echo $3 | sed 's/ /%20/g').*$" $urlfile >/tmp/gistmgr-$(whoami)
	fi

	mv /tmp/gistmgr-$(whoami) $urlfile
	cd $urlfolder

	if [ "$singlelist" = "1" ]
	then
	    exec git commit -avm "[gistmgr] Remove $2" 2>&1 | sed 1q
	else
	    exec git commit -avm "[gistmgr] Remove $3 from $2" 2>&1 | sed '1q'
	fi
    fi
fi
