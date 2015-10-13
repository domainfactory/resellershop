<?php

class shopProduct extends rpProduct {

  // Zu verwendende Sprache beim Auslesen von Texten
  const LANGUAGE = 'de';


  //////////////////// DOMAIN-KONTINGENTE //////////////////////


  private static $iDefaultDomConID = null;

  /**
   * ID des Standard-Domainkontingents auslesen (und cachen)
   *
   * @return array
   */
  protected static function getDefaultDomConID() {
    if ( is_null(static::$iDefaultDomConID) ) {
      $hDefaultDomCon = static::readDomCon(array(
        'preset' => 1,
      ));
      if ( $hDefaultDomCon ) {
        static::$iDefaultDomConID = $hDefaultDomCon['pdid'];
      }
    }
    return static::$iDefaultDomConID;
  }


  //////////////////// LIMITS //////////////////////


  /**
   * Darzustellenden Namen des Limits zurückgeben
   *
   * @param array $hProductLimit        Daten des Limits
   * @param array $hLimitSettings       Daten aus den Einstellungen (product.ini)
   * @param int $iKey                   zu verwendender Schlüssel
   * @return array
   */
  public static function makeLimit($hProductLimit, $hLimitSettings, $iKey) {
    // Name des Limits aus products.ini verwenden?
    if ( trim($hLimitSettings['name'][$iKey]) ) {
      $hProductLimit['name'] = $hLimitSettings['name'][$iKey];
    }
    return $hProductLimit;
  }


  //////////////////// PRODUKTE //////////////////////


