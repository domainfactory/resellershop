<?php

require_once('Twig/Autoloader.php');

class Renderer {

  // Debugmodus aktivieren
  const DEBUG = TRUE;
  // Debugmodus deaktivieren
  //const DEBUG = FALSE;

  // Dateinamenpräfix für .ini-Dateien einzelner Seiten
  const PAGE_PREFIX = 'page_';


  // Dem Template zugewiesene Variablen
  protected static $assigns = array();

  // Cache der Statusmeldungen
  protected static $msg_cache = null;

  // Instanz des Renderers
  protected static $twig = null;
  protected static $loader = null;

  // Anzuzeigendes Modul
  protected static $mod = null;


  /**
   * Variablen den Templates zuweisen
   *
   * @param string $sName       Name der Variable
   * @param mixed $xValue       Wert
   */
  static public function assign($sName, $xValue) {
    static::$assigns[$sName] = $xValue;
    return 1;
  }


  /**
   * Welche Seite soll aktuell angezeigt werden?
   *
   * @return string     Dateiname der aufgerufenen Seite (ohne Endung)
   */
  static public function getAction() {
    // Sonderzeichen entfernen, um Zugriff auf andere Dateien zu verhindern
    $sAction = (is_null(static::$mod)
                 ? (array_key_exists('action', $_GET)
                      ? preg_replace('/[^A-Za-z0-9_-]/', '', $_GET['action'])
                      : ''
                   )
                 : static::$mod
               );

    // Startseite
    if ( empty($sAction) ) {
      return 'index';
    }

    // Angeforderte Seite wurde nicht gefunden
    if ( !file_exists(DIR_SETTINGS.static::PAGE_PREFIX.$sAction.'.ini') ) {
      header('', true, 404);
      return 'index';
    }

    return $sAction;
  }


  /**
   * Überscheibt, welche Seite aktuell angezeigt werden soll
   *
   * @param [string] $sName     Dateiname der anzuzeigenden Seite (ohne Endung)
   */
  static public function setAction($sName=null) {
    static::$mod = $sName;
  }


  //////////////////////// RENDER //////////////////////////


  /**
   * Gerendertes Template darstellen
   *
   * @param [string] $sTemplate   Pfad zum Template (vom Basistemplate aus)
   * @param [string] $sSiteConfig Einstellungen einer Datei
   * @return bool
   */
  static public function display($sTemplate=null, $sSiteConfig=SETTINGS_FILE) {
    if ( !headers_sent() ) {
      header("Content-Type: text/html; charset=UTF-8");
    }

    // Welche Seite soll geladen werden?
    $sAction = static::getAction();

    // Daten zur Seite dem Template zuweisen
    $hPageSettings = Settings::getValue(static::PAGE_PREFIX.$sAction);
    static::assign('page'       , $hPageSettings);
    static::assign('currentpage', static::PAGE_PREFIX.$sAction);

    // Unerlaubte Zeichen aus Dateinamen entfernen
    if ( array_key_exists('template', $hPageSettings) ) {
      $hPageSettings['template'] = preg_replace('#[^A-Za-z0-9_/-]#', '', $hPageSettings['template']);

      // Vorlage in Seiteneinstellungen angegeben -> verwenden
      if ( $sTemplate === null ) {
        $sTemplate = $hPageSettings['template'].'.tpl';
      }
    }

    if ( !$sTemplate ) {
      $sTemplate = 'index.tpl';
    }

    // Inhalte rendern und direkt ausgeben
    echo( static::render($sTemplate, $sSiteConfig) );

    return 1;
  }


