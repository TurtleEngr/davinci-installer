#!/bin/bash
# $Header: /repo/public.cvs/app/davinci-installer/github/src/davinci-rm.sh,v 1.2 2020/12/03 02:01:42 bruce Exp $

fExists()
{
	local pDir="$1"
	if ls -d "$pDir" &>/dev/null; then
		echo "Found: $pDir"
		if [ $gpRm -ne 0 ]; then
			find $pDir -type l -exec rm {} \;
			rm -rf $pDir
		fi
	fi
}


# ===============================
export gpRm=0

if [ $# -ne 1 ]; then
	echo "Use -r to remove, othewise this just shows the files that will be removed."
	export tHome=$HOME
else
	if [ ".$1" != ".-r" ]; then
		echo "Error: expected -r"
		exit 1
	fi
	gpRm=1

	if [ "$(whoami)" != "root" ]; then
		echo "Error: you need to be root to remove files and dirs"
		exit 1
	fi
	export tHome=/home/$SUDO_USER
fi

if [ ! -d $tHome ]; then
	echo "Error: could not find $tHome"
	exit 1
fi

# -------------------------
fExists $tHome/BlackmagicDesign/DaVinci\ Resolve/
fExists $tHome/.config/Blackmagic\ Design/DaVinci\ Resolve\ Panels\ Setup.conf
fExists $tHome/.local/share/DaVinciResolve/
fExists $tHome/.local/share/plasma_icons/com.blackmagicdesign.resolve.desktop
fExists $tHome/Desktop/com.blackmagicdesign.resolve.desktop
fExists $tHome/.local/share/applications/com.blackmagicdesign.rawplayer.desktop
fExists $tHome/.local/share/applications/com.blackmagicdesign.rawspeedtest.desktop
fExists $tHome/.local/share/applications/com.blackmagicdesign.resolve-CaptureLogs.desktop
fExists $tHome/.local/share/applications/com.blackmagicdesign.resolve-Installer.desktop
fExists $tHome/.local/share/applications/com.blackmagicdesign.resolve-Panels.desktop
fExists $tHome/.local/share/applications/com.blackmagicdesign.resolve.desktop
fExists $tHome/Desktop/com.blackmagicdesign.resolve.desktop
fExists $tHome/per/config/menus/applications-merged/com.blackmagicdesign.resolve.menu

fExists /etc/xdg/menus/applications-merged/com.blackmagicdesign.resolve.menu
fExists /lib/udev/rules.d/75-davincipanel.rules
fExists /opt/resolve
fExists /usr/lib/libDaVinciPanelAPI.so
fExists /usr/share/applications/DaVinci\ Resolve.desktop
fExists /usr/share/applications/com.blackmagicdesign.rawplayer.desktop
fExists /usr/share/applications/com.blackmagicdesign.rawspeedtest.desktop
fExists /usr/share/applications/com.blackmagicdesign.resolve*/
fExists /usr/share/desktop-directories/com.blackmagicdesign.resolve.directory
fExists /usr/share/icons/hicolor/64x64/apps/DaVinci-Resolve*
fExists /var/BlackmagicDesign/

if egrep -il 'davinci|blackmagic' $tHome/.config/menus/applications-kmenuedit.menu; then
	echo "found in: $tHome/.config/menus/applications-kmenuedit.menu"
	echo "Remove any davinci lines. Or use the GUI to edit the menus."
fi
if egrep -il 'davinci|blackmagic' /usr/share/applications/bamf-2.index; then
	echo "found in: /usr/share/applications/bamf-2.index"
	echo "Remove any davinci lines."
fi

# locate davinci | egrep -v '/mnt/plasma.data3|ver/public|/usr/src/linux-header'
# locate com.blackmagicdesign
