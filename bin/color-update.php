<?php

// Globale Skripte einbinden
require_once(dirname(__FILE__).'/../dist/include/autoloader.php');
require_once(DIR_INCLUDE.'cli.php');

say(array(
  'Anhand Ihrer Angaben in der dist/settings/global.ini werden ',
  'nun die CSS-Dateien generiert und Grafiken eingefaerbt. ',
  '',
));

$hColors = getColors();
if ( $hColors ) {
  writeSassConfig($hColors);
  updateSVGImages($hColors);
}


  //////////////////////// FUNKTIONEN //////////////////////////


/**
 * Farbeinstellungen des Benutzers auslesen
 *
 * @return array        Farbwerte aus der global.ini als Array
 */
function getColors() {
  // Einstellungen aus der global.ini auslesen
  $hColors = Settings::getValue('global', 'colors');
  if ( !$hColors ) {
    say("Farbeinstellungen konnten nicht ausgelesen werden");
    return false;
  }

  $hSettingsToChange = array();

  // Hauptfarbe nicht vorhanden -> Alles abbrechen
  if ( !array_key_exists('main', $hColors) || $hColors['main'] === '{{hauptfarbe}}' ) {
    say('Es fehlt die Hauptfarbe in der global.ini! ');
    say('Bitte stellen Sie sicher, dass ein Bereich [colors] vorhanden ist. ');
    say('Setzen Sie darunter eine Zeile mit dem Inhalt main="#<ihrefarbe>". ');
    say('Beispiel: ');
    say('main="#027a8b"');

    // Nach Hauptfarbe fragen
    $sMainColor = null;
    do {
      if ( $sMainColor !== null ) {
        say('Ihre angegebene Farbe ist keine Hex-Farbe.');
      }
      $sMainColor = ask("Bitte geben Sie Ihre Hauptfarbe im Format #rrggbb an: ");
    } while ( !preg_match('/^#[0-9a-z]{3}([0-9a-z]{3})?$/i', $sMainColor) );
    $hColors['main'] = $sMainColor;
    $hSettingsToChange['main'] = '"'.$sMainColor.'"';
  }

  // Akzentfarbe nicht angegeben -> Hauptfarbe uebernehmen
  if ( !array_key_exists('accent', $hColors) || $hColors['accent'] === '{{akzentfarbe}}' ) {
    say('Es wurde keine Akzentfarbe angegeben. Verwende Hauptfarbe als Akzentfarbe. ');
    say('Damit eine Akzentfarbe verwendet werden kann, muss in der global.ini ');
    say('eine Zeile mit dem Inhalt accent="#<ihrefarbe>" vorhanden sein. ');
    say('Beispiel: ');
    say('accent="#f59000"');

    // Nach Akzentfarbe fragen
    $sAccentColor = null;
    do {
      if ( $sAccentColor !== null ) {
        say('Ihre angegebene Farbe ist keine Hex-Farbe.');
      }
      $sAccentColor = ask("Bitte geben Sie Ihre Akzentfarbe im Format #rrggbb an: ");
    } while ( !preg_match('/^#[0-9a-z]{3}([0-9a-z]{3})?$/i', $sAccentColor) );
    $hColors['accent'] = $sAccentColor;
    $hSettingsToChange['accent'] = '"'.$sAccentColor.'"';
  }

  // Darkmode nicht angegeben -> nicht aktivieren
  if ( !array_key_exists('darkmode', $hColors) || $hColors['darkmode'] === '{{farben-invertieren}}' ) {
    say('In den Einstellungen fehlt die Angabe der Invertierung. ');
    say('Soll der Text weiss auf schwarz dargestellt werden? (y/n): ');
    $hColors['darkmode'] = getCliBool();
    $hSettingsToChange['darkmode'] = $hColors['darkmode'] ? 'true' : 'false';
  }

  // Farbcode-Angaben auch in der global.ini uebernehmen
  if ( count($hSettingsToChange) > 0 ) {
    updateGlobalConfig($hSettingsToChange);
  }

  return $hColors;
}


/**
 * SASS-Datei mit den korrekten Variablen schreiben
 *
 * @param array $hColors        Farbwerte des Benutzers
 * @return bool                 War das Überschreiben der ci.scss erfolgreich?
 */