  /**
   * Daten zu einem oder mehreren Artikeln auslesen
   *
   * @param array $hParams      Zusätzliche Parameter für readEntry
   * @return array
   */
  public static function readEntry($hParams=array()) {
    $bRetSF    = ($hParams['return_shopformat']) ? 1 : 0;
    $bRetGroup = ($hParams['return_shopformat_grouped']) ? 1 : 0;

    // shopformat-Parameter nicht ans RP senden
    unset($hParams['return_shopformat']);
    unset($hParams['return_shopformat_group']);

    // Anpassungen fuer Shop-Aufruf
    if ( $bRetSF || $bRetGroup ) {
      $settings = Settings::getValue('products');
      $hParams['peid'] = $settings['products']['peid'];
      $hParams['check_orderable']      = 1;
      $hParams['return_array']         = 1;
      $hParams['return_shop_price']    = 1;
      $hParams['return_detail_limits'] = 1;
      if ( $bRetGroup ) {
        $hParams['return_display_limits'] = 1;
      }
    }

    // Daten vom RP abfragen
    $data = parent::readEntry($hParams);

    // Ergebnisse fuer Shop weiterverarbeiten
    if ( $bRetSF && $data ) {
      // Limits vorbereiten
      foreach ( array('limits', 'limits_hidden') as $sRequiredField ) {
        if (    !array_key_exists($sRequiredField, $settings)
             || !is_array($settings[$sRequiredField]) ) {
          $settings[$sRequiredField] = false;
        }
      }
      $bHasLimits       = $settings['limits']        && count($settings['limits']['fld']) >= 0;
      $bHasHiddenLimits = $settings['limits_hidden'] && count($settings['limits_hidden']['fld']) >= 0;
      $hAllLimits = array();
      $hAllLimitGroups = array();
      // Datensaetze einzelner Produkte der API verarbeiten
      foreach ( $data as $id => $entry ) {
        // Eigene Beschreibung aus der products.ini verwenden
        $sCustomDescr = $settings['products']['descr'][array_search($entry['peid'], $settings['products']['peid'])];
        if ( trim($sCustomDescr) !== '' ) {
          $data[$id]['descr'] = $sCustomDescr;
        }
        // Limitfelder vorausfuellen, um Zugriffsfehler in Templates zu verhindern
        $data[$id]['shop_limits'] = array();
        $data[$id]['shop_limits']['limits'] = array();
        $data[$id]['shop_limits']['limits_hidden'] = array();
        if ( $bRetGroup ) {
          $data[$id]['shop_limits']['limits_grouped'] = array();
        }
        // Wird nach keinen Limits in den INIs gefragt, dann diese ignorieren
        if ( !$bHasLimits && !$bHasHiddenLimits ) {
          continue;
        }
        // Keine Limits vorhanden? Dann nicht nach Limits suchen
        if ( !is_array($entry['limits']) ) {
          continue;
        }
        // Limits des aktuellen Produkts registrieren
        foreach ( $entry['limits'] as &$hLimitGroup ) {
          // Limitgruppe
          if ( !array_key_exists($hLimitGroup['name'], $hAllLimitGroups) ) {
            $hAllLimitGroups[ $hLimitGroup['name'] ] = array(
              'name' => $hLimitGroup['name'],
              'descr' => $hLimitGroup['descr'],
              'pos' => $hLimitGroup['pos'],
              'entries' => array(),
            );
          }
          // Referenz auf aktuelle Limitgruppe fuer schnellere Zuweisung
          $hCurrentGroupInAllLimits = &$hAllLimitGroups[ $hLimitGroup['name'] ];
          foreach ( $hLimitGroup['entrys'] as &$hLimit ) {
            // Einzelne Limits
            if ( !array_key_exists($hLimit['fld'], $hAllLimits) ) {
              $hAllLimits[ $hLimit['fld'] ] = array(
                'name'  => $hLimit['name'],
                'descr' => $hLimit['descr'],
                'unit'  => $hLimit['unit'],
                'fld'   => $hLimit['fld'],
                'typ'   => $hLimit['typ'],
                'val'   => 0,
                'value' => 0,
              );
              $hCurrentGroupInAllLimits['entries'][] = $hLimit['fld'];
            }
          }
          unset($hLimit);
          unset($hCurrentGroupInAllLimits);
        }
        unset($hLimitGroup);
      }

      // Sortierung der Elemente nach angegebener ID in der products.ini
      $sortedData = array();
      foreach ( $settings['products']['peid'] as $peid ) {
        foreach ( $data as $id => $entry ) {
          if ( $entry['visible'] && $entry['peid'] == $peid ) {
            $sortedData[$id] = $entry;
          }
        }
      }
      unset($data);
      $data = $sortedData;

      // Limits anzeigen
      if ( $bHasLimits || $bHasHiddenLimits ) {
        // sobald alle Limits registriert sind, nochmal die Produkte durchsuchen
        foreach ( $data as $id => $entry ) {
          // Felder aus der product.ini mit Standardwerten fuellen
          foreach ( array('limits', 'limits_hidden') as $sDisplayGroup ) {
            foreach ( $settings[$sDisplayGroup]['fld'] as $sFld ) {
              if ( array_key_exists($sFld, $hAllLimits ) ) {
                $data[$id]['shop_limits'][$sDisplayGroup][$sFld] = static::makeLimit(
                  $hAllLimits[$sFld],
                  $settings[$sDisplayGroup],
                  array_search($sFld, $settings[$sDisplayGroup]['fld'])
                );
              }
            }
          }
          if ( $bRetGroup ) {
            foreach ( $hAllLimits as $sFld => &$hLimit) {
              $data[$id]['shop_limits']['limits_grouped'][$sFld] = $hLimit;
            }
          }
          // Keine Limits vorhanden? Dann nicht nach Limits suchen
          if ( !is_array($entry['limits']) ) {
            continue;
          }
          // Limits
          foreach ( $entry['limits'] as &$hLimitGroup ) {
            foreach ( $hLimitGroup['entrys'] as &$hLimit ) {
              $sFld = $hLimit['fld'];

              // Referenz auf Limit fuer gruppierte Limits setzen
              if ( $bRetGroup ) {
                $data[$id]['shop_limits']['limits_grouped'][$sFld] = $hLimit;
              }

              // Werte des Limits fuer den vergleich setzen
              if ( $bHasLimits && ($iKey = array_search($sFld, $settings['limits']['fld'])) !== false ) {
                $data[$id]['shop_limits']['limits'][$sFld] = static::makeLimit($hLimit, $settings['limits'], $iKey);
              } elseif ( $bHasHiddenLimits && ($iKey = array_search($sFld, $settings['limits_hidden']['fld'])) !== false ) {
                $data[$id]['shop_limits']['limits_hidden'][$sFld] = static::makeLimit($hLimit, $settings['limits_hidden'], $iKey);
              }
            }
            unset($hLimit);
          }
          unset($hLimitGroup);
        }
      }

      $data = array_merge($settings,
        array(
          'entries' => $data,
          'has' => array(
            'limits' => $bHasLimits,
            'limits_hidden' => $bHasHiddenLimits,
          ),
        )
      );
      if ( $bRetGroup ) {
        $data['grouped_limits'] = array(
          'groups' => $hAllLimitGroups,
          'limits' => $hAllLimits,
        );
      }
    }

    return $data;
  }


