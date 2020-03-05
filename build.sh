#!/bin/bash
MAILSPRING_REPO='Foundry376/Mailspring'
LATEST_RELEASE=`curl --silent "https://api.github.com/repos/$MAILSPRING_REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
PKGBUILD_VERSION=`cat PKGBUILD|egrep "^pkgver="`
EXISTING_SHA256SUM=`cat PKGBUILD|egrep "^sha256sums_x86_64"`

rm -rf mailspring-*-amd64.deb mailspring-*.pkg.tar.xz pkg src

sed -i "s/$PKGBUILD_VERSION/pkgver=$LATEST_RELEASE/" PKGBUILD
wget "https://github.com/Foundry376/Mailspring/releases/download/$LATEST_RELEASE/mailspring-$LATEST_RELEASE-amd64.deb"
SHA256SUM=`sha256sum "mailspring-$LATEST_RELEASE-amd64.deb"|cut -d' ' -f1`
sed -i "s/$EXISTING_SHA256SUM/sha256sums_x86_64=('$SHA256SUM')/" PKGBUILD

makepkg -i
