#!/bin/sh
#
# Manages URL-based lists that can be uploaded as secret Gists.
#
function genrcfile() {
    # We assume we need to make a .gistmgrrc file, and thus won't
    # check for it.
    echo "$0: no gistmgrrc file exists, creating default" 1>&2
    echo "$0: creating local git repo, you'll need to connect it to gist" 1>&2
    mkdir "$HOME/.gistmgr" && cd "$HOME/.gistmgr"
    git init
    echo "# GistMGR" > gistlist
    git add gistlist && git commit -m "[gistmgr] Initial Commit"
    echo "FILE_LOC=$HOME/.gistmgr/gistlist" >>~/.gistmgrrc
    echo "FOLDER_LOC=$HOME/.gistmgr" >>~/.gistmgrrc
}

[ -f ~/.gistmgrrc ] || genrcfile

if [ $# -eq 0 ] || [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$1" ]
then
    echo "GistMGR - by thatlittlegit

$0 add <list> <url> [comment]
$0 remove <list> <url>
$0 list <list>

GistMGR is under the GPL 3 License."
    exit 1
else
    . ~/.gistmgrrc
    [ -z "$FILE_LOC" ] && echo "$0: No FILE_LOC present, abort!" && exit 2
    [ -z "$FOLDER_LOC" ] && echo "$0: No FOLDER_LOC present, abort!" && exit 2

    if [ "$1" == "list" ]
    then
	if [ $# -ne 2 ]
	then
	    echo "$0: invalid number of arguments (got $#, need 2)" >&2
	    echo "$0: Usage: $0 list <list>" >&2
	    exit 1
	fi

	grep -e "^$2 " $FILE_LOC
	exit $?
    elif [ $# -lt 3 ]
    then
	if [ $# -gt 1 ]
	then
	    echo "$0: invalid number of arguments (got $#, need 3)" >&2
	    echo "$0: Usage: $0 $1 <list> <url>" >&2
	else
	    exec $0 --help
	fi
    elif [ "$1" == "add" ]
    then
	echo "$2 $(echo $3 | sed 's/ /%20/g') $4" >> $FILE_LOC
	cd $FOLDER_LOC
	git commit -avm "[gistmgr] Add $3 to $2" | sed '1q'
    elif [ "$1" == "remove" ]
    then
	grep -ve "^$2 $(echo $3 | sed 's/ /%20/g').*$" $FILE_LOC >/tmp/gistmgr-$(whoami)
	mv /tmp/gistmgr-$(whoami) $FILE_LOC
	cd $FOLDER_LOC
	git commit -avm "[gistmgr] Remove $3 from $2" 2>&1 | sed '1q'
    fi
fi
