# $Header: /repo/public.cvs/app/davinci-installer/github/src/ver.sh,v 1.5 2021/04/08 20:18:10 bruce Exp $

# Input file for: mkver.pl.  All variables must have
# "export " at the beginning.  No spaces around the
# "=".  And all values enclosed with double quotes.
# Variables may include other variables in their
# values.

export ProdName="davinci-resolve"
# One word [-_.a-zA-Z0-9]

export ProdAlias=$ProdName
# One word [-_.a-zA-Z0-9]

export ProdVer="17.1.1"
# 4 parts max
# [0-9]*.[0-9]*{.[0-9]*}{.[0-9]*}

export ProdBuild="1"
# [0-9]*

export ProdSummary="DaVinci Resolve"
# All on one line (< 80 char)

export ProdDesc="DaVinci Resolve. Repackaged with EPM."
# All on one line

export ProdVendor="BlackMagic Design"

export ProdPackager="$LOGNAME"
export ProdSupport="https://www.blackmagicdesign.com/products/davinciresolve/"
export ProdCopyright="2021"

export ProdDate=""
# Generated if empty
# 20[012][0-9]-[01][0-9]-[0123][0-9]

export ProdLicense="dist/opt/resolve/docs/License.txt"
# Required

export ProdReadMe="dist/opt/resolve/docs/ReadMe.html"
# Required

# Third Party (if any)
export ProdTPVendor="BlackMagic Design"
export ProdTPVer="17.1.1"
export ProdTPCopyright="2021"

# Set this to latest version of mkver.pl
export MkVer="2.1"

export ProdRelServer="moria.whyayh.com"
export ProdRelRoot="/rel"
export ProdRelCategory="software/ThirdParty/$ProdName"
# Generated: ProdRelDir=ProdRelRoot . /released|development/ . ProdRelCategory
# (if RELEASE=1, then use "released", else use "development")
# Generated: ProdDevDir=ProdRelRoot/development/ProdRelCategory

# Generated: ProdTag=ProdVer-ProdBuild
# (All "." converted to "-")

# Generated: ProdOS (DistVer)
#	Dist
#		Ver
# linux
# 	deb
# 	rhes
# 	cent
# 	fc
# cygwin
#	cygwin
# mswin32
#	win
#		xp
# solaris
#	sun
# darwin
#	mac

# Generated: ProdArch
# i386
# x86_64

# Output file control variables.
# The *File vars can include dir. names
# The *Header and *Footer defaults are more complete
# than what is shown here.

export envFile="ver.env"
export envHeader=""
export envFooter=""

export epmFile="ver.epm"
export epmHeader=""
export epmFooter="%include epm.inc"
