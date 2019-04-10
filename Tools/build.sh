#!/usr/bin/env bash
#
# shellcheck disable=SC2140
set -eo pipefail; [[ $DEBUG ]] && set -x

#######################################
# Print out error messages along with other status information.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
err() {
  printf "%s%s%s\n" "${RED}ERROR [$(date +'%Y-%m-%dT%H:%M:%S%z')]: " "$@" "${NORMAL}" >&2
}

#######################################
# Runs a sub command and only outputs the stderr to console, then exits.
# Globals:
#   None
# Arguments:
#   Description of the command to run.
#   The command to run.
# Returns:
#   None
#######################################
run() {
  echo "$1"
  local cmd=${*:2}

  set +o errexit
  local error
  error=$(${cmd} 2>&1 >/dev/null)
  set -o errexit

  if [ -n "$error" ]; then
    err "Error running command: '$cmd':" "$error"
    exit 1
  fi
}

#######################################
# Builds the iOS SDK
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
main() {
  SDK_DIR="$(pwd)/."
  RELEASE_DIR="$SDK_DIR/Release"
  BUILD_DIR="$SDK_DIR/build"
  
  ARM64_DIR="/build-arm64"
  ARMV7S_DIR="/build-armv7s"
  X8664_DIR="/build-x86_64"
  ARMV7_DIR="/build-armv7"
  X86_DIR="/build-x86"
  
  rm -rf "$RELEASE_DIR"
  rm -rf "$BUILD_DIR"
  mkdir -p "$RELEASE_DIR"
  
  # Build Dynamic Framework
  pod install
  build_ios_dylib

  zip_ios_dylib

  rm -rf "$BUILD_DIR"
  rm -rf "$RELEASE_DIR"
  
  echo "${GREEN} Done.${NORMAL}"
}

#######################################
# Builds the iOS dynamic library Target.
# Globals:
#   None
# Arguments:
#   iOS SDK to use - iphoneos or iphonesimulator
#   Architecture to build
#   Build directory for that architecture
# Returns:
#   None
#######################################
run_xcodebuild() {
    run "Building Symphony ($1/$2) target ..." \
      xcodebuild -workspace "Symphony.xcworkspace" -scheme "Symphony" -configuration "Release" -sdk "$1" \
      "clean build" ARCHS="$2" RUN_CLANG_STATIC_ANALYZER=NO BUILD_DIR="${BUILD_DIR}$3" \
      BUILD_ROOT="${BUILD_DIR}" OTHER_CFLAGS="-fembed-bitcode"
}

#######################################
# Combine into universal fat library
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
build_lipo() {

  CURRENTCONFIG_ARMV7_DEVICE_DIR="${BUILD_DIR}${ARMV7_DIR}/Release-iphoneos"
  CURRENTCONFIG_ARM64_DEVICE_DIR="${BUILD_DIR}${ARM64_DIR}/Release-iphoneos"
  CURRENTCONFIG_ARMV7S_DEVICE_DIR="${BUILD_DIR}${ARMV7S_DIR}/Release-iphoneos"
  CURRENTCONFIG_X86_DEVICE_DIR="${BUILD_DIR}${X86_DIR}/Release-iphonesimulator"
  CURRENTCONFIG_X8664_SIMULATOR_DIR="${BUILD_DIR}${X8664_DIR}/Release-iphonesimulator"

  run "Combining builds to universal fat library ..." \
    lipo -create -output "${RELEASE_DIR}/Symphony" \
    "${CURRENTCONFIG_ARMV7_DEVICE_DIR}/Symphony.framework/Symphony" \
    "${CURRENTCONFIG_ARMV7S_DEVICE_DIR}/Symphony.framework/Symphony" \
    "${CURRENTCONFIG_ARM64_DEVICE_DIR}/Symphony.framework/Symphony" \
    "${CURRENTCONFIG_X86_DEVICE_DIR}/Symphony.framework/Symphony" \
    "${CURRENTCONFIG_X8664_SIMULATOR_DIR}/Symphony.framework/Symphony"
}
#######################################
# Builds the iOS dynamic library Target.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
build_ios_dylib() {
  echo "Starting build for Leanplum-SDK (iOS)"

  run_xcodebuild iphoneos armv7 ${ARMV7_DIR}
  run_xcodebuild iphoneos armv7s ${ARMV7S_DIR}
  run_xcodebuild iphoneos arm64 ${ARM64_DIR}
  run_xcodebuild iphonesimulator i386 ${X86_DIR}
  run_xcodebuild iphonesimulator x86_64 ${X8664_DIR}

  build_lipo

  # Copy generated framework
  cp -r "${BUILD_DIR}$ARMV7_DIR/Release-iphoneos/Symphony.framework/" \
    "${RELEASE_DIR}/Symphony.framework"
  rm -f "${RELEASE_DIR}/Symphony.framework/Symphony"
  mv "${RELEASE_DIR}/Symphony" "${RELEASE_DIR}/Symphony.framework/"

  rm -rf "${RELEASE_DIR}/Symphony.framework/_CodeSignature"
  printf "%s\n" "Successfully built Symphony (iOS) Framework.\n"
}

#######################################
# Builds the iOS dynamic library Target.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
zip_ios_dylib() {
  cd "${RELEASE_DIR}"
  zip -r Symphony.framework.zip Symphony.framework
  mv Symphony.framework.zip "$SDK_DIR"
}

main "$@"
