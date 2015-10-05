<?php

class Rpc {

  protected static $call_class  = null;
  protected static $call_method = null;
  protected static $call_params = array();
  protected static $encoder = 'json';
  protected static $utf8_encode = 0;
  protected static $class_whitelist = null;

  final static public function setAcceptedClasses(array $classes=array()){
    static::$class_whitelist = $classes;
    return 1;
  }

  final static public function setUTF8Encode($iOn=0){
    static::$utf8_encode = ($iOn) ? 1 : 0;
    return 1;
  }

  final static public function utf8_encode_data($xData){
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

  final static public function utf8_decode_data($xData){
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

  final static public function process(){
    static::processParams();
    if (static::$utf8_encode){
      echo(json_encode(static::utf8_encode_data(static::getResult(static::processCall()))));
    }else{
      echo(json_encode(static::getResult(static::processCall())));
    }
  }

  final static private function processCall(){
    if (is_array(static::$class_whitelist) && !in_array(static::$call_class,static::$class_whitelist)){
      Status::addError('Kein Zugriff auf Klasse: %s',array(static::$call_class));
      return;
    }
    if (!class_exists(static::$call_class,true)){
      Status::addError('Klasse %s existiert nicht',array(static::$call_class));
      return;
    }
    if (!in_array(static::$call_method,get_class_methods(static::$call_class))){
      Status::addError('%s existiert nicht',array(static::$call_class.'::'.static::$call_method.'()'));
      return;
    }
    return call_user_func(static::$call_class.'::'.static::$call_method,static::$call_params);
  }

  final static public function getParams(){
    static::processParams();
    return array(
      'class'  => static::$call_class,
      'method' => static::$call_method,
      'params' => static::$call_params,
    );
  }

  final static private function processParams(){
    if (array_key_exists('_GET',$GLOBALS) && is_array($GLOBALS['_GET']) && count($GLOBALS['_GET'])){
      if (array_key_exists('class',$GLOBALS['_GET'])){
        static::$call_class = $GLOBALS['_GET']['class'];
      }
      if (array_key_exists('method',$GLOBALS['_GET'])){
        static::$call_method = $GLOBALS['_GET']['method'];
      }
      unset($GLOBALS['_GET']);
    }
    if (array_key_exists('_POST',$GLOBALS) && is_array($GLOBALS['_POST']) && count($GLOBALS['_POST'])){
      if (array_key_exists('class',$GLOBALS['_POST'])){
        static::$call_class = $GLOBALS['_POST']['class'];
      }
      if (array_key_exists('method',$GLOBALS['_POST'])){
        static::$call_method = $GLOBALS['_POST']['method'];
      }
    }
    if (array_key_exists('HTTP_RAW_POST_DATA',$GLOBALS) && ($tmp = json_decode($GLOBALS['HTTP_RAW_POST_DATA'],1)) && array_key_exists('data',$tmp)){
      static::$call_params = $tmp['data'];
      unset($GLOBALS['HTTP_RAW_POST_DATA']);
    }
    if (array_key_exists('_POST',$GLOBALS) && ($tmp = $GLOBALS['_POST']) && array_key_exists('data',$tmp)){
      static::$call_params = $tmp['data'];
      unset($GLOBALS['_POST']);
    }
  }

  final static private function getResult($data=array()){
    Status::injectRPCMsgs();
    return array(
      'messages' => Status::getMessages(),
      'success'  => (!Status::hasErrors()),
      'data'     => $data,
    );
  }

}

