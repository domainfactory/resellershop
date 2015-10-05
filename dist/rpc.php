<?php
require_once(__DIR__.'/include/config.inc.php');
header('Content-Type: application/json; charset=UTF-8');
Rpc::setUTF8Encode(0);
Rpc::setAcceptedClasses(array(
  'rpProduct',
  'rpShopping',
  'modIndex',
));
Rpc::process();
