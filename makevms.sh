#!/bin/sh
#

# Lets make the user give us a target build system

# if [ $# -ne 1 ]; then
# 	echo "Usage:   $0 target_architecture"
# 	echo "Example: $0 x86"
# 	echo "The other valid option is x86_64"
# 	echo
# 	echo "If you don't know or care about architectures please consider using make-macosx-ub.sh instead of this script."
# 	exit 1
# fi
# 
# if [ "$1" == "x86" ]; then
# 	BUILDARCH=x86
# 	ARCH=i386
# elif [ "$1" == "x86_64" ]; then
	BUILDARCH=x86_64
	ARCH=x86_64
# else
# 	echo "Invalid architecture: $1"
# 	echo "Valid architectures are x86, x86_64"
# 	exit 1
# fi

CC=clang
CXX=clang++
APPBUNDLE=iowolfsp.app
BINARY=iowolfsp.${ARCH}
PKGINFO=APPLIOTCW
ICNS=misc/iortcw.icns
DESTDIR=build/release-darwin-${BUILDARCH}
BASEDIR=main

BIN_OBJ="
	build/release-darwin-${BUILDARCH}/iowolfsp.${BUILDARCH}
"
BASE_OBJ="
	build/release-darwin-${BUILDARCH}/$BASEDIR/cgame.sp.${ARCH}.dylib
	build/release-darwin-${BUILDARCH}/$BASEDIR/ui.sp.${ARCH}.dylib
	build/release-darwin-${BUILDARCH}/$BASEDIR/qagame.sp.${ARCH}.dylib
"
RENDER_OBJ="
	build/release-darwin-${BUILDARCH}/renderer_sp_opengl1_${ARCH}.dylib
	build/release-darwin-${BUILDARCH}/renderer_sp_rend2_${ARCH}.dylib
"

QVM_OBJ="
	build/release-darwin-${BUILDARCH}/$BASEDIR/vm/cgame.sp.qvm
	build/release-darwin-${BUILDARCH}/$BASEDIR/vm/ui.sp.qvm
	build/release-darwin-${BUILDARCH}/$BASEDIR/vm/qagame.sp.qvm
"


cd `dirname $0`
if [ ! -f Makefile ]; then
	echo "This script must be run from the iowolfsp build directory"
	exit 1
fi

Q3_VERSION=`grep '^VERSION=' Makefile | sed -e 's/.*=\(.*\)/\1/'`

# We only care if we're >= 10.4, not if we're specifically Tiger.
# "8" is the Darwin major kernel version.
TIGERHOST=`uname -r |perl -w -p -e 's/\A(\d+)\..*\Z/$1/; $_ = (($_ >= 8) ? "1" : "0");'`

unset ARCH_CFLAGS

ARCH_CFLAGS="-arch ${ARCH}"

if [ ! -d $DESTDIR ]; then
	mkdir -p $DESTDIR
fi

# For parallel make on multicore boxes...
NCPU=`sysctl -n hw.ncpu`


# intel client and server
if [ -d build/release-darwin-${BUILDARCH} ]; then
	rm -r build/release-darwin-${BUILDARCH}
fi
(CC=${CC} CXX=${CXX} ARCH=${BUILDARCH} CFLAGS=$ARCH_CFLAGS make -j$NCPU) || exit 1;

cp $QVM_OBJ "$HOME/Library/Application Support/rtcw/Main/vm"

if [ ! -d "Main/vm" ]; then
	mkdir -p "Main/vm" || exit 1;
fi

cp $QVM_OBJ "$HOME/Library/Application Support/rtcw/Main/vm"
cp $QVM_OBJ "Main/vm"

# echo "Creating .app bundle $DESTDIR/$APPBUNDLE"
# if [ ! -d $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR ]; then
# 	mkdir -p $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR || exit 1;
# fi
# if [ ! -d $DESTDIR/$APPBUNDLE/Contents/Resources ]; then
# 	mkdir -p $DESTDIR/$APPBUNDLE/Contents/Resources
# fi
# cp $ICNS $DESTDIR/$APPBUNDLE/Contents/Resources/iortcw.icns || exit 1;
# echo $PKGINFO > $DESTDIR/$APPBUNDLE/Contents/PkgInfo
# echo "
# 	<?xml version=\"1.0\" encoding=\"UTF-8\"?>
# 	<!DOCTYPE plist
# 		PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\"
# 		\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
# 	<plist version=\"1.0\">
# 	<dict>
# 		<key>CFBundleDevelopmentRegion</key>
# 		<string>English</string>
# 		<key>CFBundleExecutable</key>
# 		<string>$BINARY</string>
# 		<key>CFBundleGetInfoString</key>
# 		<string>iowolfsp $Q3_VERSION</string>
# 		<key>CFBundleIconFile</key>
# 		<string>iortcw.icns</string>
# 		<key>CFBundleIdentifier</key>
# 		<string>org.ioquake.iortcw</string>
# 		<key>CFBundleInfoDictionaryVersion</key>
# 		<string>6.0</string>
# 		<key>CFBundleName</key>
# 		<string>iowolfsp</string>
# 		<key>CFBundlePackageType</key>
# 		<string>APPL</string>
# 		<key>CFBundleShortVersionString</key>
# 		<string>$Q3_VERSION</string>
# 		<key>CFBundleSignature</key>
# 		<string>$PKGINFO</string>
# 		<key>CFBundleVersion</key>
# 		<string>$Q3_VERSION</string>
# 		<key>NSExtensions</key>
# 		<dict/>
# 		<key>NSPrincipalClass</key>
# 		<string>NSApplication</string>
# 	</dict>
# 	</plist>
# 	" > $DESTDIR/$APPBUNDLE/Contents/Info.plist
# 
# 
# cp $BIN_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$BINARY
# cp $RENDER_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/
# cp $BASE_OBJ $DESTDIR/$APPBUNDLE/Contents/MacOS/$BASEDIR/
# cp code/libs/macosx/*.dylib $DESTDIR/$APPBUNDLE/Contents/MacOS/
# cp code/libs/macosx/*.dylib $DESTDIR
