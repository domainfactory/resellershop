<?php

// Methoden dieser Klasse bereiten Daten für einzelne Seiten auf
class modIndex {

  private static $actions = array('index','tarife','addons','cart','login','register','checkout','order_successful','contract');


  // TLD-Gruppen-ID bei Whois-Abfragen, in der die beim Whois zusätzlich
  // abgefragten Domains enthalten sind
  const WHOIS_DEFAULT_GROUP_ID = 2;

  // Anzahl der günstigsten TLDs, die dargestellt werden sollen
  const TLD_CHEAPEST_COUNT = 5;

  // Dialog nach dem Hinzufügen des Tarifs in den Warenkorb darstellen?
  const SHOW_TARIFF_UPSELL = false;


  //////////////////// ACTIONS //////////////////////

  // An dieser Stelle existiert pro Seite, die eigene Daten
  // erwartet, eine eigene Methode zum Aufbereiten dieser Werte.

  public static function indexAction() {
    // Produkte für Tarifvergleich auslesen
    $ahTariffCompare = static::includeProductCompare(array(
      'settings_file' => 'products',
      'assign_settings' => 'product_settings',
    ));
    Renderer::assign('tariffcompare',$ahTariffCompare);

    // TLDs, die bei Abfrage ohne TLD gesucht werden sollen
    $hDefaultTlds = shopProduct::getTLDNamesFromTLDGroup();

    // Weitere Domains abfragen -> Domains der erster Standard-Domaingruppe
    $hGroupTlds = shopProduct::getTLDNamesFromTLDGroup(array(
      'ptgid' => static::WHOIS_DEFAULT_GROUP_ID,
    ));

    // Günstigste TLDs des Shops abfragen
    $ahHighlightTlds = shopProduct::getCheapestTLDs(array(
      'return_limit' => static::TLD_CHEAPEST_COUNT,
    ));

    Renderer::assign('tlds', array(
      'additional' => $hGroupTlds,
      'default'    => $hDefaultTlds,
      'highlights' => $ahHighlightTlds,
    ));

    // Intervall für Preisanzeige bereitstellen
    Renderer::assign('interval',shopProduct::readInterval(array(
      'return_shopformat' => 1,
    )));
  }

  public static function tarifeAction() {
    // Daten für Tarifvergleich auslesen und bereitstellen
    $ahTariffCompare = static::includeProductCompare(array(
      'return_shopformat_grouped' => 1,
      'settings_file' => 'products',
      'assign_settings' => 'product_settings',
    ));
    Renderer::assign('tariffcompare',$ahTariffCompare);

    $ahTariffs = shopShopping::readStore(array(
      'norm' => 'tariff',
      'check_orderable' => 1,
      'return_array' => 1,
      'return_contained_product' => 1,
      'return_detail_limits' => 1,
      'return_shop_price' => 1,
    ));
    Renderer::assign('tariff_groups', $ahTariffs);

    // Intervall für Preisanzeige bereitstellen
    Renderer::assign('interval',shopProduct::readInterval(array(
      'return_shopformat' => 1,
    )));
  }

  public static function addonsAction() {
    // Gruppierte Auflistung der Addons
    $ahAddons = shopShopping::getAddons();
    Renderer::assign('addon_groups', $ahAddons);

    // Intervall für Preisanzeige bereitstellen
    Renderer::assign('interval',shopProduct::readInterval(array(
      'return_shopformat' => 1,
    )));
  }

  public static function domainsAction() {
    // Detaillierte Daten für Produktvergleiche
    $hTLD = shopProduct::getTLDHash(array(
      'return_interval' => 1,
    ));

    // TLDs, die bei Abfrage ohne TLD gesucht werden sollen
    $hTLD['default'] = shopProduct::getTLDNamesFromTLDGroup();

    // Weitere Domains abfragen -> Domains der erster Standard-Domaingruppe
    $hTLD['additional'] = shopProduct::getTLDNamesFromTLDGroup(array(
      'ptgid' => static::WHOIS_DEFAULT_GROUP_ID,
    ));

    Renderer::assign('tlds', $hTLD);

    // Preis des günstigsten Tarifs auslesen
    $fCheapestTariff = shopProduct::getCheapestStorePrice(array(
      'norm' => 'tariff',
    ));
    Renderer::assign('cheapest_tariff', $fCheapestTariff);

    // Intervall für Preisanzeige bereitstellen
    Renderer::assign('interval',shopProduct::readInterval(array(
      'return_shopformat' => 1,
    )));
  }

