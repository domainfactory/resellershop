<?php
/*
 * bbRpc Class (c) 2015 by domainfactory GmbH - www.df.eu
 *
 *   Klasse zur Kommunikation mit der RP2 - API
 *
 *   Version 1.05
 *   Requirements:
 *    - php >= 5.3
 *    - mod: curl
 *
 *
 *   Generated : 2013-04-10
 *   Updated   : 2015-04-21
 *   Author    : Michael Boehm - support@df.eu
 *
 */
class bbRpc{
  protected static $rpc_url = null;
  protected static $msgs    = array();
  protected static $error_fields = array();
  private static $rpc_user = null;
  private static $rpc_pass = null;
  private static $client   = null;
  private static $session  = array();
  private static $cookie   = null;
  private static $response = null;
  private static $guest_token = null;
  private static $utf8 = 0;
  private static $return_error_fields = 1;
  const result    = 'Return';
  const error_msg = 'Error';
  const error_fields = 'ErrorFields';
  /*
   * setUrl()
   * Setzt die RP-RPC-Server-Basis-URL
   *
   * params:
   *  - (string) sUrl : RP2-INSTANZ Url: z.B. http://12345.premium-admin.eu/
   *
   * return void
   *
   */
  final public static function setUrl($sUrl=null){
    if (isset($sUrl)){
      if (substr($sUrl, -1) !== '/') {
        $sUrl .= '/';
      }
      static::$rpc_url = $sUrl;
    }
  }
  /*
   * setGUESTToken()
   * Setzt die den Fallback AUTH Token falls man nur als GUEST authentifiziert ist
   *
   * params:
   *  - (string) sToken : GUEST-AUTH-Token z.B. michi&milo$
   *
   * return void
   *
   */
  final public static function setGUESTToken($sToken=null){
    if (isset($sToken)){
      static::$guest_token = $sToken;
    }
  }
  /*
   * setUTF8Native()
   * Wenn gesetzt wird Result / Params nicht von latin nach utf8 und zurueck convertiert
   *
   * params:
   *  - (bool) bUTF8 : Params und Result nativ utf8 codieren 
   *
   * return void
   *
   */
  final public static function setUTF8Native($bUTF8=0){
    static::$utf8 = ($bUTF8) ? 1 : 0;
  }
  /*
   * auth()
   * Authentifiziert die aktuelle Session bei dem RP2-RPC Service
   *
   * params;
   *  - (string) sUser : Benutzername
   *  - (string) sPass : Passwort
   *
   * return (int) uid
   *
   */
  final public static function auth($sUser=null,$sPass=null){
    if (!is_null($sUser)){
      static::$rpc_user = $sUser;
    }
    if (!is_null($sPass)){
      static::$rpc_pass = $sPass;
    }
    return static::post('auth',array(
      'user' => static::$rpc_user,
      'pass' => static::$rpc_pass,
    ),'auth');
  }
  /*
   * getSid()
   * Stellt die Session-ID zur Verfügung
   *
   * return (string) sid
   *
   */
  final public static function getSid(){
    if (!array_key_exists('sid',static::$session) || !static::$session['sid']){
      static::auth();
    }
    if (!array_key_exists('sid',static::$session) || !static::$session['sid']){
      return null;
    }
    return static::$session['sid'];
  }
  /*
   * setSid()
   * Setzt die Session-ID
   *
   * params;
   * - (string) sSid : Session-ID
   *
   * return (bool)
   *
   */
  final public static function setSid($sSid){
    if (strlen($sSid)){
      static::$session['sid'] = $sSid;
      return 1;
    }
    return 0;
  }
  /*
   * call()
   * Fuehrt einen Remote-Call am RPC-Service aus
   *
   * params:
   *  - (string) sMethod                  : aufzurufende Methode z.B. bbOrder::readEntry
   *  - (hash)   hArgs         (optional) : zu uebergebende Argumente an die aufgerufene Methode z.B. array('return_array' => 1)
   *  - (hash)   hPlaceholders (optional) : Uebersetzungshash der Feldnamen in beliebige Bezeichner in den Meldungen uebersetzt z.B. array('phone_1' => 'Telefonnummer')
   *
   * return xData
   *
   */
  final public static function call($sMethod,$hArgs=array(),$hPlaceholders=null){
    if (!array_key_exists('sid',static::$session) || !static::$session['sid']){
      static::auth();
    }
    return static::post($sMethod,$hArgs,'call',$hPlaceholders);
  }
  /*
   * getMessages()
   * Liefert alle RPC-Meldungen zurueck (Fehler / Erfolg / Informationen / Warnungen)
   *
   * params:
   * - (hash) hParams  (optional) : Zusaetzliche Parameter z.B. array('delete_previous' => 1)
   *
   * return (array)
   *
   */
  final public static function getMessages($hParams=array()){
    $ahMsgs = static::$msgs;
    if ( array_key_exists('delete_previous', $hParams) && $hParams['delete_previous'] ) {
        static::$msgs = array();
    }
    return $ahMsgs;
  }
  final public static function getMessageFields($hParams=array()){
    return static::$error_fields;
  }
  /*
   * logout()
   * Beendet angemeldete Session
   *
   * return void
   *
   */
  final public static function logout(){
    return static::post('logout',null,'logout');
  }
  /*
   * setOrder()
   * Wechselt auf einen anderen Endkunden Auftrag / sofern man als Endkunde authentifiziert ist
   *
   * params:
   *  - (integer) iOeid : oeid auf des zu wechselnden Auftrages
   *
   * return void
   *
   */
  final public static function setOrder($iOeid){
    return static::post('setOrder',array(
      'oeid' => $iOeid,
    ),'setOrder');
  }
  /*
   *
   * PRIVATE FUNCTIONS
   *
   *
   */
  private static function addNotice($sMsg){
    static::$msgs[] = array(
      'typ' => 'notice',
      'msg' => $sMsg,
    );
  }
  private static function addError($sMsg){
    static::$msgs[] = array(
      'typ' => 'hard',
      'msg' => $sMsg,
    );
  }
  final private static function setOpt($sOption,$xValue){
    if (!curl_setopt(static::$client,$sOption,$xValue)){
      static::addError('Fehler beim Setzen der Client-Option: '.$sOption.' auf: '.$xValue);
      return 0;
    }
    return 1;
  }
  final private static function init(){
    if (is_null(static::$cookie)){
      static::$cookie = (defined('BBRPC_COOKIE')) ? BBRPC_COOKIE : getcwd().'/bb.rpc.cookie';
    }
    if (is_null(static::$rpc_url)){
      static::$rpc_url = BBRPC_URL;
    }
    if (is_null(static::$client)){
      static::$client = curl_init();
      static::setOpt(CURLOPT_SSL_VERIFYPEER,    FALSE);
      static::setOpt(CURLOPT_RETURNTRANSFER,    TRUE);
      static::setOpt(CURLOPT_TIMEOUT,           300);
      static::setOpt(CURLOPT_HEADER,            FALSE);
      static::setOpt(CURLOPT_FORBID_REUSE,      FALSE);
      static::setOpt(CURLOPT_VERBOSE,           FALSE);
      static::setOpt(CURLOPT_COOKIEFILE,        static::$cookie);
      static::setOpt(CURLOPT_COOKIEJAR,         static::$cookie);
      static::setOpt(CURLOPT_HTTPHEADER,        array(
        'Connection: keep-alive',
        'Keep-Alive: 300',
        'Expect: ',
      ));
      return 1;
    }
    return 0;
  }
  final private static function isCriticalError(){
    return (static::getResponse('IsCriticalError')) ? TRUE : FALSE;
  }
  final private static function getResponse($sName){
    return (is_array(static::$response) && array_key_exists($sName,static::$response)) ? static::$response[$sName] : NULL;
  }
  final private static function getErrors(){
    return static::getResponse(static::error_msg);
  }
  final private static function getErrorFields(){
    return static::getResponse(static::error_fields);
  }
  final private static function replacePlaceholder($sMsg,$hPlaceholders){
    foreach($hPlaceholders as $sFld => $sDscr){
      $sMsg = str_replace("\$".$sFld,$sDscr,$sMsg);
    }
    return $sMsg;
  }
  final private static function displayMessages($hPlaceholders=null){
    $ahMsgs = static::getErrors();
    if (is_array($ahMsgs)){
      foreach($ahMsgs as $hMsg){
        if (isset($hPlaceholders)){
          $hMsg['msg'] = static::replacePlaceholder($hMsg['msg'],$hPlaceholders);
        }
        static::$msgs[] = $hMsg;
      }
    }
    $ahFields = static::getErrorFields();
    static::$error_fields = $ahFields;
  }
  final private static function utf8_encode_data($xData){
    if (is_array($xData)){
      $aKeys = array_keys($xData);
      while(($xKey = array_shift($aKeys)) !== null){
        $xVal = static::utf8_encode_data($xData[$xKey]);
        unset($xData[$xKey]);
        $xKey = static::utf8_encode_data($xKey);
        $xData[$xKey] = $xVal;
      }
      return $xData;
    }elseif (is_string($xData)){
      return utf8_encode($xData);
    }else{
      return $xData;
    }
  }
  final private static function utf8_decode_data($xData){
    if (is_array($xData)){
      $aKeys = array_keys($xData);
      while(($xKey = array_shift($aKeys)) !== null){
        $xVal = static::utf8_decode_data($xData[$xKey]);
        unset($xData[$xKey]);
        $xKey = static::utf8_decode_data($xKey);
        $xData[$xKey] = $xVal;
      }
      return $xData;
    }elseif (is_string($xData)){
      return utf8_decode($xData);
    }elseif (is_float($xData) || is_double($xData)){
      if (strpos((string)$xData,'.') === false && strpos((string)$xData,',') === false){
        return (integer) $xData;
      }else{
        return (float) $xData;
      }
    }else{
      return $xData;
    }
  }
  final private static function json_encode($xData){
    return (static::$utf8) ? json_encode($xData) : json_encode(static::utf8_encode_data($xData));
  }
  final private static function json_decode($xData){
    return (static::$utf8) ? json_decode($xData,1) : static::utf8_decode_data(json_decode($xData,1));
  }
  final private static function post($sMethod,$xArgs=null,$sTyp='call',$hPlaceholders=null){
    static::init();
    $sSessionID = (array_key_exists('sid',static::$session) && static::$session['sid']) ? static::$session['sid'] : '__';
    if ($sTyp == 'call'){
      static::setOpt(CURLOPT_URL, static::$rpc_url.$sSessionID.'/rpc/call');
    }elseif($sTyp == 'auth'){
      if ((is_null($xArgs['user']) || !strlen($xArgs['user'])) && (is_null($xArgs['pass']) || !strlen($xArgs['pass']))){
        unset($xArgs['user']);
        unset($xArgs['pass']);
      }
      static::setOpt(CURLOPT_URL, static::$rpc_url.$sSessionID.'/rpc/auth');
    }elseif($sTyp == 'setOrder'){
      static::setOpt(CURLOPT_URL, static::$rpc_url.static::$session['sid'].'/rpc/setOrder');
    }elseif($sTyp == 'logout'){
      static::setOpt(CURLOPT_URL, static::$rpc_url.$sSessionID.'/rpc/logout');
    }

    $hMsg = array('method' => $sMethod);
    if (isset(static::$guest_token)){
      $hMsg['guest_token'] = static::$guest_token;
    }
    if (isset(static::$return_error_fields) && static::$return_error_fields){
      $hMsg['return_error_fields'] = 1;
    }
    if (isset($xArgs)) {
      $hMsg['params'] = $xArgs;
    }
    $sMsg = static::json_encode($hMsg);
    static::setOpt(CURLOPT_POSTFIELDS, array(
      'data' => $sMsg,
    ));
    $xResponseOrig = @curl_exec(static::$client);
    $bTmpErr = 0;
    if ($xResponseOrig === FALSE){
      static::addError('Verbindung zum BB-System nicht moeglich.');
      $bTmpErr = 1;
    }
    if ($xResponseOrig !== FALSE && (static::$response = static::json_decode($xResponseOrig)) === FALSE && !$bTmpErr){
      static::addError('Ungueltiger Rueckgabewert des BB-Systems: '.$xResponseOrig);
      echo('Error: curl_exec.response['.$sMethod.']=> '.$xResponseOrig."\n");
      die;
    }
    if (static::isCriticalError()){
      trigger_error(static::getResponse(static::result), E_USER_ERROR);
      die;
    }
    if ($sTyp == 'auth'){
      static::$session['sid'] = static::getResponse('sid');
    }
    
    static::displayMessages($hPlaceholders);
    return static::getResponse(static::result);
  }
}
