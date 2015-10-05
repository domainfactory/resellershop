#!/bin/sh

echo "Generiere CSS-Dateien. Dies kann einen Moment dauern, bitte haben Sie Geduld..."

LC_ALL=en_US.utf8 sass \
  --unix-newlines \
  --sourcemap=none \
  --style=compressed \
  --load-path src/scss \
  src/scss/shop.scss:dist/css/shop.css \
  src/scss/fonts-sources.scss:dist/css/fonts-sources.css