  public static function cartAction(){
    $cart = shopShopping::getCartData();
    $ahAddons = shopShopping::getAddons();
    $ahIntervals = shopProduct::readInterval(array(
      'return_shopformat' => 1,
    ));
    Renderer::assign('cart',$cart);
    Renderer::assign('addon_groups',$ahAddons);
    Renderer::assign('interval',$ahIntervals);
    Renderer::assign('interval',shopProduct::readInterval(array(
      'return_shopformat' => 1,
    )));
  }

  public static function loginAction(){
    if ( Settings::getValue(SETTINGS_FILE, 'register', 'only_new_customers') ) {
      Renderer::setAction('register');
      static::registerAction();
      return;
    }
    if (array_key_exists('_login',$GLOBALS['_POST'])){
      $login = array(
        'name' => $GLOBALS['_POST']['_login']['user'],
        'pass' => $GLOBALS['_POST']['_login']['password'],
        'return_customer' => 1,
      );
      if (strlen($login['name']) && strlen($login['pass'])){
        $customer = bbRpc::call('shLogin::setShopCustomer',$login);
        if (is_array($customer)){
          Renderer::setAction('checkout');
          session_start();
          $_SESSION['customer'] = $customer;
          session_write_close();
          static::checkoutAction();
        }
      }
    }
  }

  public static function registerAction(){
    $ahCountries = shopCustomer::readCountry(array(
      'active' => 1,
      'return_array' => 1,
    ));
    $ahPayments = shopCustomer::readPayment(array(
      'return_array' => 1,
    ));
    $ahTitles = shopCustomer::readTitle(array(
      'return_array' => 1,
    ));

    $ahLanguages = array(
      1 => array(
        'laid' => 1,
        'name' => "Deutsch",
        'active' => 1,
        'preset' => 1,
      ),
    );

    $iMinCreditCardAcceptedYear = date('Y');
    $ahMonths = array(
      '',
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember'
    );

    $sYoungestDateAllowed = date('Y-m-d', strtotime('-18 years +11 hours'));

    Renderer::assign('countries', $ahCountries);
    Renderer::assign('payments', $ahPayments);
    Renderer::assign('months', $ahMonths);
    Renderer::assign('min_year', $iMinCreditCardAcceptedYear);
    Renderer::assign('titles', $ahTitles);
    Renderer::assign('languages', $ahLanguages);
    Renderer::assign('youngest_date_allowed', $sYoungestDateAllowed);

    $bErrorOccured = false;
    if (array_key_exists('data',$GLOBALS['_POST']) && is_array($GLOBALS['_POST']['data'])){
      $customer = $GLOBALS['_POST']['data'];
      $customer['ceid'] = 0;
      $country = shopCustomer::readCountry(array(
        'ccid' => $customer['adress']['cus']['ccid'],
      ));
      $customer['laid'] = 1;
      $customer['cusnr'] = shopCustomer::getFreeCusNr();
      $customer['alid'] = 2;
      $customer['tax_rate'] = $country['default_tax_rate'];
      $customer['user']['name'] = shopCustomer::getFreeCusLogin();

      // Geburtsdatum formatieren
      $sOldBirthDate = null;
      if ( array_key_exists('birthdate', $customer) && $customer['birthdate'] ) {
        $sOldBirthDate = $customer['birthdate'];
        $customer['birthdate'] = preg_replace(
          '/^(19|20)(\d{2})-(\d{1,2})-(\d{1,2})$/',
          '$4.$3.$1$2',
          trim($customer['birthdate'])
        );

      // Geburtstag nicht angegeben, aber erwartet
      } elseif ( Settings::getValue(SETTINGS_FILE, 'register', 'show_birthdate') ) {
        Status::addError('Bitte geben Sie Ihr Geburtsdatum an', null, 'birthdate');
      }

      // Gültigkeit der Kreditkarte prüfen
      if ( $hPayment = shopCustomer::readPayment(array("cpid" => $customer['payinfo']['cpid'])) ) {
        if ( $hPayment['typ'] == 'cc' ) {
          $currentMonth = date('m');
          $currentYear = date('Y');
          if (    $customer['payinfo']['cc_valid_month'] < $currentMonth
               && $customer['payinfo']['cc_valid_year'] <= $currentYear ) {
            Status::addError('Ihre Kreditkarte ist nicht mehr gültig', null, 'cc_valid_month', 'payinfo');
          }
        // SEPA-Verbindung
        } elseif ( $hPayment['typ'] == 'sepa' || $hPayment['typ'] == 'sepa_sl' ) {
          $customer['payinfo']['sepa_mr'] = shopCustomer::getFreeSepaMr();
        }
      }
      unset($hPayment);

      if (!array_key_exists('fax',$customer['adress']['cus'])){
        $customer['adress']['cus']['fax'] = '';
      }

      // Serverseitige Validierung der Kundendaten
      if ( !shopCustomer::validateEntry($customer) ) {
        $bErrorOccured = true;
      }

      // Stimmen die Passwörter überein?
      if ( !array_key_exists('password2', $customer['user']) || $customer['user']['password'] !== $customer['user']['password2'] ) {
        Status::addError('Die beiden Passwörter stimmen nicht überein',null,'password2',null,null,'user');
        $bErrorOccured = true;
      }
      if ( $bErrorOccured ) {
        if ( $sOldBirthDate !== null ) {
          $customer['birthdate'] = $sOldBirthDate;
        }
        Renderer::assign('data', $customer);
      } else {
        session_start();
        $_SESSION['customer'] = $customer;
        session_write_close();
        Renderer::setAction('checkout');
        static::checkoutAction();
      }
    }else{
      if (array_key_exists('customer',$_SESSION)){
        $customer = $_SESSION['customer'];
        Renderer::assign('data', $customer);
        shopCustomer::validateEntry($customer);
      }
    }
  }

