#!/bin/bash
set -e

# Only set when not running in an Xcode context
if [ -z "$ACTION" ] || [ -z "$BUILD_DIR" ]; then
  export CC="$(xcrun -find -sdk iphoneos cc) -arch armv7 -isysroot $(xcrun -sdk iphoneos --show-sdk-path)"
fi

./configure --host arm-apple-darwin

# Fix build for tvOS
cat << EOF >> src/config.h

/* Add in so we have Apple Target Conditionals */
#ifdef __APPLE__
#include <TargetConditionals.h>
#include <Availability.h>
#endif

/* Special configuration for AppleTVOS */
#if TARGET_OS_TV
#undef HAVE_SYSCALL_H
#undef HAVE_SYS_SYSCALL_H
#undef OS_MACOSX
#endif
EOF
