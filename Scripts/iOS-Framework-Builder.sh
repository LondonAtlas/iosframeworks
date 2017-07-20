#!/bin/bash

######################
# This script is adapted from:
# https://medium.com/@syshen/create-an-ios-universal-framework-148eb130a46c
######################

######################
# Options
######################

REVEAL_ARCHIVE_IN_FINDER=false
FRAMEWORK_NAME="${PROJECT_NAME}"
SCHEME="${PROJECT_NAME}"
SIMULATOR_LIBRARY_PATH_I386="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator-i386/${FRAMEWORK_NAME}.framework"
SIMULATOR_LIBRARY_PATH_X86_64="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator-x86_64/${FRAMEWORK_NAME}.framework"
DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework"
UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal"
FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME}.framework"

######################
# Functions
######################

function error_exit
{
	echo "$1" 1>&2
	exit 1
}

# Loop through all command line flags
while [[ $# > 0 ]]
  do
  case "$1" in
    -o) REVEAL_ARCHIVE_IN_FINDER=true
        ;;
    -s) SCHEME="$2"
        ;;
     *) 
        ;;
  esac
  shift
done


######################
# Build Frameworks
######################

# build the i386 simulator version
xcodebuild -project ${PROJECT_NAME}.xcodeproj -scheme ${SCHEME} -sdk iphonesimulator -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator-i386 -arch i386 ONLY_ACTIVE_ARCH=NO || error_exit "Could not build for simulator i386"

# # build the x86_64 simulator version
xcodebuild -project ${PROJECT_NAME}.xcodeproj -scheme ${SCHEME} -sdk iphonesimulator -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator-x86_64 -arch x86_64 ONLY_ACTIVE_ARCH=NO || error_exit "Could not build for simulator x86_64"

# build the iOS version
xcodebuild -project ${PROJECT_NAME}.xcodeproj -scheme ${SCHEME} -sdk iphoneos -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos || error_exit "Could not build for device"

# N.B. You will need either different scripts or additional command line flags to build for
#      watchOS, tvOS, and macOS as you can't wrap all of those up into a single truly 
#      universal binary.

######################
# Create directory for universal
######################

rm -rf "${UNIVERSAL_LIBRARY_DIR}"
mkdir "${UNIVERSAL_LIBRARY_DIR}"
mkdir "${FRAMEWORK}"

######################
# Copy files Framework
######################

cp -r "${DEVICE_LIBRARY_PATH}/." "${FRAMEWORK}"

######################
# Make an universal binary
######################

lipo "${SIMULATOR_LIBRARY_PATH_I386}/${FRAMEWORK_NAME}" "${SIMULATOR_LIBRARY_PATH_X86_64}/${FRAMEWORK_NAME}" "${DEVICE_LIBRARY_PATH}/${FRAMEWORK_NAME}" -create -output "${FRAMEWORK}/${FRAMEWORK_NAME}" | echo

# For Swift framework, Swiftmodule needs to be copied in the universal framework
if [ -d "${SIMULATOR_LIBRARY_PATH_I386}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
   cp -f ${SIMULATOR_LIBRARY_PATH_I386}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
fi

if [ -d "${SIMULATOR_LIBRARY_PATH_X86_64}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
   cp -f ${SIMULATOR_LIBRARY_PATH_X86_64}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
fi
                                                                      
if [ -d "${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
    cp -f ${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
fi

######################
# On Release, copy the result to release directory
######################
OUTPUT_DIR="${PROJECT_DIR}/"
cd "${UNIVERSAL_LIBRARY_DIR}"
zip -r "${FRAMEWORK_NAME}.zip" "${FRAMEWORK_NAME}.framework"
cp "${FRAMEWORK_NAME}.zip" "${OUTPUT_DIR}"

if [ ${REVEAL_ARCHIVE_IN_FINDER} = true ]; then
    open "${OUTPUT_DIR}/"
fi
