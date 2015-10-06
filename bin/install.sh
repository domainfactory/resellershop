#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


QUIET=${q:-""}


# Kleiner Header
echo "==========================="
echo " ResellerShop INSTALLATION"
echo "==========================="

# Wohin soll der Ordner ausgecheckt werden?
CHECKOUT_TARGET=${1:-"shop"}

# Existiert der Ordner bereits?
if [ -d "$CHECKOUT_TARGET" ]; then
  echo "Der Ordner $CHECKOUT_TARGET existiert bereits!"
  echo "Bitte geben Sie als weiteren Parameter mit dem Zielpfad an. "
  echo "Beispiel: "
  echo "  $0 shop_dir"
  exit 1
fi


# Sind alle Binaries erreichbar?
echo "Bevor die Installation beginnt, pruefen wir kurz, ob Ihr System allen "
echo "Anforderungen (PHP 5.3+, SCSS 3.3+, GIT) entspricht... "


# Pfad zum PHP binary auslesen
PHP_BINARY=${PHP_BINARY:-}
if [ -z "$PHP_BINARY" ]; then
  if [ `which php5-56STABLE-CLI` ]; then
    PHP_BINARY=php5-56STABLE-CLI
  else
    if [ `which php5` ]; then
      PHP_BINARY=php5
    else
      if [ `which php` ]; then
        PHP_BINARY=php
      else
        echo "Bitte geben Sie den vollstaendigen Pfad zu Ihrer PHP-Binary an: "
        read PHP_BINARY

        if [ `which $PHP_BINARY` ]; then
          echo "Ihr PHP steht in folgender Version zur Verfuegung:" `$PHP_BINARY -v`
          echo "(Es wird mindestens Version 5.3 benoetigt)"
        else
          echo "Konnte $PHP_BINARY nicht ausfuehren, bitte geben Sie den korrekten Pfad an."
          exit 1
        fi
      fi
    fi
  fi
fi


# Pfad zum SCSS-Compiler auslesen
SASS_BINARY=${SASS_BINARY:-}
if [ -z "$SASS_BINARY" ]; then
  if [ `which sass` ]; then
    SASS_BINARY=sass
  else
    echo "Bitte geben Sie den vollstaendigen Pfad zu Ihrem SCSS-Binary an: "
    read SASS_BINARY

    if [ `which $SASS_BINARY` ]; then
      echo "Ihr SASS-Compiler steht in folgender Version zur Verfuegung: " `$SASS_BINARY --version`
      echo "(Es wird mindestens Version 5.3 benoetigt)"
    else
      echo "Konnte $SASS_BINARY nicht ausfuehren, bitte geben Sie den korrekten Pfad an."
      exit 1
    fi
  fi
fi


# Pfad zu GIT auslesen
GIT_BINARY=${GIT_BINARY:-}
if [ -z "$GIT_BINARY" ]; then
  if [ `which git` ]; then
    GIT_BINARY=git
  else
    echo "Bitte geben Sie den vollstaendigen Pfad zu Ihrem GIT-Binary an: "
    read GIT_BINARY

    if [ `which $GIT_BINARY` ]; then
      echo "Konnte $GIT_BINARY nicht ausfuehren, bitte geben Sie den korrekten Pfad an."
      exit 1
    fi
  fi
fi


echo "Alle benoetigten Programme sind vorhanden."
echo "---------------------------"


# Shop-Quelltext via git herunterladen
GIT_LOG_PATH=".install-shop-git.log"
GIT_SOURCE="https://github.com/domainfactory/resellershop"
echo "Erstelle Verzeichnis mit Source im Unterverzeichnis '$CHECKOUT_TARGET'..."
$GIT_BINARY clone -q $GIT_SOURCE $CHECKOUT_TARGET > $GIT_LOG_PATH

# Checkout erfolgreich?
echo ""
if [ -d $CHECKOUT_TARGET ]; then
  echo "Der Code wurde erfolgreich im Unterordner $CHECKOUT_TARGET entpackt!"
else
  echo "Es traten Fehler beim Aufrufen der Shop-Skripte auf. "
  echo "Sie erhalten Details zum Fehler in der Log-Datei des Checkouts unter "
  echo $GIT_LOG_PATH
  echo ""
  echo "Weitere Informationen und Tipps erhalten Sie in unserem Wiki:"
  echo "https://doku.premium-admin.eu/doku.php/handbuch/shop_2.0/installation"
  echo ""
  echo "Die Installation wurde abgebrochen. "
  exit 1
fi
rm -f $GIT_LOG_PATH


# In Zielverzeichnis wechseln
cd $CHECKOUT_TARGET


# Lokalen Branch erstellen
GIT_BRANCH="local"
$GIT_BINARY branch $GIT_BRANCH && $GIT_BINARY checkout $GIT_BRANCH -q


# Erste Schritte
echo "---------------------------"
echo "Wir stellen Ihnen nun ein paar Fragen zur Konfiguration Ihres Shops. "
echo ""
echo "Fuer eine detaillierte Erklaerung der Fragen, oeffnen Sie parallel "
echo "den Wiki-Eintrag zur Schritt-fuer-Schritt-Installation: "
echo "https://doku.premium-admin.eu/doku.php/handbuch/shop_2.0/installation/schritt_fuer_schritt "
echo ""

# Konfigurationsassistenten aufrufen
CONFIG_ERROR_OCCURED=0
$PHP_BINARY -q bin/init-global.php || CONFIG_ERROR_OCCURED=$?

if [ !$CONFIG_ERROR_OCCURED ]; then
  $PHP_BINARY -q bin/color-update.php && /bin/sh bin/scss-compile.sh


  echo "---------------------------"
  echo "Die Installation wurde erfolgreich abgeschlossen."
  echo ""
  echo "Weitere Informationen und Tipps erhalten Sie in unserem Wiki:"
  echo "https://doku.premium-admin.eu/doku.php/handbuch/shop_2.0/installation/naechste_schritte "
  echo ""
  echo "NAECHSTE SCHRITTE: "
  echo "- Installationsroutine entfernen"
  echo "'-- Loeschen Sie die Installationsskripte mit folgendem Befehl: "
  echo "    rm install.sh $CHECKOUT_TARGET/bin/init-global.php "
  echo "'-- Beantworten Sie die zwei Sicherheitsfragen mit der Antwort "
  echo "    y "
  echo "- Schreibrechte pruefen"
  echo "'-- Folgende Dateien muessen vom PHP-Prozess beschreibbar sein:"
  echo "    dist/bb.rpc.cookie"
  echo "    dist/compiled"
  echo "- Personalisierung abschliessen"
  echo "'-- Bearbeiten Sie die $CHECKOUT_TARGET/dist/settings/global.ini, "
  echo "    z.B. mit dem Editor nano:"
  echo "    nano $CHECKOUT_TARGET/dist/settings/global.ini"
  echo "- Inhalte einfuegen"
  echo "'-- Passen Sie die Vorlagen unter $CHECKOUT_TARGET/dist/templates "
  echo "    an Ihre Wuensche und Unternehmensangaben an."
  echo "    Eine genaue Definition und Beschreibung erhalten Sie im Wiki."
  echo "- Webserver einrichten"
  echo "'-- Stellen Sie sicher, dass Ihre Einstellungen vor unbefugtem "
  echo "    Zugriff geschuetzt sind"
  echo ""
  echo "Wir wuenschen Ihnen viel Erfolg mit Ihrem neuen Shop!"
fi