  public static function checkoutAction(){
    if (!array_key_exists('customer',$_SESSION)){
      Renderer::setAction('register');
      static::registerAction();
    }else{
      $customer = $_SESSION['customer'];
      $cart = shopShopping::getCartData();

      $aiCustomerCountries = array($customer['adress']['cus']['ccid']);
      if ( $customer['adress']['inv'] && array_key_exists('ccid', $customer['adress']['inv']) ) {
        $aiCustomerCountries[] = $customer['adress']['inv']['ccid'];
      }

      $ahCountries = shopCustomer::readCountry(array(
        'ccid' => $aiCustomerCountries,
        'active' => 1,
        'return_array' => 1,
      ));
      $ahPayments = shopCustomer::readPayment(array(
        'return_array' => 1,
        'return_shopformat' => 1,
      ));
      Renderer::assign('countries', $ahCountries);
      Renderer::assign('payments', $ahPayments);

      $ahIntervals = shopProduct::readInterval(array(
        'return_shopformat' => 1,
      ));
      Renderer::assign('interval',$ahIntervals);
      Renderer::assign('cart',$cart);
      Renderer::assign('customer',$customer);
      Renderer::assign('interval',shopProduct::readInterval(array(
        'return_shopformat' => 1,
      )));
    }
  }

  public static function orderSuccessfulAction() {
    if (array_key_exists('customer',$_SESSION)){
      $bAgbSigned = (array_key_exists('agb', $GLOBALS['_POST'])) && $GLOBALS['_POST']['agb'];
      if ( !$bAgbSigned ) {
        Renderer::setAction('checkout');
        Status::addError('Bitte bestätigen Sie die AGB', null, 'agb');
        static::checkoutAction();
        return;
      }
      $customer = $_SESSION['customer'];
      $data = rpHelper::mergeHash(shopCustomer::defaultsEntry(array('return_user'=>1,'return_policy'=>1)),$customer);
      $data['set_uid'] = 1;
      if($customer['ceid'] || $customer['ceid'] = shopCustomer::saveEntry($data)){
        if($order = shopShopping::addCartToOrder(array(
          'ceid'      => $customer['ceid'],
          'send_mail' => 1,
        ))){
          session_start();
          unset($_SESSION['customer']);
          $_SESSION['order'] = $order;
          $_SESSION['order']['ceid'] = $customer['ceid'];
          $_SESSION['laid']['laid'] = 1;
          session_write_close();
        }
      }
      Renderer::assign('interval',shopProduct::readInterval(array(
        'return_shopformat' => 1,
      )));
    }
  }

