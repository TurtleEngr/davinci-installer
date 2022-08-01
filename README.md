# davinci-installer

Repackage DaVinci_Resolve or DaVinci_Resolve_Studio with EPM, to
create a more general installer for any Linux distribution.

---

## Create a general installer with EPM

This packaging tool will create: rpm and deb packages for the most
common Linux distributions. It will also create dgm MacOS
packages. Often the most of the package configuration can be the same
for the different OS distributions.

This project leverages from the things MakeResolveDeb implements. But
it makes a more general installer that can be made for more Linux
Distributions.  The OS differences can be defined in the installer
definition files and in configuration files. **The EPM approach is a
"functional" programming style, i.e. define what you want not how to
do it.**</p>

Step 1: build or download the latest EPM packager.
[ESP Package Manager (EPM) -new home of 2020-11-18](https://jimjag.github.io/epm/)
[ESP Package Manager (EPM) - old home](https://www.msweet.org/epm/epm.html)

Step 2: Install the EPM helper scripts. See
[EPM Helpers](https://github.com/TurtleEngr/epm-helpers)
These scripts will help determine the OS you are on, and generate
environment variables, that can be used to select the different
requirements for each OS.

Step 3: define the dependencies for each of the OS's that you will be
building. For Ubuntu, see
[How to Install Davinci Resolve on Ubuntu and Fix the Audio Issue](https://www.alecaddd.com/how-to-install-davinci-resolve-on-ubuntu-and-fix-the-audio-issue/)

---

# Notes

## Don't use DiVinci Resolve installer script, if not CentOS

Do not use the DiVinci Resolve 16 installer for Linux, unless your OS
is CentOS. Black Majac apparently doesn't know about all of the
different installer programs for Linux and other systems; so they
rolled their own. It is not surprising that it is only supported for
CentOS.

## Uninstalling DiVinci Resolve 16

Oops, I installed it with the "lame" installer. How do I cleanup?

https://www.reddit.com/r/blackmagicdesign/comments/9v24mq/how_to_completely_uninstall_davinci_resolve_on/

https://www.reddit.com/r/blackmagicdesign/comments/873zyu/uninstalling_davinci_resolve_linux/

    /opt/resolve
    /usr/share/applications/DaVinci Resolve.desktop

    sudo -s
    find /opt/resolve -type l -exec rm {} \;
    rm -rf /opt/resolve
    updatedb

    locate DaVinci
    locate davinci

See doc/davinci-rm-mess.txt for more details.

### locate davinci

This is the full list (after rm /opt/resolve).

    locate davinci | egrep -v '/mnt/plasma.data3|ver/public|/usr/src/linux-header'
    /lib/udev/rules.d/75-davincipanel.rules

### Shortened to Dirs

    find $HOME/.local/share/DaVinciResolve -type l -exec rm {} \;
    rm -rf $HOME/.local/share/DaVinciResolve

    find $HOME/BlackmagicDesign/DaVinci\ Resolve -type l -exec rm {} \;
    rm -rf $HOME/BlackmagicDesign/DaVinci\ Resolve

    rm -f $HOME/per/config/Blackmagic\ Design/DaVinci\ Resolve\ Panels\ Setup.conf
    rm -f /usr/lib/libDaVinciPanelAPI.so

    rm -f /usr/share/icons/hicolor/64x64/apps/DaVinci-Resolve*
    rm -rf /var/BlackmagicDesign

    find $HOME/Downloads/DaVinci -type l -exec rm {} \;
    rm -rf $HOME/Downloads/DaVinci

    rm /lib/udev/rules.d/75-davincipanel.rules

    rm -f /usr/share/applications/com.blackmagicdesign.resolve*

    edit /usr/share/applications/bamf-2.index
    # Remove any davinci lines

    edit .config/menus/applications-kmenuedit.menu
    # Remove any davinci lines. Or use the GUI to edit the menus.

    rm $HOME/.local/share/plasma_icons/com.blackmagicdesign.resolve.desktop

### Now do you see

Now do you see why it is important to have an app installer that
understands where *every* file is located for your OS? It makes it
easy to remove and upgrade the app.

---

## Create a Debian Installer: MakeResolveDeb

After seeing the mess that the CentOS installer makes in Debian,
Daniel Tufvesson created an installer for Debian based distributions.

See:
[www.linuxuprising.com/2018/06/how-to-install-davinci-resolve-15-in.html](https://www.linuxuprising.com/2018/06/how-to-install-davinci-resolve-15-in.html)
    
There are some tips here too.
[www.danieltufvesson.com/makeresolvedeb](https://www.danieltufvesson.com/makeresolvedeb)

> "The [DaVinci_Resolve supplied] native installer will install
> DaVinci_Resolve on your Debian based system but it will violate the
> Debian concept of fully tracked installations. The native installer
> forces software components into place and modifies parts of the OS
> in a way that is unbeknown to the Debian package manager. This
> practice will impede system reliability. MakeResolveDeb aims to
> solve that issue while including the Debian specific features
> required for a working Resolve system."

I reviewed the MakeResolveDeb installer. It will work with Debian dpkg
distributions. *However after digging through the DaVinci_Resolve
supplied native installer, there are problems with the MakeResolveDeb
installer.* It hardcodes things that it could have picked out of the
native installer supplied files. I.e. it is fragile. Newer versions
will need more hardcoding. In addition it will only support Debian
distributions. There could be subtle differences between the
distributions and versions. **So a more general solution is needed.**

---

    $Source: /repo/public.cvs/app/davinci-installer/github/README.md,v $
