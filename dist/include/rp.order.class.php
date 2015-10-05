<?php
class rpOrder{
  public static function getFreeOrdNr($hParams=array()){
    $ret = bbRpc::call('bbOrder::getFreeOrdNr',$hParams);
    return $ret;
  }
  public static function readAccountAdress($hParams=array()){
    $ret = bbRpc::call('bbOrder::readAccountAdress',$hParams);
    return $ret;
  }
  public static function readAccountEntry($hParams=array()){
    $ret = bbRpc::call('bbOrder::readAccountEntry',$hParams);
    return $ret;
  }
  public static function readDisposition($hParams=array()){
    $ret = bbRpc::call('bbOrder::readDisposition',$hParams);
    return $ret;
  }
  public static function readEntry($hParams=array()){
    $ret = bbRpc::call('bbOrder::readEntry',$hParams);
    return $ret;
  }
  public static function saveEntry($hParams=array()){
    $ret = bbRpc::call('bbOrder::saveEntry',$hParams);
    return $ret;
  }
  public static function validateEntry($hParams=array()){
    $ret = bbRpc::call('bbOrder::validateEntry',$hParams);
    return $ret;
  }
  public static function getContractPdf($hParams=array()){
    $ret = bbRpc::call('shDraft::genPdf',$hParams);
    return $ret;
  }
}
