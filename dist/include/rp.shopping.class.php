<?php
class rpShopping{
  public static function addCartToOrder($hParams=array()){
    $ret = bbRpc::call('bbShopping::addCartToOrder',$hParams);
    return $ret;
  }
  public static function changeTariffAlerts($hParams=array()){
    $ret = bbRpc::call('bbShopping::changeTariffAlerts',$hParams);
    return $ret;
  }
  public static function checkDomain($hParams=array()){
    $ret = bbRpc::call('bbShopping::checkDomain',$hParams);
    return $ret;
  }
  public static function getTariff($hParams=array()){
    $ret = bbRpc::call('bbShopping::getTariff',$hParams);
    return $ret;
  }
  public static function haveDomain($hParams=array()){
    $ret = bbRpc::call('bbShopping::haveDomain',$hParams);
    return $ret;
  }
  public static function isInCart($hParams=array()){
    $ret = bbRpc::call('bbShopping::isInCart',$hParams);
    return $ret;
  }
  public static function readCart($hParams=array()){
    $ret = bbRpc::call('bbShopping::readCart',$hParams);
    return $ret;
  }
  public static function readCartItem($hParams=array()){
    $ret = bbRpc::call('bbShopping::readCartItem',$hParams);
    return $ret;
  }
  public static function readStore($hParams=array()){
    $ret = bbRpc::call('bbShopping::readStore',$hParams);
    return $ret;
  }
  public static function readStoreEntry($hParams=array()){
    $ret = bbRpc::call('bbShopping::readStoreEntry',$hParams);
    return $ret;
  }
  public static function saveCartItem($hParams=array()){
    $ret = bbRpc::call('bbShopping::saveCartItem',$hParams);
    return $ret;
  }
}