function writeSassConfig($hColors) {
  $sDarkmode = $hColors['darkmode'] ? "true" : "false";

  // Inhalte der SCSS-Datei auslesen
  $sFileContent = <<<SASS
    // Diese Datei wurde automatisch durch die bin/color-update.php generiert.
    // Bitte führen Sie KEINE manuellen Änderungen an dieser Datei durch!
    //
    // Wir empfehlen Ihnen, eigene Variablen, die in allen SCSS-Dateien zur
    // Verfügung stehen sollen, in der src/scss/_global.scss zu definieren.
    \$color-main: {$hColors['main']};
    \$color-accent: {$hColors['accent']};
    \$color-darkmode: {$sDarkmode};
SASS;

  // Wohin soll die Datei gespeichert werden?
  $sWriteTarget = DIR_SRC_SCSS.'_ci.scss';

  $bCreateFile = file_exists($sWriteTarget);

  if ( !file_put_contents($sWriteTarget, $sFileContent) ) {
    say('writeSassConfig: Konnte '.$sWriteTarget.' nicht mit den neuen Farben ueberschreiben');
    return false;
  }

  if ( $bCreateFile ) {
    say(array(
      'Die CSS-Datei mit Ihren Farbeinstellungen wurde angelegt und befindet sich unter: ',
      $sWriteTarget,
      '',
    ));
  } else {
    say('CSS-Datei mit Farbeinstellungen wurde aktualisiert.');
  }

  return true;
}


function getRgb($sColor, $fSaturation, $fLightness, $hColorData) {
  $h = $hColorData['hsl'][$sColor]['h'];
  $s = ($hColorData['hsl'][$sColor]['s'] > 0.01) ? $fSaturation : 0;
  $l = ($hColorData['colors']['darkmode']) ? (100 - $fLightness) : $fLightness;

  return hsl2rgb($h, $s, $l);
}


/**
 * Überschreiben der Farben in den SVG-Dateien
 *
 * @param array $hColors        Farbwerte des Benutzers
 */
