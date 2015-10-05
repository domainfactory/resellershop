<?php
class rpProduct {
  public static function readEntry($hParams = array()) {
    $data = bbRpc::call('bbProduct::readEntry',$hParams);
    return $data;
  }
  public static function readTld($hParams=array()){
    $data = bbRpc::call('bbProduct::readTld',$hParams);
    return $data;
  }
  public static function readTldMap($hParams=array()){
    $data = bbRpc::call('bbProduct::readTldMap',$hParams);
    return $data;
  }
  public static function readTldGroup($hParams=array()){
    $data = bbRpc::call('bbProduct::readTldGroup',$hParams);
    return $data;
  }
  public static function readDomCon($hParams=array()){
    $data = bbRpc::call('bbProduct::readDomCon',$hParams);
    return $data;
  }
  public static function readInterval($hParams=array()){
    $data = bbRpc::call('bbProduct::readInterval',$hParams);
    return $data;
  }
}
