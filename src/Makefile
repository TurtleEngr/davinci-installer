# $Header: /repo/public.cvs/app/davinci-installer/github/src/Makefile,v 1.8 2021/04/08 20:18:10 bruce Exp $

# ----------------------------------------
# Macros

SHELL = /bin/bash

include ver.mak

mArchive = /rel/archive/software/ThirdParty/davinci
#mArchive = $(HOME)/Downloads
mVer = $(ProdTPVer)

mDVPkg = DaVinci_Resolve_$(mVer)_Linux
# example: DaVinci_Resolve_17.0b3_Linux.zip

#mDVPkg = DaVinci_Resolve_Studio_$(mVer)_Linux
# example: DaVinci_Resolve_Studio_16.2.7_Linux.zip

mTop = dist/opt/resolve

# --------------------
# Dependency vars

mDesktopDir = dist/usr/share/applications

mDirs = \
	dist \
	pkg \
	tmp \
	tmp/trash \
	$(mTop) \
	$(mTop)/.license \
	$(mTop)/Fairlight \
	$(mTop)/bin/BlackmagicRawAPI \
	$(mTop)/easyDCP \
	$(mDesktopDir) \
	dist/lib/udev/rules.d \
	dist/usr/bin \
	dist/usr/lib \
	dist/usr/share/desktop-directories \
	dist/var/BlackmagicDesign/DaVinci\ Resolve \
        dist/etc/xdg/menus/applications-merged

mProgs = tar fakeroot xorriso dpkg-deb epm mkver.pl patch-epm-list
mPkgs = nvidia-driver nvidia-opencl-icd ffmpeg
	# libcuda1
	# libnvidia-encode1

# --------------------
# Build vars

mBuildList = \
	$(mTop)/docs/User_Configuration_folders_and_customization.txt \
	$(mTop)/docs/Linux_Installation_Instructions.pdf \
	$(mTop)/bin/libBlackmagicRawAPI.so \
	$(mTop)/bin/BlackmagicRawAPI/libBlackmagicRawAPI.so \
	dist/usr/bin/resolve \
	dist/usr/lib/libDaVinciPanelAPI.so \
	dist/lib/udev/rules.d/75-davincipanel.rules \
	dist/lib/udev/rules.d/75-sdx.rules \
	$(mDesktopDir)/$(ProdName).desktop \
	$(mDesktopDir)/$(ProdName)-CaptureLogs.desktop \
	$(mDesktopDir)/$(ProdName)-Panels.desktop \
	$(mDesktopDir)/$(ProdName)-rawplayer.desktop \
	$(mDesktopDir)/$(ProdName)-rawspeedtest.desktop \
	dist/usr/share/desktop-directories/${ProgName}.directory \
	dist/etc/xdg/menus/applications-merged/$(ProdName).menu \
	tmp/post-install.sh \
	tmp/post-rm.sh

# ----------------
# Unused files and dirs in DV package

mRemove = \
	$(mTop)/AppRun \
	$(mTop)/filelist.txt \
	$(mTop)/installer \
	$(mTop)/installer.dat \
	$(mTop)/.DirIcon \
	$(mTop)/scripts/post_install.sh \
	$(mTop)/scripts/pre_install.sh \
	$(mTop)/scripts/script.halt \
	$(mTop)/scripts/script.kill \
	$(mTop)/scripts/script.logs.message \
	$(mTop)/scripts/script.reboot \
	$(mTop)/scripts/script.update \
	$(mTop)/scripts/uninstall.sh \
	$(mTop)/share/DaVinciResolveInstaller.desktop

# ----------------------------------------
# Main targets
.PHONY : prepare build package release tag help clean dist-clean

prepare : ver.mak dep