function updateSVGImages($hColors) {
  // HSL-Daten der Hauptfarbe auslesen
  $hColorData = array(
    'colors' => $hColors,
    'base_hue' => 187,
    'hsl' => array(
      'main' => rgb2hsl($hColors['main']),
      'accent' => rgb2hsl($hColors['accent']),
    ),
  );
  $bDarkmode = $hColors['darkmode'];

  $hColorData['hex'] = array(
    '#000000' => ($bDarkmode ? "#FEFEFE" : "#000000"),
    //'#0023A0' => getRgb('main'   , 100,   31.37, $hColorData),
    '#003473' => getRgb('main'   , 100,   22.55, $hColorData),
    '#0084B6' => getRgb('main'   , 100,   35.69, $hColorData),
    '#0283B4' => $hColors['main'],
    '#030202' => getRgb('main'   , 20,    0.98,  $hColorData),
    '#080000' => getRgb('main'   , 100,   1.57,  $hColorData),
    '#333333' => getRgb('main'   , 0,     20,    $hColorData),
    '#525252' => getRgb('main'   , 0,     32.16, $hColorData),
    '#57534C' => getRgb('accent' , 6.75,  31.96, $hColorData),
    '#586C7A' => getRgb('main'   , 16.19, 41.18, $hColorData),
    //'#5D798A' => getRgb('main' , 19.48, 45.29, $hColorData),
    '#5D798A' => getRgb('main'   , 16.19, 41.18, $hColorData),
    '#767677' => getRgb('main'   , 0.42,  46.47, $hColorData),
    '#99D4E7' => getRgb('main'   , 61.90, 75.29, $hColorData),
    //'#9ACDEC' => getRgb('main' , 68.33, 76.47, $hColorData),
    '#9ACDEC' => getRgb('main'   , 62.90, 75.69, $hColorData),
    '#9ACEE8' => getRgb('main'   , 62.90, 75.69, $hColorData),
    '#9acee8' => getRgb('main'   , 62.90, 75.69, $hColorData),
    '#9BD4E3' => getRgb('main'   , 56.25, 74.90, $hColorData),
    '#9EB9C2' => getRgb('main'   , 22.29, 69.22, $hColorData),
    '#9FB9C2' => getRgb('main'   , 22.29, 69.22, $hColorData),
    '#A6A6A7' => getRgb('main'   , 0.57,  65.29, $hColorData),
    '#B8B7B7' => getRgb('main'   , 0.7,   71.96, $hColorData),
    '#CFCED2' => getRgb('main'   , 4.26,  81.57, $hColorData),
    '#D0D0D0' => getRgb('main'   , 0,     81.57, $hColorData),
    '#ED1C2E' => getRgb('main'   , 85.31, 51.96, $hColorData),
    //'#EF8E0E' => getRgb('accent' , 88.93, 49.61, $hColorData),
    //'#F08F0E' => getRgb('accent' , 88.98, 49.80, $hColorData),
    //'#F18F09' => getRgb('accent' , 92.8,  49.02, $hColorData),
    '#EF8E0E' => $hColors['accent'],
    '#F08F0E' => $hColors['accent'],
    '#F18F09' => $hColors['accent'],
    '#f3f3f2' => getRgb('main', 4, 95.10, $hColorData),
    '#F4F4F3' => getRgb('main', 4, 95.10, $hColorData),
    //'#FA8A3B' => getRgb('accent', 95.02, 60.59, $hColorData),
    //'#FCB131' => getRgb('accent', 97.13, 59.02, $hColorData),
    //'#FFA000' => getRgb('accent', 100, 50, $hColorData),
    '#FA8A3B' => $hColors['accent'],
    '#FCB131' => $hColors['accent'],
    '#FFA000' => $hColors['accent'],
    '#FFFFFF' => ($bDarkmode ? "#010101" : "#FFFFFF"),
    '#010101' => "#000000",
    '#FEFEFE' => "#FFFFFF",
    '#A1D7DE' => getRgb('main'   , 48,    75,    $hColorData),
    '#AEDAE0' => getRgb('main'   , 44,    78,    $hColorData),
    '#BAE3E8' => getRgb('main'   , 50,    82,    $hColorData),
    '#BFE4E8' => getRgb('main'   , 48,    83,    $hColorData),
    '#C6E7EB' => getRgb('main'   , 49,    85,    $hColorData),
    '#C9E9ED' => getRgb('main'   , 50,    86,    $hColorData),
    '#CAE4E8' => getRgb('main'   , 39,    85,    $hColorData),
    '#D9EFF2' => getRgb('main'   , 50,    90,    $hColorData),
    '#E6F7F9' => getRgb('main'   , 63,    94,    $hColorData),
  );
  $hColorData['replace'] = array(
    'search' => array_keys($hColorData['hex']),
    'replace' => array_values($hColorData['hex']),
  );


  updateHexImage($hColorData, 'header/bg.svg');
  updateHexImage($hColorData, 'sprite-shop.svg');
  updateHexImage($hColorData, 'domains/illustration.svg');
  updateHexImage($hColorData, 'header/addons.svg');
  updateHexImage($hColorData, 'header/hero.svg');
  updateHexImage($hColorData, 'header/service.svg');
  updateHexImage($hColorData, 'header/tariff.svg');
  updateHexImage($hColorData, 'references/sprite.svg');
}


function updateHexImage($hColorData, $sFilePath) {
  $sTargetFileLocation = DIR_IMAGES.$sFilePath;
  $sFileContent = getFileContents($sFilePath);
  if ( !$sFileContent ) {
    return false;
  }

  // Ursprünglichen Hue-Wert durch Wert der CI-Farbe ersetzen
  $sFileContent = str_replace($hColorData['replace']['search'], $hColorData['replace']['replace'], $sFileContent);

  // Neue Dateiinhalte in Zielgrafik schreiben
  if ( !file_put_contents($sTargetFileLocation, $sFileContent) ) {
    say('Grafik konnte nicht ueberschrieben werden: '.$sTargetFileLocation);
    return false;
  }

  say("Grafik eingefaerbt: ".$sTargetFileLocation);
  return true;
}