  /**
   * Template rendern
   *
   * @param string $sTemplate   Pfad zum Template (vom Basistemplate aus)
   * @param string $sSiteConfig Einstellungen einer Datei
   * @return bool
   */
  static public function render($sTemplate, $sSiteConfig=SETTINGS_FILE) {
    // Renderer initialisieren
    static::init();

    // Statusmeldungen der Seiten und des RP-Systems dem Template zuweisen
    Status::injectRPCMsgs();
    static::assign('_msgs', Status::getMessages());

    try {
      // Versuchen, die Inhalte zu rendern
      $ret = static::$twig->render(
        $sTemplate,
        array_merge(
          // Shop-Einstellungen dem Template zuweisen
          array(
            'site'   => Settings::getValue(SETTINGS_FILE),
            'master' => shopSettings::read(array('file'=>'master.ini')),
          ),
          // Bisher zugewiesene Assigns dem Template hinzufügen
          static::$assigns
        )
      );

    // Fehler des Renderers
    } catch (Twig_Error $e) {
      // Nur HTML-Elemente bereitstellen
      $ret = "<h1>Fehler bei der Bereitstellung dieser Seite</h1>".
              "<h3>".$e->getMessage()."</h3>";

      // Auf Wunsch Debug-Meldungen ausgeben
      if ( static::DEBUG ) {
        $ret .= "<pre><code>".$e->getTraceAsString()."</code></pre>";
      }
    }

    // Assigns für weitere Aufrufe zurücksetzen
    static::$assigns = array();

    // Gerenderte Inhalte zurückgeben
    return $ret;
  }


  /**
   * Fehlermeldungen bei kritischen Fehlern darstellen und Skript abbrechen
   *
   * @param string $sMessage    Anzuzeigende Fehlermeldungen
   */
  static public function renderFatal($sMessage) {
    static::init();

    // 503-Header senden, damit die Fehlermeldung nicht von Suchmaschinen indiziert wird
    if ( !headers_sent() ) {
      header('', true, 503);
    }

    // Versuchen, die Einstellungen auszulesen, um den Link zur Hauptseite anzuzeigen
    try {
      $hGlobalSettings = Settings::getValue(SETTINGS_FILE);
    } catch (Exception $e) {
      $hGlobalSettings = array();
    }

    // Kritische Fehlermeldung rendern
    try {
      echo static::$twig->render('fatal.tpl', array_merge(
        array(
          'message' => $sMessage,
          'site' => $hGlobalSettings,
        ),
        static::$assigns
      ));

    // Fehler beim Laden des Templates -> einfach Fehler darstellen
    } catch (Twig_Error_Loader $e) {
      echo "<h1>Kritischer Fehler</h1><h3>".$sMessage."</h3><p>Wir sind bald wieder f&uuml;r Sie da.</p>";
      if ( static::DEBUG ) {
        echo "<pre><code>".$e->getTraceAsString()."</code></pre>";
      }

    // Fehler in Template
    } catch (Twig_Error $e) {
      echo "<h1>Fehler beim Rendern</h1><h3>".$e->getMessage()."</h3>";
      if ( static::DEBUG ) {
        echo "<pre><code>".$e->getTraceAsString()."</code></pre>";
      }
    }

    // Weitere Ausführung des Skripts unterbinden
    exit();
  }


  /**
   * Renderer initialisieren
   */
  static private function init() {
    // Loader nur einmal pro Skriptlaufzeit erstellen
    if ( is_null(static::$loader) ) {

      // Autoloader der Renderers aktivieren
      Twig_Autoloader::register();

      // Basisverzeichnis des Renderers zuweisen
      static::$loader = new Twig_Loader_Filesystem(DIR_TEMPLATES);


      // UMGEBUNGS-EINSTELLUNGEN DES RENDERERS SETZEN

      $twigSettings = array(
        'cache' => DIR_COMPILED,  // Pfad fuer kompilierte Dateien
      );
      if ( static::DEBUG ) {
        $twigSettings['debug'] = true;        // dump()-Methode zur Verfügung stellen
        $twigSettings['auto_reload'] = true;  // Bei Templateänderungen sofort neu kompilieren
      }

      static::$twig = new Twig_Environment(static::$loader, $twigSettings);

      // dump()-Methode zur Verfügung stellen
      if ( static::DEBUG ) {
        static::$twig->addExtension(new Twig_Extension_Debug());
      }


      // EIGENE METHODEN FUER RENDERER ZUWEISEN

      $renderUrl = new Twig_SimpleFunction(
        'url',
        array('Renderer', 'renderUrl')
      );
      static::$twig->addFunction($renderUrl);

      $renderPrice = new Twig_SimpleFunction(
        'price',
        array('Renderer', 'renderPrice'),
        array('is_safe' => array('html'))
      );
      static::$twig->addFunction($renderPrice);

      $renderLimitUnit = new Twig_SimpleFunction(
        'unit',
        array('Renderer', 'renderLimitUnit'),
        array('is_safe' => array('html'))
      );
      static::$twig->addFunction($renderLimitUnit);

      $formatNumber = new Twig_SimpleFunction(
        'formatNumber',
        array('Renderer', 'formatNumber')
      );
      static::$twig->addFunction($formatNumber);

      $markError = new Twig_SimpleFunction(
        'markError',
        array('Renderer', 'markError')
      );
      static::$twig->addFunction($markError);

      $getError = new Twig_SimpleFunction(
        'getError',
        array('Renderer', 'getError')
      );
      static::$twig->addFunction($getError);
    }
  }


