#!/bin/bash

# Build script for Time Progress
# This script builds and packages the app for distribution

set -e

# Configuration
APP_NAME="Time Progress"
BUNDLE_ID="com.berkaygure.time-progress"
VERSION=${1:-"1.0.0"}
BUILD_DIR="build"
ARCHIVE_PATH="$BUILD_DIR/TimeProgress.xcarchive"
EXPORT_PATH="$BUILD_DIR/Release"
DMG_NAME="TimeProgress-${VERSION}.dmg"

echo "🚀 Building Time Progress v${VERSION}..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build the app
echo "🔨 Building app..."
xcodebuild clean build \
    -scheme time-progress \
    -configuration Release \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

# Find the built app
APP_PATH=$(find "$BUILD_DIR/DerivedData" -name "*.app" -type d -depth 1 | head -n 1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Error: Could not find built app"
    exit 1
fi

echo "✅ App built successfully at: $APP_PATH"

# Create distribution directory
mkdir -p "$EXPORT_PATH"

# Copy app to export directory
cp -R "$APP_PATH" "$EXPORT_PATH/"

# Create DMG
echo "📦 Creating DMG..."
hdiutil create -volname "Time Progress" \
    -srcfolder "$EXPORT_PATH" \
    -ov -format UDZO \
    "$BUILD_DIR/$DMG_NAME"

echo "✅ DMG created: $BUILD_DIR/$DMG_NAME"

# Create ZIP for Homebrew
echo "📦 Creating ZIP archive..."
cd "$EXPORT_PATH"
zip -r "../TimeProgress-${VERSION}.zip" "time-progress.app"
cd - > /dev/null

echo "✅ ZIP created: $BUILD_DIR/TimeProgress-${VERSION}.zip"

# Calculate SHA256
echo "🔐 Calculating SHA256..."
SHA256=$(shasum -a 256 "$BUILD_DIR/TimeProgress-${VERSION}.zip" | awk '{print $1}')
echo "SHA256: $SHA256"

# Save release info
cat > "$BUILD_DIR/release-info.txt" << EOF
Version: $VERSION
ZIP: TimeProgress-${VERSION}.zip
DMG: $DMG_NAME
SHA256: $SHA256
EOF

echo ""
echo "🎉 Build complete!"
echo ""
echo "📋 Release Information:"
echo "  Version: $VERSION"
echo "  ZIP: $BUILD_DIR/TimeProgress-${VERSION}.zip"
echo "  DMG: $BUILD_DIR/$DMG_NAME"
echo "  SHA256: $SHA256"
echo ""
echo "📝 Next steps:"
echo "  1. Create a GitHub release (tag: v${VERSION})"
echo "  2. Upload TimeProgress-${VERSION}.zip to the release"
echo "  3. Copy the SHA256 hash for the Homebrew formula"
echo ""