build : ver.mak ver.env $(mTop)/bin/resolve $(mBuildList) \
    tmp/post-install.sh tmp/post-rm.sh
	@echo "Remove unused files"
	-mv -f $(mRemove) tmp/trash
	@echo "Building dist/ for $(ProdName)"
	find dist -type d -exec chmod a+rx {} \;
	find dist -type f -exec chmod a+r {} \;
	chmod -R a+rw $(mTop)/easyDCP
	chmod -R a+rw $(mTop)/LUT
	chmod -R a+rw $(mTop)/.license
	chmod -R a+rw $(mTop)/Fairlight
	chmod -R a+rwx dist/var/BlackmagicDesign/"DaVinci Resolve"
	mkepmlist -u root -g root --prefix / dist | patch-epm-list -f ./patch.dat >epm.list

package : pkg ver.epm $(mTop)/bin/resolve epm.list epm.inc \
    ver-$(ProdOS).require
	-rm -f pkg/* &>/dev/null
	if [ "$$(whoami)" != "root" ]; then exit 1; fi
	epm -v -f native  -a $(ProdArch) --output-dir pkg $(ProdName) ver.epm
	chown $(SUDO_USER):$(SUDO_USER) pkg/*

release : tag
	-ssh $(ProdRelServer) mkdir -p $(ProdRelDir)/$(ProdOS)
	rsync -zP pkg/davinci-resolve-*.deb $(ProdRelServer):$(ProdRelDir)/$(ProdOS)

tag :
	cvs commit -m Updated
	cvs tag -cRF $(ProdTag)
	date >>VERSION
	echo $(ProdTag) >>VERSION

help : tmp/$(mDVPkg).run
	@echo "List $(mDVPkg).run arguments (but these are not used)"
	cd tmp; ./$(mDVPkg).run -h

clean :
	-find .. -name '*~' -exec rm {} \;
	-find dist pkg -type d -exec chmod -R ug+rwx {} \;
	-find dist pkg -type l -exec rm -f {} \;
	-chmod -R ug+rwx dist pkg
	-find dist pkg -type l -exec rm -f {} \;
	-rm -rf dist/* pkg/*
	-rm epm.list

dist-clean : clean
	-find tmp -type d -exec chmod -R ug+rwx {} \;
	-find tmp -type l -exec rm -f {} \;
	-chmod -R ug+rwx tmp
	-find tmp -type l -exec rm -f {} \;
	-rm -rf tmp dist pkg
	-rm ver.mak ver.env ver.epm

# ----------------------------------------
# Working targets

# ----------------
ver.mak ver.env ver.epm : ver.sh
	export RELEASE=1; /usr/local/bin/mkver.pl -e 'env mak epm'

# ----------------
# Dependencies

.PHONY : dep
dep : $(mDirs) $(mProgs) $(mPkgs) dep-validate

$(mDirs) :
	mkdir -p "$@"

.PHONY : $(mProgs)
$(mProgs) :
	@if [ ! -x $$(command -v $@) ]; then \
		echo "Error: missing $@"; \
		exit 1; \
	fi

.PHONY : $(mPkgs)
$(mPkgs) :
	@dpkg -l | grep -q $@

.PHONY : dep-validate
dep-validate :
	@tCount=$$(ls /etc/OpenCL/vendors | wc -l); \
	if [ $$tCount -ne 1 ]; then \
		echo "Warning: Only one file should be in /etc/OpenCL/vendors"; \
		exit 1; \
	fi

# ----------------
# Unpack

$(mTop)/bin/resolve : tmp/$(mDVPkg).run
	@echo "Extract the files from the downloaded package"
	-xorriso -osirrox on -indev tmp/$(mDVPkg).run -extract / $(mTop)
	if [ ! -x $@ ]; then echo "The extract failed"; exit 1; fi
	touch $@

tmp/$(mDVPkg).run : tmp/$(mDVPkg).zip
	@echo "Unzip the downloaded package"
	cd tmp; unzip $(mDVPkg).zip
	touch $@

tmp/$(mDVPkg).zip : $(mArchive)/$(mDVPkg).zip
	@echo "Create symlink to the downloaded package"
	ln -sf $(mArchive)/$(mDVPkg).zip $@

$(mArchive)/$(mDVPkg).zip :
	@echo "If not found: change mArchive, mDVPkg, mVer"

# ----------------
# Fix up the distribution

$(mTop)/docs/User_Configuration_folders_and_customization.txt :
	@echo "Move User Config document to docs"
	mv $(mTop)/'Technical Documentation/User Configuration folders and customization.txt' $@
	-rmdir $(mTop)/'Technical Documentation'

$(mTop)/docs/Linux_Installation_Instructions.pdf : tmp/Linux_Installation_Instructions.pdf
	cp $? $@

dist/usr/lib/libDaVinciPanelAPI.so : $(mTop)/share/panels/dvpanel-framework-linux-x86_64.tgz
	tar -xzf $? -C dist/usr/lib libDaVinciPanelAPI.so

$(mTop)/bin/libBlackmagicRawAPI.so : # $(mTop)/libs/libBlackmagicRawAPI.so
	ln -sf /opt/resolve/libs/libBlackmagicRawAPI.so $@

$(mTop)/bin/BlackmagicRawAPI/libBlackmagicRawAPI.so : # $(mTop)/libs/libBlackmagicRawAPI.so
	ln -sf /opt/resolve/libs/libBlackmagicRawAPI.so $@

dist/usr/bin/resolve : # $(mTop)/bin/resolve
	ln -sf /opt/resolve/bin/resolve $@

dist/lib/udev/rules.d/75-davincipanel.rules :
	echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="1edb", MODE="0666"' >$@

dist/lib/udev/rules.d/75-sdx.rules :
	echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="096e", MODE="0666"' >$@

$(mDesktopDir)/$(ProdName).desktop : $(mTop)/share/DaVinciResolve.desktop
	sed 's;RESOLVE_INSTALL_LOCATION;/opt/resolve;g' <$? >$@

$(mDesktopDir)/$(ProdName)-CaptureLogs.desktop : $(mTop)/share/DaVinciResolveCaptureLogs.desktop
	sed 's;RESOLVE_INSTALL_LOCATION;/opt/resolve;g' <$? >$@

$(mDesktopDir)/$(ProdName)-Panels.desktop : $(mTop)/share/DaVinciResolvePanelSetup.desktop
	sed 's;RESOLVE_INSTALL_LOCATION;/opt/resolve;g' <$? >$@

$(mDesktopDir)/$(ProdName)-rawplayer.desktop : $(mTop)/share/blackmagicraw-player.desktop
	sed 's;RESOLVE_INSTALL_LOCATION;/opt/resolve;g' <$? >$@

$(mDesktopDir)/$(ProdName)-rawspeedtest.desktop : $(mTop)/share/blackmagicraw-speedtest.desktop
	sed 's;RESOLVE_INSTALL_LOCATION;/opt/resolve;g' <$? >$@

dist/usr/share/desktop-directories/${ProgName}.directory : $(mTop)/share/DaVinciResolve.directory
	sed 's;RESOLVE_INSTALL_LOCATION;/opt/resolve;g' <$? >$@

dist/etc/xdg/menus/applications-merged/$(ProdName).menu : $(mTop)/share/DaVinciResolve.menu
	cat $? | sed "s/com.blackmagicdesign.resolve/$(ProdName)/g; s/com.blackmagicdesign./$(ProdName)-/g" | grep -v Installer >$@

tmp/post-install.sh :
	echo 'xdg-mime install --novendor /opt/resolve/share/blackmagicraw.xml' >$@
	echo 'xdg-mime install --novendor /opt/resolve/share/resolve.xml' >>$@

tmp/post-rm.sh :
	echo 'xdg-mime uninstall /opt/resolve/share/blackmagicraw.xml' >$@
	echo 'xdg-mime uninstall /opt/resolve/share/resolve.xml' >>$@

# ----------------
# Package

.PHONY : epm.list
epm.list : patch.dat
	mkepmlist -u root -g root --prefix / dist | patch-epm-list -f ./patch.dat >$@	