function getFileContents($sFilePath) {
  $sBaseFileLocation = DIR_SRC_IMAGES.$sFilePath;
  $sTargetFileLocation = DIR_IMAGES.$sFilePath;

  // Sicherstellen, dass die Original-Grafik gelesen werden kann
  if ( !is_readable($sBaseFileLocation) ) {
    say('Original-Grafik "'.$sFilePath.'" kann nicht gelesen werden. ');
    say('Bitte stellen Sie sicher, dass sich unter '.$sBaseFileLocation.' ');
    say('die ursprüngliche Grafik zur Bearbeitung der Farben befindet.');
    say("Ursprungsgrafik nicht lesbar.");
    return false;
  }

  // Wenn die Grafik nicht überschrieben werden darf, sparen wir uns doch die Arbeit
  if ( !is_writable($sTargetFileLocation) ) {
    say('Grafik "'.$sFilePath.'" darf nicht überschrieben werden. ');
    say('Stellen Sie bitte sicher, dass der PHP-Prozess genügend Schreibrechte für ');
    say($sTargetFileLocation);
    say(' besitzt.');
    say('Zielgrafik nicht beschreibbar');
    return false;
  }

  // Inhalte der Datei auslesen
  $sFileContent = file_get_contents($sBaseFileLocation);
  if ( !$sFileContent ) {
    say("Ursprungsgrafik leer? ".$sBaseFileLocation);
    return false;
  }

  return $sFileContent;
}



  //////////////////////// RGB/HSL //////////////////////////

  // Folgender Quelltext wurde von Brandon Heyer übernommen
  // und an die Verwendung von Hex-Codes angepasst
  // siehe http://www.brandonheyer.com/2013/03/27/convert-hsl-to-rgb-and-rgb-to-hsl-via-php/


/**
 * RGB-Konvertierung zu HSL
 *
 * @param string $sHexCode      Hexadezimaler Farbcode
 * @return array
 */
function rgb2hsl( $sHexCode ) {
  // Raute des Hexcodes am Anfang entfernen
  if ( substr($sHexCode, 0, 1) === '#' ) {
    $sHexCode = substr($sHexCode, 1);
  }

  if ( strlen($sHexCode) <= 3 ) {
    $r = hexdec(substr($sHexCode, 0, 1));
    $g = hexdec(substr($sHexCode, 1, 1));
    $b = hexdec(substr($sHexCode, 2, 1));
  } else {
    $r = hexdec(substr($sHexCode, 0, 2));
    $g = hexdec(substr($sHexCode, 2, 2));
    $b = hexdec(substr($sHexCode, 4, 2));
  }

  $r /= 255;
  $g /= 255;
  $b /= 255;

  $max = max( $r, $g, $b );
  $min = min( $r, $g, $b );

  $h;
  $s;
  $l = ( $max + $min ) / 2;
  $d = $max - $min;

  if ( $d == 0 ) {
    $h = $s = 0; // achromatic
  } else {
    $s = $d / ( 1 - abs( 2 * $l - 1 ) );

    switch ( $max ) {
      case $r:
        $h = 60 * fmod( ( ( $g - $b ) / $d ), 6 );
        if ($b > $g) {
          $h += 360;
        }
        break;

      case $g:
        $h = 60 * ( ( $b - $r ) / $d + 2 );
        break;

      case $b:
        $h = 60 * ( ( $r - $g ) / $d + 4 );
        break;
    }
  }

  return array(
    'h' => round( $h, 2 ),
    's' => round( $s, 2 ),
    'l' => round( $l, 2 ),
  );
}


/**
 * HSL-Konvertierung zu RGB
 *
 * @param int $h        Hue (255-Basis)
 * @param int $s        Saturation
 * @param int $l        Lightness
 * @return array
 */
function hsl2rgb( $h, $s, $l ){
  $r;
  $g;
  $b;

  $s = $s / 100;
  $l = $l / 100;

  $c = ( 1 - abs( 2 * $l - 1 ) ) * $s;
  $x = $c * ( 1 - abs( fmod( ( $h / 60 ), 2 ) - 1 ) );
  $m = $l - ( $c / 2 );

  if ( $h < 60 ) {
    $r = $c;
    $g = $x;
    $b = 0;
  } elseif ( $h < 120 ) {
    $r = $x;
    $g = $c;
    $b = 0;
  } elseif ( $h < 180 ) {
    $r = 0;
    $g = $c;
    $b = $x;
  } elseif ( $h < 240 ) {
    $r = 0;
    $g = $x;
    $b = $c;
  } elseif ( $h < 300 ) {
    $r = $x;
    $g = 0;
    $b = $c;
  } else {
    $r = $c;
    $g = 0;
    $b = $x;
  }

  $r = floor( ( $r + $m ) * 255 );
  $g = floor( ( $g + $m ) * 255 );
  $b = floor( ( $b + $m ) * 255 );

  $r = (($r < 16) ? "0" : "") . dechex($r);
  $g = (($g < 16) ? "0" : "") . dechex($g);
  $b = (($b < 16) ? "0" : "") . dechex($b);

  return ('#'.$r.$g.$b);
}