  //////////////////////// MODULE //////////////////////////


  /**
   * URL rendern
   *
   * Prüft, ob eine in der global.ini hinterlegte Seite vorhanden ist
   * und gibt bei Bedarf die entsprechende URL zurück.
   *
   * @param string $sKey        Zu rendernde URL
   * @return string             Gerenderte URL
   */
  static public function renderUrl($sKey) {
    if ( substr( $sKey, 0, strlen(static::PAGE_PREFIX) ) === static::PAGE_PREFIX ) {
      return Settings::getValue(SETTINGS_FILE,'url',$sKey);
    }
    return $sKey;
  }


  /**
   * Zahlen formatieren
   *
   * @param (int|string) $sValue        Zu formatierender Wert
   * @param [int] $iPrecision           Anzahl der Nachkommastellen
   * @return string
   */
  static public function formatNumber($sValue, $iPrecision = 0) {
    $priceSettings = Settings::getValue(SETTINGS_FILE,'price');

    // Hat der Wert keine Nachkommastellen (,00), dann keine anzeigen
    if ( floor($sValue) === round($sValue, $iPrecision) ) {
      $iPrecision = 0;
    }

    return number_format(
      $sValue,
      $iPrecision,
      $priceSettings['decimal_point'],
      $priceSettings['thousands_separator']
    );
  }


  /**
   * Formatiert einen Preis und erstellt den semantischen HTML-Quelltext dafür
   *
   * @param (int|float) $sValue         Preiswert
   * @param [bool] $bLongCurrency       Soll die Währung voll ausgeschrieben werden?
   * @return string                     Formatierter HTML-Quelltext
   */
  static public function renderPrice($sValue,$bLongCurrency=false) {
    // Preiseinstellungen auslesen
    $priceSettings = Settings::getValue(SETTINGS_FILE,'price');
    $sNiceCurrency = ($bLongCurrency ? $priceSettings['currency'] : $priceSettings['currency_nice']);

    // Nur Centbeträge anzeigen?
    if ( ($sValue*100) < 100 && $priceSettings['prefer_minor'] ) {
      $sNiceMoney = ($sValue * 100);
      $sNiceCurrency = ($bLongCurrency ? $priceSettings['currency_minor'] : $priceSettings['currency_minor_nice']);

    // Dezimalstellen der gerundeten Beiträge entfernen?
    } elseif ( (($sValue*100) % 100) == 0 && $priceSettings['prefer_no_decimals'] ) {
      $sNiceMoney = static::formatNumber($sValue, 0);

    // Betrag mit schöner Formatierung
    } else {
      $sNiceMoney = static::formatNumber(round($sValue, $priceSettings['decimals']), $priceSettings['decimals']);
    }

    return '<span property="price" content="'.$sValue.'">'.
              $sNiceMoney.
            '</span>&#x202F;'.
            '<span property="priceCurrency" content="'.$priceSettings['currency_code'].'">'.
              $sNiceCurrency.
            '</span>';
  }


