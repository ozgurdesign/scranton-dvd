#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

BUNDLE="Scranton DVD.saver"
BINARY="ScrantonDVD"

rm -rf "$BUNDLE" build_arm64 build_x86_64

mkdir -p "$BUNDLE/Contents/MacOS"
cp Info.plist "$BUNDLE/Contents/"

mkdir -p build_arm64 build_x86_64

swiftc ScrantonDVD.swift \
    -emit-library \
    -module-name ScrantonDVD \
    -framework ScreenSaver -framework AppKit -framework QuartzCore \
    -target arm64-apple-macos13.0 \
    -Xlinker -bundle \
    -o build_arm64/$BINARY

swiftc ScrantonDVD.swift \
    -emit-library \
    -module-name ScrantonDVD \
    -framework ScreenSaver -framework AppKit -framework QuartzCore \
    -target x86_64-apple-macos13.0 \
    -Xlinker -bundle \
    -o build_x86_64/$BINARY

lipo -create build_arm64/$BINARY build_x86_64/$BINARY -output "$BUNDLE/Contents/MacOS/$BINARY"

rm -rf build_arm64 build_x86_64

codesign --force --deep --sign - "$BUNDLE"

mkdir -p "$BUNDLE/Contents/Resources"
swiftc generate_thumbnail.swift -framework AppKit -o generate_thumbnail
./generate_thumbnail "$BUNDLE/Contents/Resources/thumbnail.png"
rm -f generate_thumbnail

codesign --force --deep --sign - "$BUNDLE"

echo "Built: $BUNDLE"
echo ""
echo "Install:"
echo "  open \"$BUNDLE\""
echo "  or: cp -r \"$BUNDLE\" ~/Library/Screen\\ Savers/"