  //////////////////// INTERVALL //////////////////////


  /**
   * Daten der Intervalle auslesen
   *
   * @param array $hParams      Zusätzliche Daten für readInterval
   * @return array
   */
  public static function readInterval($hParams=array()) {
    // Zusätzliche Daten für Shop zurückgeben?
    $bRetSF = ($hParams['return_shopformat']) ? 1 : 0;
    if ( $bRetSF ) {
      $hParams['return_lang'] = 1;
      $hParams['return_array'] = 1;
    }
    unset($hParams['return_shopformat']);

    // Daten auslesen
    $ahIntervals = parent::readInterval($hParams);
    if ( $bRetSF && $ahIntervals ) {
      $hNames = array('descr' => array());
      foreach ( $ahIntervals as $hInterval ) {
        $hNames[$hInterval['piid']] = $hInterval['name'][static::LANGUAGE];
        $hNames['descr'][$hInterval['piid']] = $hInterval['descr'][static::LANGUAGE];
      }
      $ahIntervals = $hNames;
      $ahIntervals[0] = 'einmalig';
      $ahIntervals['descr'][0] = 'einmalig';
    }

    return $ahIntervals;
  }


  //////////////////// PREISE //////////////////////


  /**
   * Günstigsten Preis eines Produkts auslesen
   *
   * Um die Suche auf einen Produkttyp einzuschränken, geben Sie beim
   * Aufruf der Methode in $hParams folgenden Wert an:
   *   'norm' => 'tariff'
   * In diesem Fall werden nur die Preise der Tarife geprüft.
   *
   * @param array $hParams      Zusätzliche Parameter für Aufruf von readStore
   * @return float|null         Günstiger Preis der gesuchten Artikel
   */
  public static function getCheapestStorePrice($hParams=array()) {
    // Produktgruppen auslesen
    $ahProductGroups = shopShopping::readStore(array_merge(array(
      'check_orderable'   => 1,  // nur bestellbare Produkte
      'return_array'      => 1,  // Immer als Array formatieren
      'return_shop_price' => 1,  // Preis des Shops zurückgeben
    ), $hParams));

    // Sind keine Daten vorhanden, wird als Rückgabewert null angegeben
    $fCheapestPrice = null;

    if ( $ahProductGroups && count($ahProductGroups) ) {
      foreach ( $ahProductGroups as $hProductGroup ) {
        // Befinden sich Produkte in der Gruppe?
        if ( !array_key_exists('entrys', $hProductGroup) || !count($hProductGroup['entrys']) ) {
          continue;
        }

        foreach ( $hProductGroup['entrys'] as $hProduct ) {
          if ( $fCheapestPrice === null || $hProduct['shop_price']['price_long'] < $fCheapestPrice ) {
            $fCheapestPrice = $hProduct['shop_price']['price_long'];

            // Günstiger als kostenlos wirds nicht...
            if ( $fCheapestPrice !== null && $fCheapestPrice === 0.00 ) {
              return 0.00;
            }
          }
        }
      }
    }

    return $fCheapestPrice;
  }


  //////////////////// TLDS //////////////////////


  /**
   * Günstigste TLDs (laut Standard-Domainkontingent) zurückgeben
   *
   * Geben Sie das Feld "return_limit" an, so beschränken Sie die Anzahl
   * der zurückzugebenden Domains.
   *
   * @param array $hParams      Zusätzliche Daten für readTLD
   * @return array
   */
  public static function getCheapestTLDs($hParams=array()){
    // Wie viele Top-TLDs sollen zurueckgegeben werden?
    $iCountDomains = 5;
    if ( array_key_exists('return_limit', $hParams) ) {
      $iCountDomains = $hParams['return_limit'];
      unset($hParams['return_limit']);
    }

    // Alle TLDs zurueckgeben?
    $bReturnAllTlds = false;
    if ( array_key_exists('return_all', $hParams) ) {
      $bReturnAllTlds = $hParams['return_all'];
      unset($hParams['return_all']);
    }

    // Daten der TLDs auslesen
    $ahTLDs = static::readTld(array_merge(array(
      'active'         => 1,  // keine versteckten Produkte auslesen
      'return_domcon'  => 1,  // Domainkontingente mitgeben
      'return_product' => 1,  // Daten zum Produkt mitliefern
      'return_array'   => 1,  // Immer als Array formatieren
    ), $hParams));
    if ( !$ahTLDs ) {
      return array();
    }

    $iDefaultDomConID = static::getDefaultDomConID();
    foreach($ahTLDs as $key => &$tld){
      // Subdomains ignorieren
      if ( count(explode('.', $tld['name'])) > 1 ) {
        unset($ahTLDs[$key]);
        continue;
      }
      $domcon = $tld['domcon'][$iDefaultDomConID];
      $tld['shop_price'] = $domcon;
    }
    unset($tld);

    $data = array();
    if ( $bReturnAllTlds ) {
      usort($ahTLDs, array('static','orderByName'));
      $data['all'] = $ahTLDs;
    }

    usort($ahTLDs, array('static','getCheaperDomain'));
    $data['highlights'] = array_slice($ahTLDs, 0, $iCountDomains);

    if ( $bReturnAllTlds ) {
      return $data;
    }
    return $data['highlights'];
  }

