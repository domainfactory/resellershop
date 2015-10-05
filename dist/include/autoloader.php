<?php

// VERZEICHNISSE

define('DIR_INCLUDE', dirname(__FILE__).'/');

define('DIR_DIST', realpath(DIR_INCLUDE.'..').'/');
define('DIR_RENDERER'  , DIR_INCLUDE.'Twig/');

define('DIR_CSS'       , DIR_DIST.'css/');
define('DIR_JS'        , DIR_DIST.'js/');
define('DIR_IMAGES'    , DIR_DIST.'images/');
define('DIR_SETTINGS'  , DIR_DIST.'settings/');
define('DIR_TEMPLATES' , DIR_DIST.'templates/');
define('DIR_COMPILED'  , DIR_DIST.'compiled/');

define('DIR_SRC', realpath(DIR_INCLUDE.'../../src').'/');
define('DIR_SRC_IMAGES', DIR_SRC.'images/');
define('DIR_SRC_JS'    , DIR_SRC.'js/');
define('DIR_SRC_SCSS'  , DIR_SRC.'scss/');


// PROJEKTWEITE SKRIPTE

// Sicherstellen, dass die Skripte immer vom korrekten Verzeichnis aus eingebunden werden
set_include_path(DIR_INCLUDE);

// Einbinden der wichtigsten Skripte
require_once('settings.class.php');
require_once('rpc.class.php');
require_once('renderer.class.php');
require_once(DIR_SETTINGS.'errors.inc.php');
require_once('status.class.php');
require_once('rp.product.class.php');
require_once('rp.shopping.class.php');
require_once('rp.customer.class.php');
require_once('rp.order.class.php');
require_once('rp.settings.class.php');
require_once('bb.rpc.class.php');
require_once('mod.index.class.php');
require_once('rp.helper.class.php');
require_once('shop.customer.class.php');
require_once('shop.order.class.php');
require_once('shop.product.class.php');
require_once('shop.settings.class.php');
require_once('shop.shopping.class.php');
