<?php
class rpCustomer{
  public static function getFreeCusNr($hParams=array()){
    $ret = bbRpc::call('bbCustomer::getFreeCusNr',$hParams);
    return $ret;
  }
  public static function getFreeCusLogin($hParams=array()){
    $ret = bbRpc::call('bbCustomer::getFreeCusLogin',$hParams);
    return $ret;
  }
  public static function getFreeSepaMr($hParams=array()){
    $ret = bbRpc::call('bbCustomer::getFreeSepaMr',$hParams);
    return $ret;
  }
  public static function readAdress($hParams=array()){
    $ret = bbRpc::call('bbCustomer::readAdress',$hParams);
    return $ret;
  }
  public static function readCountry($hParams=array()){
    $ret = bbRpc::call('bbCustomer::readCountry',$hParams);
    return $ret;
  }
  public static function readDiscount($hParams=array()){
    $ret = bbRpc::call('bbCustomer::readDiscount',$hParams);
    return $ret;
  }
  public static function defaultsEntry($hParams=array()){
    $ret = bbRpc::call('bbCustomer::defaultsEntry',$hParams);
    return $ret;
  }
  public static function readEntry($hParams=array()){
    $ret = bbRpc::call('bbCustomer::readEntry',$hParams);
    return $ret;
  }
  public static function readPayinfo($hParams=array()){
    $ret = bbRpc::call('bbCustomer::readPayinfo',$hParams);
    return $ret;
  }
  public static function readPayment($hParams=array()){
    $ret = bbRpc::call('bbCustomer::readPayment',$hParams);
    return $ret;
  }
  public static function readTitle($hParams=array()){
    $ret = bbRpc::call('bbCustomer::readTitle',$hParams);
    return $ret;
  }
  public static function saveAdress($hParams=array()){
    $ret = bbRpc::call('bbCustomer::saveAdress',$hParams);
    return $ret;
  }
  public static function saveEntry($hParams=array()){
    $ret = bbRpc::call('bbCustomer::saveEntry',$hParams);
    return $ret;
  }
  public static function savePayinfo($hParams=array()){
    $ret = bbRpc::call('bbCustomer::savePayinfo',$hParams);
    return $ret;
  }
  public static function validateAdress($hParams=array()){
    $ret = bbRpc::call('bbCustomer::validateAdress',$hParams);
    return $ret;
  }
  public static function validateEntry($hParams=array()){
    $ret = bbRpc::call('bbCustomer::validateEntry',$hParams);
    return $ret;
  }
  public static function validatePayinfo($hParams=array()){
    $ret = bbRpc::call('bbCustomer::validatePayinfo',$hParams);
    return $ret;
  }
}