  public static function contractAction() {
    rpHelper::addFileHeader('contract.pdf');
    echo(shopOrder::getContractPdf(array(
      'sg_args' => array(
        'ceid'  => $_SESSION['order']['ceid'],
        'oeid'  => $_SESSION['order']['oeid'],
        'scale' => $_SESSION['order']['scale'],
      )
    )));
  }


  //////////////////// DATA //////////////////////

  // Wiederverwenden eigener Daten


  private static function checkDomainData($hParams=array()) {
    $iFirstDot = strpos($hParams['name'], '.');
    // Kein Punkt angegeben -> TLD vergessen
    if ( $iFirstDot === FALSE ) {
      $name = $hParams['name'];
      $tld = '';
    } else {
      $name = substr($hParams['name'], 0, $iFirstDot);
      $tld = substr($hParams['name'], $iFirstDot+1);
    }
    if ( !$name ) {
      if ( $tld ) {
        Status::addWarning('Bitte geben Sie einen Domainnamen zur Endung ".'.$tld.'" an.');
      } else {
        Status::addWarning('Bitte geben Sie eine Domain im Format name.endung (z. B. "test.de") an.');
      }
      return;
    }
    if ( !$tld ) {
      Status::addWarning('Bitte fügen Sie zu "'.$name.'" eine Domainendung (z. B. .de) an.');
      return;
    }

    if ( !preg_match("/[\x21-\xFF]/", $hParams['name']) ) {
      Status::addWarning('In der Domain '.$hParams['name'].' befinden sich Sonderzeichen internationaler Domains. Diese werden derzeit nicht unterstützt.');
      return;
    }

    // Wird die TLD auch angeboten?
    $hTld = shopProduct::readTld(array(
      'name' => $tld,
      'return_domcon' => 1,
    ));
    if ( !$hTld || !$hTld['active'] || !count($hTld['domcon']) ) {
      Status::addWarning("Die Domainendung .".$tld." bieten wir nicht zur Bestellung an.");
      return;
    }

    $args = array(
      'name'       => $name,
      'tld'        => $tld,
      'make_whois' => 1,
    );
    return shopShopping::checkDomain($args);
  }

  private static function renderDomainData($hDomainData, $hParams=array()) {
    if ( $hDomainData ) {
      foreach ( $hDomainData as $i => &$hDomain ) {

        // SCID auch dem Element zuweisen
        if ( array_key_exists('scid', $hParams) && $hDomain ) {
          $hDomain['scid'] = $hParams['scid'];
        } else {
          $hCartData = shopShopping::getCartData();
          foreach ( $hCartData['items']['domain'] as $hCartDomain ) {
            if ( $hCartDomain['attribute'] && $hCartDomain['attribute']['name'] == $hParams['name'] ) {
              $hDomain['scid'] = $hCartDomain['scid'];
              break;
            }
          }
        }

        $hDomain['price_default'] = false;

        // Preis unbekannt? -> Günstigsten Preis auslesen
        if ( $hDomain['price_long'] === null ) {
          $iPtid = $hDomain['ptid'];
          $hTldData = shopProduct::getDefaultTLDPrices(array(
            'ptid' => $iPtid,
          ));
          if ( count($hTldData) && array_key_exists($iPtid, $hTldData) ) {
            $hDomain['price_long'] = $hTldData[$iPtid]['shop_price']['price_long'];
            $hDomain['price_net'] = $hTldData[$iPtid]['shop_price']['price_net'];
            $hDomain['piid'] = $hTldData[$iPtid]['piid'];
            if ( array_key_exists('int_shop_price', $hTldData[$iPtid]) ) {
              $hDomain['int'] = array(
                'price_long' => $hTldData[$iPtid]['int_shop_price']['price_long'],
                'price_net' => $hTldData[$iPtid]['int_shop_price']['price_net'],
              );
            }
            $hDomain['price_default'] = true;
          }
        }

        $hDomain['price_missing'] = ($hDomain['price_long'] === null);
      }
      unset($hDomain);
    }

    $hIntervals = shopProduct::readInterval(array(
      'return_shopformat' => 1,
    ));
    $hIntervals[0] = "pro Jahr";

    Renderer::assign('whois', $hDomainData);
    Renderer::assign('interval', $hIntervals);

    return array(
      'template' => Renderer::render('modules/domainsearch_results.tpl'),
      'assigns' => array(
        'whois' => $hDomainData,
      ),
    );
  }