  private static function orderByName($a,$b) {
    if ( $a['name'] == $b['name'] ) {
      return 0;
    }
    return ( $a['name'] < $b['name'] ) ? -1 : 1;
  }

  private static function getCheaperDomain($a, $b) {
    if ( $a['shop_price']['price_long'] == $b['shop_price']['price_long'] ) {
      return 0;
    }
    return ($a['shop_price']['price_long'] < $b['shop_price']['price_long']) ? -1 : 1;
  }


  /**
   * Namen der TLDs einer bestimmten TLD-Gruppe auslesen
   *
   * Geben Sie im Feld "ptgid" des Arrays $hParams die ID der auszulesenden
   * TLD-Gruppe an. Wenn Sie dieses Feld nicht angeben, so werden die TLDs
   * aus der Standard-TLD-Gruppe ausgelesen.
   *
   * @param array $hParams      Zusätzliche Parameter für readTldMap
   * @return array
   */
  public static function getTLDNamesFromTLDGroup($hParams=array()) {
    // Angegebene TLD-Gruppen-ID verwenden?
    if ( array_key_exists('ptgid', $hParams) ) {
      $iGroupId = $hParams['ptgid'];
      unset($hParams['ptgid']);
    } else {
      $hTLDGroup = parent::readTldGroup(array(
        'preset' => 1,  // Standardgruppe auslesen
      ));
      $iGroupId = $hTLDGroup['ptgid'];
    }

    // Verknüpfung der TLDs zur Gruppe auslesen
    $ahDefaultTLDs = parent::readTldMap(array_merge(array(
      'ptgid' => $iGroupId,
    ), $hParams));
    if ( !$ahDefaultTLDs ) {
      return array();
    }

    // IDs zusammenfassen
    $aiIDs = array();
    $iTLDCount = 0;
    $iTLDCount = count($ahDefaultTLDs);
    for ( $i = 0; $i < $iTLDCount; $i++ ) {
      $aiIDs[] = $ahDefaultTLDs[$i]['ptid'];
    }

    // Namen der TLDs auslesen
    $hTLDData = parent::readTld(array(
      'ptid' => $aiIDs,
      'return_array' => 1,
    ));
    if ( !$hTLDData ) {
      return array();
    }

    $hData = array();
    $iTLDCount = count($hTLDData);
    for ( $i = 0; $i < $iTLDCount; $i++ ) {
      $hData[] = $hTLDData[$i]['name'];
    }

    return $hData;
  }


