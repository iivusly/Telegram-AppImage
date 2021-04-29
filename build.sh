#!/bin/bash

set -u
curl https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest > /tmp/telegram.json
cat /tmp/telegram.json| jq '.assets[].browser_download_url' | grep tsetup | grep tar
wget "$(cat /tmp/telegram.json| jq -r '.assets[].browser_download_url' | grep tsetup | grep tar)"
VERSION="$(cat /tmp/telegram.json| jq -r .tag_name)"



APPDIR=AppDir
mkdir -p $APPDIR
echo "TELEGRAM_VERSION=$VERSION" >> $GITHUB_ENV
tar -xvf *.tar.xz && rm -rf *.tar.xz
mv Telegram/Telegram $APPDIR/.
cp telegram.png $APPDIR/.
cp telegram.desktop $APPDIR/.
ln -sr $APPDIR/Telegram $APPDIR/AppRun

wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x *.AppImage
echo "AppDir: $APPDIR"
ls -al
ls -al "$APPDIR"
./appimagetool-x86_64.AppImage --comp gzip "$APPDIR" -n -u 'gh-releases-zsync|srevinsaju|Telegram-AppImage|continuous|Telegram*.AppImage.zsync'
mkdir dist
mv Telegram*.AppImage* dist/.