  //////////////////// RPC //////////////////////

  // Methoden, die per AJAX-Anfragen direkt aufgerufen werden


  public static function sendContactRequest($hParams=array()) {
    try {
      if ( !$hParams ) {
        throw new InvalidArgumentException('Ihre Anfrage kann leider nicht versendet werden.');
      }

      // Validierung der Eingaben
      if ( !array_key_exists('name', $hParams) || strlen(trim($hParams['name'])) < 3) {
        Status::addError('Bitte geben Sie Ihren Namen an.', null, 'name');
      }
      if ( !array_key_exists('mail', $hParams) || !filter_var(trim($hParams['mail']), FILTER_VALIDATE_EMAIL) ) {
        Status::addError('Bitte geben Sie eine gültige E-Mail-Adresse an.', null, 'mail');
      }
      if ( !array_key_exists('subject', $hParams) || strlen(trim($hParams['subject'])) < 3) {
        Status::addError('Bitte fassen Sie im Betreff kurz das Thema Ihrer Nachricht zusammen.', null, 'subject');
      }
      if ( !array_key_exists('message', $hParams) || strlen(trim($hParams['message'])) < 10) {
        Status::addError('Bitte teilen Sie uns Ihr Anliegen mit.', null, 'message');
      }

      $sNotification = '';

      if ( !Status::hasErrors() ) {
        // Ziel-Mailadresse aus den Einstellungen auslesen
        $sMailTargetReciepient = Settings::getValue(SETTINGS_FILE,'contact','mail_target');
        if ( !filter_var($sMailTargetReciepient, FILTER_VALIDATE_EMAIL) ) {
          throw new Exception('Ihre Anfrage konnte leider nicht versendet werden.');
        }

        // Inhalt der Mail zum Absenden vorbereiten
        $sSubject = (array_key_exists('subject', $hParams)) ? utf8_decode(trim($hParams['subject'])) : "Kein Betreff angegeben";
        Renderer::assign('mail', $hParams);
        $sMailContent = Renderer::render('contact_mail.tpl');

        $sHeaders = "From: Ihr Reseller-Shop <shop@reseller-shop.eu>\n";
        // Antworten direkt an Absender der Nachricht senden
        if ( array_key_exists('mail', $hParams) && $hParams['mail'] ) {
          $asCharsToEscape = array("\r","\n",'<','>');
          $asReplaceChars = array('','','','');
          $sName = array_key_exists('name', $hParams) ? trim($hParams['name']) : $hParams['mail'];
          $sHeaders .= "Reply-To: "
                        .str_replace($asCharsToEscape, $asReplaceChars, $sName)
                        .' <'.str_replace($asFieldsToEscape, $asReplaceChars, $hParams['mail']).">\n";
        }

        // Mail versenden
        $bMailSent = mail(
          $sMailTargetReciepient,
          "[Shop-Anfrage] ".$sSubject,
          $sMailContent,
          $sHeaders
        );
        if ( !$bMailSent ) {
          throw new Exception('Es trat ein Fehler beim Absenden Ihrer Anfrage auf.');
        }

        $sNotification = Renderer::render('content/modal_contact_submitted.tpl');

        // Eingabefelder wieder leeren
        $hParams = array();
      }

      Renderer::assign('mail', $hParams);

      $sForm = Renderer::render('modules/contact_form.tpl');

      return array(
        'template' => $sForm,
        'dialog' => $sNotification,
        'assigns'  => array(),
      );

    } catch (Exception $e) {
      Status::addError($e->getMessage());
      return array(
        'assigns'  => array(),
      );
    }
  }


  public static function changeAmount($hParams=array()) {
    if ( !shopShopping::saveCartItem($hParams) ) {
      Status::addWarning("Die Anzahl des Produkts konnte nicht geändert werden");
    }
    return static::getCart($hParams);
  }