  /**
   * Werte eines einzelnes Limit formatiert rendern
   *
   * @param array $hLimit       Daten des Limits
   * @param [string] $sTag      Zu verwendendes Tag
   * @return string
   */
  static public function renderLimitUnit($hLimit, $sTag = '') {
    $sTyp = $hLimit['typ'];
    $sUnit = $hLimit['unit'];
    $sValue = ( array_key_exists('val', $hLimit) ) ? $hLimit['val'] : $hLimit['value'];

    $sTitle = '';
    $sContent = '';

    // Basis für Teilung der Byte-Größen
    $iBaseMB = Settings::getValue('products','units','mb_base');
    if ( !$iBaseMB ) {
      $iBaseMB = 1000;
    }

    // boolsche Werte
    if ( $sTyp == 'bool' ) {
      if ( $sValue ) {
        $sTitle = 'enthalten';
        $sContent = '&#10003;';
      } else {
        $sTitle = 'nicht enthalten';
        $sContent = '-';
      }

    // nicht-boolsche Werte
    } else {
      if ( $sValue === 'unbegrenzt' ) {
        $sTitle = 'unbegrenzt';
        $sContent = '&#10003;';
      // Wert leer
      } elseif ( $sValue == '0' ) {
        $sTitle = 'nicht enthalten';
        $sContent = '-';
      } elseif ( $sUnit === 'MB' ) {
        // Terabyte
        if ( $sValue >= ($iBaseMB * $iBaseMB) ) {
          $sTitle = $sValue.' MB';
          $sContent = static::formatNumber($sValue / ($iBaseMB*$iBaseMB), 1).' TB';
        // Gigabyte
        } elseif ( $sValue >= $iBaseMB ) {
          $sTitle = $sValue.' MB';
          $sContent = static::formatNumber($sValue / $iBaseMB, 1).' GB';
        // Megabyte
        } else {
          $sTitle = $sValue.' MB';
          $sContent = static::formatNumber($sValue, 1).' MB';
        }
      } else {
        $sContent = $sValue;
        if ( !in_array($sUnit, array('-','Stk.')) ) {
          $sContent .= ' '.$sUnit;
        }
      }
    }

    // Tag mit der Meldung zusammenbauen
    $sPrint = '';
    if ( $sTag != '' ) {
      $sPrint = '<'.$sTag;
      if ( $sTitle != '' ) {
        $sPrint .= ' title="'.str_replace('"','&quot;',$sTitle).'"';
      }
      $sPrint .= '>';
    }
    $sPrint .= $sContent;
    if ( $sTag != '' ) {
      $sPrint .= '</'.$sTag.'>';
    }

    return $sPrint;
  }


  /**
   * CSS-Klassen für Eingabefeld mit Fehlern zurückgeben
   *
   * @param string $sFld        Name des Feldes
   * @param [string] $sParent   Schlüssel des übergeordneten Felds
   * @return string             CSS-Klassen für Fehler, wenn benötigt
   */
  static public function markError($sFld, $sParent=null) {
    // Aufgetretene Fehlermeldungen cachen
    if ( is_null(static::$msg_cache) ) {
      static::$msg_cache = Status::getMessages();
    }

    // In Meldungen nach angegebenem Feld suchen
    foreach ( static::$msg_cache as $msg ) {
      if ( is_null($sParent)
            && $msg['fld'] == $sFld
            && !array_key_exists('parent',$msg)
            || !is_null($sParent)
            && $msg['fld'] == $sFld
            && array_key_exists('parent',$msg)
            && $msg['parent'] == $sParent ) {

        // Fehler aufgetreten: CSS-Klasse zurückgegeben
        return 'form-error';
      }
    }

    // Keine Fehler aufgetreten
    return '';
  }


  /**
   * Fehlermeldung zum Feld suchen 
   *
   * @param string $sFld        Name des Feldes
   * @param [string] $sParent   Schlüssel des übergeordneten Felds
   * @return string             Fehlermeldung des Felds
   */
  static public function getError($sFld, $sParent=null) {
    // Aufgetretene Fehlermeldungen cachen
    if ( is_null(static::$msg_cache) ) {
      static::$msg_cache = Status::getMessages();
    }

    // In Meldungen nach angegebenem Feld suchen
    foreach( static::$msg_cache as $msg ) {
      if ( is_null($sParent)
            && $msg['fld'] == $sFld
            && !array_key_exists('parent',$msg) 
            || !is_null($sParent)
            && $msg['fld'] == $sFld
            && array_key_exists('parent',$msg)
            && $msg['parent'] == $sParent ) {

        // Name des Felds aus Meldung entfernen und direkt zurückgeben
        return preg_replace(
          array('/(F|f)eld: \$[a-zA-Z0-9_-]+/', '/\$tab\.[a-zA-Z0-9_-]+: /'),
          array('', ''),
          $msg['msg']
        );
      }
    }

    // Kein Fehler aufgetreten
    return '';
  }

}