  /**
   * TLD-Preise aus dem Standard-Domainkontingent auslesen
   *
   * @param array $hParams      Zusätzliche Parameter für Aufruf von readTld
   * @return array
   */
  public static function getDefaultTLDPrices($hParams=array()) {
    // Daten zur TLD auslesen
    $ahTLDs = static::readTld(array_merge(array(
      'active'              => 1,  // keine versteckten Produkte auslesen
      'return_domcon'       => 1,  // Domainkontingente mitgeben
      'return_shop_price'   => 1,  // Preis des Shops zurückgeben
      'return_product'      => 1,  // Daten zum Produkt mitliefern
      'return_product_edit' => 1,  // übersetzte Beschreibung mitliefern
      'return_array'        => 1,  // Immer als Array formatieren
    ), $hParams));

    $hEntries = array();

    if ( !$ahTLDs ) {
      return $hEntries;
    }

    // Produkt-IDs der beinhalteten Produkte gesammelt ablesen,
    // um die Anzahl der RP-Anfragen zu minimieren
    $aiContainedProductIDs = array();
    foreach ( $ahTLDs as $hTLD ) {
      if ( !is_null($hTLD['product']['contained']) ) {
        foreach( $hTLD['product']['contained'] as $peid => $amount ) {
          $aiContainedProductIDs[] = $peid;
        }
      }
    }
    $ahContainedProducts = parent::readEntry(array(
      'peid'              => $aiContainedProductIDs,
      'return_shop_price' => 1,
    ));
    unset($aiContainedProductIDs);

    // Betroffenes Domainkontaingent auslesen
    $iDefaultDomConID = static::getDefaultDomConID();

    // Hash der TLDs zusammenbauen
    foreach ( $ahTLDs as $hTLD ) {
      // Daten aus dem Domainkontingent auslesen
      if ( array_key_exists($iDefaultDomConID, $hTLD['domcon']) ) {
        $hDomCon = $hTLD['domcon'][$iDefaultDomConID];
      } else {
        $hDomCon = array(
          'piid' => null,
          'price_net' => null,
          'price_long' => null,
          'int_price_net' => null,
          'int_price_long' => null,
        );
      }

      // Preissumme der beinhalteten Produkte auslesen
      $hContained = array(
        'sum_net'  => 0,
        'sum_long' => 0,
      );
      if ( $ahContainedProducts && !is_null($hTLD['product']['contained']) ) {
        foreach( $hTLD['product']['contained'] as $peid => $amount ) {
          if ( array_key_exists($peid, $ahContainedProducts) ) {
            $hProduct = $ahContainedProducts[$peid];
            if ( $hProduct['norm'] == 'normaly' && !$hProduct['periodical'] ) {
              $hContained['sum_net'] += ($hProduct['shop_price']['price_net'] * $amount);
              $hContained['sum_long'] += ($hProduct['shop_price']['price_long'] * $amount);
            }
          }
        }
      }

      // Hash für Rückgabe aufbereiten
      $hEntries[$hTLD['ptid']] = array(
        'ptid'  => $hTLD['ptid'],     // ID der TLD
        'name'  => $hTLD['name'],
        'descr' => $hTLD['product']['name']['de'],
        'ptgid' => $hTLD['ptgid'],    // ID der TLD-Gruppe
        'piid'  => $hDomCon['piid'],  // Abrechnungsintervall
        'setup' => $hContained,
        'shop_price' => array(
          'price_net'  => $hDomCon['price_net'],
          'price_long' => $hDomCon['price_long'],
        ),
        'int_shop_price' => array(
          'price_net'  => $hDomCon['int_price_net'],
          'price_long' => $hDomCon['int_price_long'],
        ),
      );
    }

    return $hEntries;
  }


  /**
   * Daten mit TLDs und deren Gruppen aufbereiten
   *
   * @param array $hParams      Zusätzliche Paramter für getDefaultTLDPrices
   * @return array              Einträge und Gruppen
   */
  public static function getTLDHash($hParams=array()) {
    // Soll das Abrechnungsintervall zurückgegeben werden?
    $bRetInterval = false;
    if ( $hParams['return_interval'] ) {
      $bRetInterval = true;
      // Shop-Parameter "return_interval" nicht an das RP weitergeben
      unset($hParams['return_interval']);
    }

    // Daten zu den TLDs auslesen
    $ahTLDGroups = static::readTldGroup(array(
      'return_array' => 1,  // Immer als Array formatieren
    ));
    $ahTLDs = static::getDefaultTLDPrices($hParams);

    $ret = array(
      'entries' => $ahTLDs,
      'groups'  => array(),
    );

    // Interval der ersten TLD zurückgeben
    if ( $bRetInterval && $ahTLDs && count($ahTLDs) ) {
      foreach ( $ahTLDs as $hTLD ) {
        $ret['interval_piid'] = $hTLD['piid'];
        break;
      }
    }

    // Hash mit den Gruppendaten aufbereiten
    if ( $ahTLDGroups && count($ahTLDGroups) ) {
      foreach ( $ahTLDGroups as $hTLDGroup ) {
        // TLDs der Gruppe zusammenfassen
        $aiPTIDs = array();
        foreach ( $ahTLDs as $hTLD ) {
          if ( $hTLD['ptgid'] == $hTLDGroup['ptgid'] ) {
            $aiPTIDs[] = $hTLD['ptid'];
          }
        }

        $ret['groups'][] = array(
          'ptgid'   => $hTLDGroup['ptgid'],
          'name'    => $hTLDGroup['name'],
          'preset'  => $hTLDGroup['preset'],
          'entries' => $aiPTIDs,
        );
      }
    }

    return $ret;
  }

}

