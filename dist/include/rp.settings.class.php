<?php
class rpSettings{
  public static function read($hParams) {
    $ret = bbRpc::call('shSettings::read',$hParams);
    return $ret;
  }
}
