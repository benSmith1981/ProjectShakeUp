###############################################################################################
# TheSun-NG iOS Build Script
#
# Author: Martin Lloyd
###############################################################################################

# Useful directory and file names as variables

XCODE=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild
PROJECTDIR=${PWD}/App
ACTIVEAPP="ProjectShakeUp"
ACTIVEPROJ=ProjectShakeUp

DISTDIR="${PWD}/dist"
APP_CONFIGURATION=Release
BUILD_LOCATION=/build/Release-iphoneos/

function usage() {
	echo "
	==========================================
	Usage: build.sh
	example:
	./build.sh
	==========================================
	"
}

function clean() {
	echo ">>>>>> Cleaning up <<<<<<"
	echo "$DISTDIR"

	if [ $DISTDIR ]; then
		rm -rf "$DISTDIR"
	else
		#It doesn't exist so just exit and stop running the script
		echo "DISTDIR Doesn't exist"
		#exit 1
	fi
}

function buildApp() {
	echo ">>>>>> Building App for ${BINARYTYPE} <<<<<<"
	cd "$PROJECTDIR"
	project="$ACTIVEPROJ.xcodeproj"
	target="$ACTIVEPROJ"	
	
	#clean
    	$XCODE clean -project "$project" -target "$target" -configuration $APP_CONFIGURATION clean
	
	#build
	$XCODE build -project "$project" -target "$target" -configuration $APP_CONFIGURATION build	
}

function packageApp() {
	echo ">>>>>> Packaging App <<<<<<"
	mkdir -p "$DISTDIR/Payload"
	cd "$PROJECTDIR/$BUILD_LOCATION"
	echo "******************************************"
	pwd
	mv "$ACTIVEAPP.app" "$DISTDIR/Payload"
	cd "$DISTDIR"

	/usr/bin/zip -r -y "$ACTIVEAPP.ipa" Payload/*

	rm -rf "$DISTDIR/Payload"
	echo ""
	echo "************App packaged and ready $DISTDIR/$ACTIVEAPP.ipa ************"
}

function process() {
	echo $ACTIVEAPP
	clean
	buildApp
	packageApp
}

process
