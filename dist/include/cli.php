<?php

function ask($sQuestion) {
  say($sQuestion);
  $sInput = str_replace('"',"'",trim(getCliInput()));
  say();
  return $sInput;
}

function askUrl($sQuestion) {
  $sInput = ask($sQuestion);
  while ( !preg_match('#^https?://([-\w\.]+)+(:\d+)?(/([\w/_\.]*(\?\S+)?)?)?$#i', $sInput) ) {
    $sInput = ask(array(
      "Sie haben keine URL angegeben. Bitte geben Sie eine vollstaendige URL ",
      "mit Protokoll (https) an: (Beispiel: https://www.reseller-shop.eu) ",
    ));
  }
  if ( substr($sInput, -1) !== '/' ) {
    $sInput .= '/';
  }
  return $sInput;
}

function askColor($sQuestion) {
  $sInput = ask($sQuestion);
  while ( !preg_match('/^#[0-9a-f]{6}$/i', $sInput) ) {
    $sInput = ask(array(
      "Bitte geben Sie einen sechsstelligen Farbcode mit fuehrender Raute an: ",
      "(Beispiel fuer Farbe Petrol: #027a8b) ",
    ));
  }
  return $sInput;
}

function askBool($sQuestion) {
  say($sQuestion);
  $sInput = getCliBool();
  say();
  return $sInput;
}

function say($sWhat = '') {
  if ( is_array($sWhat) ) {
    $sWhat = implode(PHP_EOL, $sWhat);
  }
  echo $sWhat.PHP_EOL;
  return true;
}

function getCliInput() {
  if ( function_exists('readline') ) {
    return readline("> ");
  }
  echo "> ";
  return stream_get_line(STDIN, 1024, PHP_EOL);
}

function getCliBool() {
  return (in_array(strtolower(trim(getCliInput())), array('y','j','ja','aj','jaa','jja','yes','yess','yse','eys','jo','jep','yeah','yeaah','joa','scho','doch','eh','si','oui')))
          ? 'true'
          : 'false';
}


function updateGlobalSettings($hSettingsToSet) {
  // Welche Datei soll beschrieben werden?
  $sPathToGlobal = DIR_SETTINGS.'global.ini';

  $asPlaceholdersToReplace = array();
  $iEmptyValues = 0;
  $iSettingsToReplace = 0;
  foreach ( $hSettingsToSet as $sPlaceholder => $sUserInput ) {
    $asPlaceholdersToReplace[] = '{{'.$sPlaceholder.'}}';
    $iSettingsToReplace++;
    if ( strlen($sUserInput) === 0 ) {
      $iEmptyValues++;
    }
  }
  // Keine Einstellungen vorgenommen -> nichts ersetzen
  if ( $iSettingsToReplace === 0 || $iSettingsToReplace === $iEmptyValues ) {
    say("Es werden keine Aendungen vorgenommen. ");
    return false;
  }

  $sCurrentSettings = file_get_contents($sPathToGlobal);
  if ( !$sCurrentSettings ) {
    say("Die Einstellungen konnten nicht zur Bearbeitung geoeffnet werden. ");
    return false;
  }

  // Einstellungen zum U
  $sNewSettings = str_replace($asPlaceholdersToReplace, $hSettingsToSet, $sCurrentSettings);
  if ( $sNewSettings !== $sCurrentSettings && strlen($sNewSettings) ) {
    file_put_contents($sPathToGlobal, $sNewSettings);
    say("Einstellungen gespeichert. ");
  }
}


function updateGlobalConfig($hSettingsToSet) {
  // Welche Datei soll beschrieben werden?
  $sPathToGlobal = DIR_SETTINGS.'global.ini';

  // Aktuellen Inhalt lesen?
  $sGlobalContent = file($sPathToGlobal);

  $bColorSectionStarted = false;
  $asSettingFields = array_keys($hSettingsToSet);
  $iChangesToMake = count($hSettingsToSet);
  $iChanges = 0;

  // Inhalte in relevanten Zeilen anpassen
  foreach ( $sGlobalContent as $iLineNr => $sLine ) {
    // Wir befinden uns im colors-Bereich
    if ( $bColorSectionStarted ) {
      $sLine = trim($sLine);

      // Inhalt der Einstellung austauschen
      foreach ( $asSettingFields as $sSetting ) {
        if ( substr($sLine, 0, strlen($sSetting)) == $sSetting ) {
          $sGlobalContent[$iLineNr] = $sSetting.'='.$hSettingsToSet[$sSetting];
          $iChanges++;
          break;
        }
      }
      unset($sSetting);

      // Alle geplanten Änderungen wurden vorgenommen
      if ( $iChanges === $iChangesToMake ) {
        break;
      }

    // Befinden wir uns im colors-Bereich?
    } elseif ( trim($sLine) === '[colors]' ) {
      $bColorSectionStarted = true;
    }
  }

  // Datei schreiben
  if ( count($sGlobalContent) ) {
    file_put_contents($sPathToGlobal, $sGlobalContent);
  }
}