  public static function addToCart($hParams=array()){
    // Keine Produkt-ID uebergeben
    if ( !$hParams['peid'] ) {
      // sofort abbrechen
      Status::addError("Es wurde keine Produkt-ID uebergeben");
      return;
    }

    // Produktdaten auslesen
    $hProduct = shopProduct::readEntry(array(
      "peid" => $hParams["peid"]
    ));

    // Produkt unsichtbar
    if ( !$hProduct['visible'] ) {
      Status::addWarning("Das Produkt konnte nicht in den Warenkorb gelegt werden");

    // Sicherheitsfrage bei Tarifwechsel
    } elseif ( $hProduct['norm'] == 'tariff' && $hCurrentTariff = shopShopping::getTariff() && !$hParams['signed'] ) {

      // Daten fuer Dialog mit den bevorstehenden Hinweisen auslesen
      $ahAlerts = shopShopping::changeTariffAlerts( array("peid" => $hParams["peid"]) );
      Renderer::assign('alerts', $ahAlerts);
      Renderer::assign('tariff', $hProduct);
      return array(
        'template' => Renderer::render('content/modal_tariff_change.tpl'),
        'assigns' => array(
          'action' => 'show_dialog',
          'new_tariff' => $hProduct,
        ),
      );

    // Produkt in Warenkorb legen
    } else {

      // Liegt das Produkt bereits im Warenkorb?
      if ( $hNewCartItem = shopShopping::isInCart(array("peid" => $hParams["peid"])) ) {
        // Anzahl des Produkts erhoehen
        $hNewCartItem["amount"]++;

      // Produkt liegt noch nicht im Warenkorb
      } else {
        $hNewCartItem = array(
          "scid" => 0,
          "peid" => $hParams["peid"],
          "amount" => 1,
        );
      }

      // Speichern des Artikels im Warenkorb
      if ( $iScid = shopShopping::saveCartItem($hNewCartItem) ){

        if ( !Status::hasErrors() ) {
          if ( $hNewCartItem['amount'] ) {
            Status::addSuccess($hProduct['name']." wurde in den Warenkorb gelegt.");
          } else {
            Status::addSuccess($hProduct['name']." wurde aus dem Warenkorb entfernt.");
          }
        }

        // Speichern erfolgreich -> Warenkorb auslesen
        $returnCart = static::getCart($hParams);
        $returnCart['assigns']['scid'] = $iScid;
        $returnCart['assigns']['peid'] = $hProduct['peid'];

        // Dialog nach dem Hinzufügen eines Tarifs darstellen
        // Prüfung auf signed -> nur einmal statt bei jedem Tarif anzeigen
        if ( static::SHOW_TARIFF_UPSELL && $hProduct['norm'] === 'tariff' && !$hParams['signed'] ) {
          Renderer::assign('tariff', $hProduct);
          $returnCart['assigns']['dialog'] = Renderer::render('content/modal_upsell_tariff.tpl');
          $returnCart['assigns']['action'] = 'add_dialog';
        }

        return $returnCart;

      // Speichern nicht erfolgreich
      } else {
        Status::addWarning("Das Produkt konnte nicht in den Warenkorb gelegt werden");
      }
    }

    return;
  }


  public static function addDomainToCart($hParams=array()) {
    $hNewItem = array();
    $hDomainData = array();
    $bRemove = false;

    if ( $hParams['status'] === 'cart' ) {

      // Domains, die bereits im Warenkorb liegen, entfernen
      $hNewItem = array(
        'amount' => 0,
        'peid'   => $hParams['peid'],
        'scid'   => $hParams['scid'],
      );
      $bRemove = true;

    } else {
      // Domain in den Warenkorb hinzufuegen
      $hNewItem['scid'] = 0;
      foreach ( array('scid','token', 'amount','authcode','signed') as $sField ) {
        if ( array_key_exists($sField, $hParams) ) {
          $hNewItem[$sField] = $hParams[$sField];
        }
      }

      // Daten auslesen, damit sie für Speichervorgang zur Verfügung stehen
      $hDomainData = static::checkDomainData($hParams);
    }

    $newScid = shopShopping::saveCartItem($hNewItem);

    if ( !count($hDomainData) ) {
      $hDomainData = static::checkDomainData($hParams);
    }

    if ( $newScid && $hParams['status'] !== 'cart' ) {
      $hDomainData[0]['status'] = 'cart';
      $hDomainData[0]['scid'] = $newScid;
    }

    // Produkt aus dem Warenkorb entfernen? -> newScid ist jetzt Speicherzustand
    if ( array_key_exists('amount', $hNewItem) && !$hNewItem['amount'] ) {
      $newScid = null;
    }

    $hParams['scid'] = $newScid;

    if ( $newScid !== null ) {
      Status::addSuccess($hDomainData[0]['name'].' wurde in den Warenkorb gelegt');
    } else {
      Status::addSuccess($hDomainData[0]['name'].' wurde aus dem Warenkorb entfernt');
    }

    // Domain mit den neuen Daten rendern
    $returnDomain = static::renderDomainData($hDomainData, $hParams);
    return $returnDomain;
  }


