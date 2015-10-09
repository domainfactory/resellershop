#!/bin/sh

echo "Generiere CSS-Dateien. Dies kann einen Moment dauern, bitte haben Sie Geduld..."

# Aufruf aus Hauptverzeichnis und in bin/ ermöglichen
SOURCE="src/scss"
DIST="dist/css"
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

# Einen zusätzlichen SCSS-Parameter akzeptieren
EXTRA_ARG=${1:-"nothing"}
if [ $EXTRA_ARG == "nothing" ]; then
  EXTRA_ARG=""
fi

LC_ALL=en_US.utf8 sass \
  --unix-newlines \
  --sourcemap=none \
  --style=compressed \
  --load-path $SOURCE \
  $EXTRA_ARG \
  $SOURCE/shop.scss:$DIST/shop.css \
  $SOURCE/fonts-sources.scss:$DIST/fonts-sources.css
