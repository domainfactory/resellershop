<?php
class shopOrder extends rpOrder {
  public static function getContractPdf($hParams=array()){
    $hParams['return_pdf'] = 1;
    $hParams['dekey'] = "contract_h";
    $hParams['laid'] = 1;
    $ret = parent::getContractPdf($hParams);
    return base64_decode($ret);
  }
}
