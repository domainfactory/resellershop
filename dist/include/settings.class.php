<?php

class Settings {

  // Cache der einzelnen Dateiinhalte
  protected static $cache = array();

  // Liste der nicht erreichbaren Dateien
  private static $missingFiles = array();


  /**
   * Inhalte aus Einstellungs-INI-Datei auslesen
   *
   * @param string $sName - Name der auszulesenden INI-Datei
   * @return array
   */
  public static function get($sName) {
    // Pfad zur auszulesenden Einstellungs-INI
    $sFile = DIR_SETTINGS . $sName . '.ini';

    // Existiert die Einstellungs-INI und darf sie von PHP ausgelesen werden?
    if ( !is_readable($sFile) ) {
      // Fehlermeldungen nur einmal pro Datei anzeigen
      if ( !in_array($sFile, static::$missingFiles) ) {
        Status::addError('Einstellungen der "'.$sFile.'" konnten nicht ausgelesen werden.');
        static::$missingFiles[] = $sFile;
      }
      return;
    }

    // Werte aus dem Cache auslesen und zurückgeben, sofern vorhanden
    if ( array_key_exists($sName,static::$cache) ) {
      return static::$cache[$sName];
    }

    // Einstellungs-INI auslesen, assoziatives Array generieren und Werte cachen
    static::$cache[$sName] = parse_ini_file($sFile, true);
    return static::$cache[$sName];
  }


  /**
   * Direkten Wert aus Einstellungs-INI-Datei auslesen und zurückgeben
   *
   * @param string $sName       Name der auszulesenden INI-Datei
   * @param [string] $sKey      Name der auszulesenden Gruppe
   * @param [string] $sSubKey   Name der auszulesenden Einstellung
   * @return mixed  Inhalt der INI als Array oder direkter Wert
   */
  public static function getValue($sName,$sKey=null,$sSubKey=null) {
    // Werte der INI direkt auslesen
    $hIni = static::get($sName);

    // Keine Werte vorhanden -> nichts zurückgeben
    if ( !$hIni ) {
      return;
    }

    if ( is_null($sKey) ) {
      return $hIni;
    } else {
      if ( is_null($sSubKey) ) {
        return $hIni[$sKey];
      }
      return $hIni[$sKey][$sSubKey];
    }
  }

}

