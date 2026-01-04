#!/bin/bash

# Build script for Time Progress
# This script builds and packages the app for distribution

set -e

# Configuration
APP_NAME="time-progress"
VERSION=${1:-"1.0.0"}
BUILD_DIR="build"

echo "🚀 Building Time Progress v${VERSION}..."
echo "📂 Current directory: $(pwd)"

# Find the Xcode project or workspace
if [ -f "time-progress.xcworkspace" ]; then
    PROJECT_FILE="time-progress.xcworkspace"
    BUILD_FLAG="-workspace"
    echo "✅ Found workspace: $PROJECT_FILE"
elif [ -f "time-progress.xcodeproj/project.pbxproj" ]; then
    PROJECT_FILE="time-progress.xcodeproj"
    BUILD_FLAG="-project"
    echo "✅ Found project: $PROJECT_FILE"
else
    echo "❌ Error: Could not find time-progress.xcodeproj or time-progress.xcworkspace"
    echo ""
    echo "Contents of current directory:"
    ls -la
    echo ""
    echo "Please make sure you run this script from your project root directory."
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build the app
echo "🔨 Building app..."
xcodebuild clean build \
    $BUILD_FLAG "$PROJECT_FILE" \
    -scheme time-progress \
    -configuration Release \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

# Find the built app
echo "🔍 Searching for built app..."
APP_PATH=$(find "$BUILD_DIR/DerivedData" -name "*.app" -type d | head -n 1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Error: Could not find built app"
    echo "Searching in: $BUILD_DIR/DerivedData"
    echo ""
    echo "Contents of DerivedData:"
    find "$BUILD_DIR/DerivedData" -name "*.app" -type d
    echo ""
    echo "All files:"
    find "$BUILD_DIR/DerivedData" -type f -name "time-progress*"
    exit 1
fi

echo "✅ App built successfully at: $APP_PATH"

# Create distribution directory
EXPORT_PATH="$BUILD_DIR/Release"
mkdir -p "$EXPORT_PATH"

# Copy app to export directory
echo "📦 Copying app to export directory..."
cp -R "$APP_PATH" "$EXPORT_PATH/"

# Create ZIP for Homebrew
echo "📦 Creating ZIP archive..."
cd "$EXPORT_PATH"
zip -r "../TimeProgress-${VERSION}.zip" "time-progress.app"
cd - > /dev/null

echo "✅ ZIP created: $BUILD_DIR/TimeProgress-${VERSION}.zip"

# Create DMG
echo "📦 Creating DMG..."
hdiutil create -volname "Time Progress" \
    -srcfolder "$EXPORT_PATH" \
    -ov -format UDZO \
    "$BUILD_DIR/TimeProgress-${VERSION}.dmg"

echo "✅ DMG created: $BUILD_DIR/TimeProgress-${VERSION}.dmg"

# Calculate SHA256
echo "🔐 Calculating SHA256..."
SHA256=$(shasum -a 256 "$BUILD_DIR/TimeProgress-${VERSION}.zip" | awk '{print $1}')

# Save release info
cat > "$BUILD_DIR/release-info.txt" << EOF
Version: $VERSION
ZIP: TimeProgress-${VERSION}.zip
DMG: TimeProgress-${VERSION}.dmg
SHA256: $SHA256

Homebrew Formula Update:
  version "$VERSION"
  sha256 "$SHA256"
EOF

echo ""
echo "🎉 Build complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Release Information:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Version: $VERSION"
echo "  ZIP:     $BUILD_DIR/TimeProgress-${VERSION}.zip"
echo "  DMG:     $BUILD_DIR/TimeProgress-${VERSION}.dmg"
echo ""
echo "  SHA256:  $SHA256"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  1. Create GitHub release (tag: v${VERSION})"
echo "  2. Upload: $BUILD_DIR/TimeProgress-${VERSION}.zip"
echo "  3. Upload: $BUILD_DIR/TimeProgress-${VERSION}.dmg (optional)"
echo ""
echo "  4. Update Homebrew formula with:"
echo "     version \"$VERSION\""
echo "     sha256 \"$SHA256\""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
