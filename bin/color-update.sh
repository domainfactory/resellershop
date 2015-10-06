#!/bin/bash

if [ `which php5-56STABLE-CLI` ] ; then
  php5-56STABLE-CLI -q bin/color-update.php
else
  if [ `which php5` ] ; then
    php5 -q bin/color-update.php
  else
    if [ `which php` ] ; then
      php -q bin/color-update.php
    else
      echo "Konnte PHP-Binary nicht finden."
      echo "Bitte rufen Sie die 'bin/color-update.php' mit Ihrer PHP-CLI auf, "
      echo "z.B. via 'php5 bin/color-update.php'"
      echo "und fuehren Sie danach die 'bin/scss-compile' aus."
      exit 1
    fi
  fi
fi

echo ""
/bin/bash bin/scss-compile.sh
