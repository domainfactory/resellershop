<?php

require_once(__DIR__.'/autoloader.php');

// Sicherstellen, dass der Namespace immer korrekt zur Verfügung steht
use \bbRpc as bbRpc;

// Welche Einstellungsdatei soll verwendet werden?
define('SETTINGS_FILE', 'global');


// VERBINDUNG ZU IHREM RP-SYSTEM

// Stehen die globalen Einstellungen zur Verfügung?
if ( !Settings::getValue(SETTINGS_FILE) ) {
  Renderer::renderFatal('Bitte entschuldigen Sie die Unannehmlichkeiten.');
}

// Werte aus der Konfiguration auslesen
define('RP_URL',         Settings::getValue(SETTINGS_FILE, 'rpc', 'url'));
define('RP_GUEST_TOKEN', Settings::getValue(SETTINGS_FILE, 'rpc', 'token'));


// Löschen der gecachten Sitzungsdaten nach x Sekunden
ini_set('session.gc_maxlifetime', '1800');


// RPC-VERBINDUNG ZU RP-SYSTEM HERSTELLEN

// Pfad zum Verzeichnis, in dem der RPC-Cookie gespeichert werden soll
define('BBRPC_COOKIE', DIR_SHOP_ROOT.'bb.rpc.cookie');

if ( RP_URL ) {
  bbRpc::setUrl(RP_URL);
}
// Mit Gast-Token authentifizieren
if ( RP_GUEST_TOKEN ) {
  bbRpc::setGUESTToken(RP_GUEST_TOKEN);
}
bbRpc::setUTF8Native(1);

// PHP-Modul session wird benötigt
if ( !function_exists('session_start') || !function_exists('session_write_close') ) {
  Renderer::renderFatal('Bitte stellen Sie sicher, dass das PHP-Modul "session" zur Verfügung steht.');
}


session_start();

// Neue Sitzung erstellen
if ( !$_SESSION['rpc_sid'] ) {

  // Am RP-System mit Gast-Token anmelden
  if ( bbRpc::auth() === NULL ) {
    if ( Renderer::DEBUG ) {
      Status::injectRPCMsgs();
      Renderer::assign('_msgs', Status::getMessages());
    }
    Renderer::renderFatal('Verbindung zum Shop-System konnte nicht hergestellt werden.');
  }

  // Vom RP verwendete Sitzungs-ID für nächste Seitenaufrufe speichern
  $_SESSION['rpc_sid'] = bbRpc::getSid();

// Bestehende Sitzung wiederherstellen
} else {
  // RP-Sitzung wiederverwenden
  bbRpc::setSid($_SESSION['rpc_sid']);
}

// Werte der Sitzung speichern
// Nach diesem Aufruf steht das $_SESSION-Array dem Skript nicht mehr bereit
session_write_close();
