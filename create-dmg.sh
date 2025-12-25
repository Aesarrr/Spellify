#!/bin/bash
cd "$(dirname "$0")"

APP_NAME="Spellify"
DMG_NAME="Spellify-Installer"
VOLUME_NAME="Spellify"

echo "Сборка..."
swift build -c release

if [ $? -ne 0 ]; then
    echo "Ошибка сборки"
    exit 1
fi

rm -rf "$APP_NAME.app"
mkdir -p "$APP_NAME.app/Contents/MacOS"
mkdir -p "$APP_NAME.app/Contents/Resources"

echo "Создание иконки..."
ICONSET="AppIcon.iconset"
rm -rf "$ICONSET"
mkdir -p "$ICONSET"
cp macos/icon_16x16.png "$ICONSET/icon_16x16.png"
cp macos/icon_16x16@2x.png "$ICONSET/icon_16x16@2x.png"
cp macos/icon_32x32.png "$ICONSET/icon_32x32.png"
cp macos/icon_32x32@2x.png "$ICONSET/icon_32x32@2x.png"
cp macos/icon_128x128.png "$ICONSET/icon_128x128.png"
cp macos/icon_128x128@2x.png "$ICONSET/icon_128x128@2x.png"
cp macos/icon_256x256.png "$ICONSET/icon_256x256.png"
cp macos/icon_256x256@2x.png "$ICONSET/icon_256x256@2x.png"
cp macos/icon_512x512.png "$ICONSET/icon_512x512.png"
cp macos/icon_512x512@2x.png "$ICONSET/icon_512x512@2x.png"
iconutil -c icns "$ICONSET" -o "$APP_NAME.app/Contents/Resources/AppIcon.icns"
rm -rf "$ICONSET"

cp .build/release/TextFixer "$APP_NAME.app/Contents/MacOS/Spellify"

cat > "$APP_NAME.app/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Spellify</string>
    <key>CFBundleIdentifier</key>
    <string>com.spellify.app</string>
    <key>CFBundleName</key>
    <string>Spellify</string>
    <key>CFBundleDisplayName</key>
    <string>Spellify</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "Создание DMG..."

rm -rf dmg_temp
mkdir -p dmg_temp
cp -r "$APP_NAME.app" dmg_temp/
ln -s /Applications dmg_temp/Applications

rm -f "$DMG_NAME.dmg"

hdiutil create -volname "$VOLUME_NAME" \
    -srcfolder dmg_temp \
    -ov -format UDZO \
    "$DMG_NAME.dmg"

rm -rf dmg_temp

echo ""
echo "Готово! Создан: $DMG_NAME.dmg"
