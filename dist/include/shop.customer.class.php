<?php

class shopCustomer extends rpCustomer {

  public static function readPayment($hParams=array()) {
    $bRetSF = ($hParams['return_shopformat'] ? 1 : 0);
    if ( $bRetSF ) {
      unset($hParams['return_shopformat']);
    }
    $ret = parent::readPayment($hParams);
    if ( $ret && $bRetSF ) {
      $ahPaymentsByCpid = array();
      foreach ( $ret as $hPayment ) {
        $ahPaymentsByCpid[$hPayment['cpid']] = $hPayment;
      }
      $ret = $ahPaymentsByCpid;
    }
    return $ret;
  }

}