  public static function checkDomain($hParams=array()) {
    $hDomainData = static::checkDomainData($hParams);
    if ( Status::hasErrors() ) {
      return array(
        'assigns' => array(
          'whois' => $hDomainData,
          'params' => $hParams,
        ),
      );
    }
    return static::renderDomainData($hDomainData, $hParams);
  }

  /**
   * Artikel aus dem Warenkorb auslesen
   *
   * @param array [$hParams] Parameter fuer bbShopping::readCart
   * @return array
   */
  public static function getCart($hParams=array()) {
    $bReturnCartOrder = false;
    if ( array_key_exists('return_shop_cart_order', $hParams) ) {
      $bReturnCartOrder = $hParams['return_shop_cart_order'];
      unset($hParams['return_shop_cart_order']);
    }

    $cart = shopShopping::getCartData($hParams);
    // Alle Artikel der abgefragten Produkttyps auslesen
    $hTypeItems = null;
    if ( array_key_exists('return_norms', $hParams) && count($hParams['return_norms']) ) {
      $hTypeItems = shopShopping::readStore(array(
        'norm' => $hParams['return_norms'],
        'return_array' => 1,
        'return_orderable' => 1,
      ));
    }

    $hAssigns = array(
      'count' => $cart['item_count'],
      'items' => $cart['items'],
      'norms' => $hTypeItems,
    );


    Renderer::assign('cart', $cart);
    if ( $bReturnCartOrder ) {
      $sTemplate = Renderer::render('modules/order_cart_sidebar.tpl');

      // Haupt-Darstellung rendern
      $ahIntervals = shopProduct::readInterval(array(
        'return_shopformat' => 1,
      ));
      $ahIntervals[0] = 'einmalig';
      $ahIntervals['descr'][0] = 'einmalig';
      Renderer::assign('interval',$ahIntervals);
      Renderer::assign('cart', $cart);
      Renderer::assign('cart_editable', true);
      $hAssigns['overview'] = Renderer::render('modules/cart_articles.tpl');
    } else {
      $sTemplate = Renderer::render('modules/cart_nav.tpl');
    }

    // Template rendern und Daten zurueck geben
    return array(
      'template' => $sTemplate,
      'assigns' => $hAssigns,
    );
  }

  /**
   * Daten fuer Produktbereiche aufbereiten
   *
   * @param array $hParams      Parameter für shopProduct::readEntry und Assigns
   * @return array
   */
  protected static function includeProductCompare($hParams=array()) {
    if ( array_key_exists('settings_file', $hParams) ) {
      $sSettingsFile = $hParams['settings_file'] ? $hParams['settings_file'] : 'products';
      unset($hParams['settings_file']);
      $hParams['shop_settings'] = Settings::get($sSettingsFile);
    }

    // Einstellungen dem Renderer zuweisen
    $sSettingsAssignName = null;
    if ( array_key_exists('assign_settings', $hParams) ) {
      $sSettingsAssignName = $hParams['assign_settings'];
      Renderer::assign($sSettingsAssignName, $hParams['shop_settings']);
      unset($hParams['assign_settings']);
    }

    // Produkt-IDs setzen
    if ( !array_key_exists('peid', $hParams) ) {
      $hParams['peid'] = $hParams['shop_settings']['products']['peid'];
    }

    // Daten für Vergleiche formatieren
    $hParams['return_shopformat'] = 1;

    // Daten auslesen und zurückgeben
    return shopProduct::readEntry($hParams);
  }


}

