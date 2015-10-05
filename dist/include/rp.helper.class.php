<?php
class rpHelper{
  static function isHash($xVal){
    if (!is_array($xVal) || !count($xVal)){
      return 0;
    }
    return array_keys($xVal) !== range(0,sizeof($xVal)-1);
  }
  static function mergeHash($xData1=array(),$xData2=array()){
    $xRet = array_merge($xData1,$xData2);
    foreach($xData1 as $xKey=>$xVal){
      if (is_array($xVal) && array_key_exists($xKey,$xData2) && static::isHash($xData1[$xKey]) && static::isHash($xData2[$xKey])){
        $xRet[$xKey] = static::mergeHash($xData1[$xKey],$xData2[$xKey]);
      }
    }
    return $xRet;
  }
  static function addFileHeader($sFile,$iSize=null,$sType='application/pdf'){
    header("Content-Type: ".$sType);
    header("Content-Disposition: attachment; filename=\"".$sFile."\"");
    header('Expires: 0');
    header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
    header('Pragma: public');
    header("Content-Type: application/octet-stream");
    header("Content-Transfer-Encoding: binary");
    if (!is_null($iSize)){
      header("Content-Length: ".$iSize);
    }
  }
}
