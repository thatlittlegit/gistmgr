#!/bin/sh
# Installs to $PREFIX or $1 or /usr/local.
[ -z "$INSTALL_PREFIX" ] && [ -z "$1" ] && prefix=/usr/local
[ -z "$INSTALL_PREFIX" ] && [ -z "$1" ] || prefix=$1
[ -z "$INSTALL_PREFIX" ] || prefix=$INSTALL_PREFIX

echo "# Installing to $prefix..."

installfile() {
	echo "install $1 $prefix/$2"
	install $1 $prefix/$2
	if [ $? -ne 0 ]
	then
		echo "$0: error, abort!"
		exit 1
	fi
}

makedir() {
	echo "mkdir -p $prefix/$1"
	mkdir -p $prefix/$1
	# don't include error mechanism because errors are *very* likely
}

makedir
makedir bin
installfile gistmgr.sh bin/gistmgr
installfile gistmgrfmt.sh bin/gistmgrfmt
makedir man/man1
installfile gistmgr.1 man/man1/gistmgr.1
installfile gistmgrfmt.1 man/man1/gistmgrfmt.1
