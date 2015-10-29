<?php

class Status {

  // Meldungen werden in $msgs zwischengespeichert
  protected static $msgs      = array();

  // Gibt es Meldungen vom Typ "error"?
  protected static $has_error = 0;

  // Erlaubte Typen von Fehlermeldungen
  protected static $types     = array('error','notice','warning','success');


  /**
   * Statusmeldung hinzufügen
   *
   * @param string $sMsg         Nachricht
   * @param array [$args]        Zusätzliche Daten zum Ersetzen von Platzhaltern mit sprintf
   * @param string [$type]       Typ der Fehlermeldung (z.B. error, notice)
   * @param string [$fld]        Um welches Eingabefeld handelt es sich?
   * @param string [$tab]        Bereich?
   * @param string [$row]        Zeile?
   * @param string [$parent_key] übergeordnetes Element?
   * @return bool                Wurde die Meldung gespeichert?
   */
  final private static function add($sMsg, array $args=null, $type='error', $fld=null, $tab=null, $row=null, $parent_key=null){
    // Wurde ein gültiger Typ angegeben?
    if ( !in_array($type, static::$types) ) {
      static::add('Parameter type darf nicht "'.$type.'" sein');
      return 0;
    }

    // Meldung speichern
    static::$msgs[] = array_merge(
      array(
        'msg'  => (is_array($args) && count($args) && array_unshift($args, $sMsg)) ? call_user_func_array('sprintf',$args) : $sMsg,
        'type' => $type,
      ),
      (is_null($fld)) ? array() : array( 'fld' => $fld ),
      (is_null($tab)) ? array() : array( 'tab' => $tab ),
      (is_null($parent_key)) ? array() : array( 'parent' => $parent_key )
    );

    if ( $type === 'error' ) {
      static::$has_error = 1;
    }

    return 1;
  }

  /**
   * Statusmeldung der bbRpc-Klasse hinzufügen
   *
   * @return void
   */
  final public static function injectRPCMsgs() {
    global $asCustomErrorMessages;

    // Statusmeldungen der bbRpc-Klasse auslesen
    $ahMsgs = bbRpc::getMessages(array(
      'delete_previous' => 1
    ));

    // Zuordnungen der bbRpc-Typen zu den Typen dieser Klasse
    $hTypeMap = array(
      'err'    => 'error',
      'warn'   => 'warning',
      'ok'     => 'success',
      'notice' => 'notice',
    );

    foreach ( $ahMsgs as $hMsg ) {
      // eigene Fehlermeldungen der dist/settings/errors.inc.php nutzen
      $sMsg = array_key_exists($hMsg['msg'], $asCustomErrorMessages)
                ? $asCustomErrorMessages[ $hMsg['msg'] ]
                : $hMsg['msg'];

      if ( preg_match('/(?!\$tab)\$([a-zA-Z0-9_-]+)/', $hMsg['msg'], $aMatch)
            && count($aMatch) === 2
            && ($sFld = $aMatch[1]) ) {
        static::add($sMsg, null, $hTypeMap[$hMsg['typ']], $sFld, null, null, (array_key_exists('parent_key', $hMsg) ? $hMsg['parent_key'] : null));
      } else {
        static::add($sMsg, null, $hTypeMap[$hMsg['typ']]);
      }
    }
  }

  final public static function addNotice($sMsg, array $args=null, $fld=null, $tab=null, $row=null, $parent_key=null) {
    return static::add($sMsg, $args, 'notice', $fld, $tab, $row, $parent_key);
  }

  final public static function addSuccess($sMsg, array $args=null, $fld=null, $tab=null, $row=null, $parent_key=null) {
    return static::add($sMsg, $args, 'success', $fld, $tab, $row, $parent_key);
  }

  final public static function addWarning($sMsg, array $args=null, $fld=null, $tab=null, $row=null, $parent_key=null) {
    return static::add($sMsg, $args, 'warning', $fld, $tab, $row, $parent_key);
  }

  final public static function addError($sMsg, array $args=null, $fld=null, $tab=null, $row=null, $parent_key=null) {
    return static::add($sMsg, $args, 'error', $fld, $tab, $row, $parent_key);
  }

  final public static function addPrintr($data) {
    return static::add(print_r($data, 1), null, 'notice');
  }

  /**
   * Alle bestehenden Fehlermeldungen auslesen
   *
   * @return array
   */
  final public static function getMessages() {
    return static::$msgs;
  }

  /**
   * Traten Fehler während des Skriptablaufs auf?
   *
   * @return bool
   */
  final public static function hasErrors() {
    return static::$has_error;
  }

}

