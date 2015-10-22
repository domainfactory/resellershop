<?php

// Benötigte Skripte zum Ablauf holen
// Diese Datei bindet die include/autoloader.php ein,
// welche selbst alle benötigteten Skripte auflistet.
require_once(__DIR__.'/include/config.inc.php');

// Produkt direkt beim Seitenaufruf in den Warenkorb legen
if ( array_key_exists('add', $_GET) && is_numeric($_GET['add']) ) {
  modIndex::addToCart(array(
    'peid' => trim($_GET['add']),
  ));
}

// Welches Modul soll dargestellt werden?
// Die Renderer-Klasse befindet sich unter include/renderer.class.php
$action = Renderer::getAction();

// Daten für das darzustellende Modul bereitstellen
// Die Aktionen weisen alle benötigten Daten für die jeweiligen Module zu
// Die modIndex-Klasse befindet sich unter include/mod.index.class.php
if ( $action === 'index' ) {
  modIndex::indexAction();
} elseif ( $action === 'tarife' ) {
  modIndex::tarifeAction();
} elseif ( $action === 'addons' ) {
  modIndex::addonsAction();
} elseif ( $action === 'domains' ) {
  modIndex::domainsAction();
} elseif ( $action === 'cart' ) {
  modIndex::cartAction();
} elseif ( $action === 'login' ) {
  modIndex::loginAction();
} elseif ( $action === 'register' ) {
  modIndex::registerAction();
} elseif ( $action === 'checkout' ) {
  modIndex::checkoutAction();
} elseif ( $action === 'order_successful' ) {
  modIndex::orderSuccessfulAction();
} elseif ( $action === 'contract' ) {
  modIndex::contractAction();
}

// Quelltext zur Darstellung ausgeben
Renderer::display();
