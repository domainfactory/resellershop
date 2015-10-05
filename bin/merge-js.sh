#!/bin/sh
SOURCE=${1:-"src/js"}
DIST=${2:-"dist/js"}

if [ -d $SOURCE ]; then
  SOURCE=$SOURCE
else
  SOURCE="../$SOURCE"
fi
if [ -d $DIST ]; then
  DIST=$DIST
else
  DIST="../$DIST"
fi

# Bestehende Datei entfernen
rm $DIST/shop.js

# Neue Dateien einfuegen
touch $DIST/shop.js
cat $SOURCE/jquery.js >> $DIST/shop.js
cat $SOURCE/rpc.js >> $DIST/shop.js
cat $SOURCE/ui.js >> $DIST/shop.js
cat $SOURCE/forms.js >> $DIST/shop.js
cat $SOURCE/toggle.js >> $DIST/shop.js
cat $SOURCE/cart.js >> $DIST/shop.js
cat $SOURCE/whois.js >> $DIST/shop.js
