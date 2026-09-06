#!/bin/sh
# Xcode exports targets for other platforms; clang's debug-framework invocation
# has no explicit target and interprets these as conflicting deployment targets.
unset IPHONEOS_DEPLOYMENT_TARGET TVOS_DEPLOYMENT_TARGET
unset WATCHOS_DEPLOYMENT_TARGET XROS_DEPLOYMENT_TARGET DRIVERKIT_DEPLOYMENT_TARGET
exec "$FLUTTER_ROOT/packages/flutter_tools/bin/macos_assemble.sh" "$@"
