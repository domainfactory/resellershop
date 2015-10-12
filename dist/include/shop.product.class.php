<?php

class shopProduct extends rpProduct {

  public static function makeLimit($hProductLimit, $hLimitSettings, $iKey) {
    // Name des Limits aus products.ini verwenden?
    if ( trim($hLimitSettings['name'][$iKey]) ) {
      $hProductLimit['name'] = $hLimitSettings['name'][$iKey];
    }
    return $hProductLimit;
  }

  public static function readEntry($hParams = array()) {
    $bRetSF    = ($hParams['return_shopformat']) ? 1 : 0;
    $bRetGroup = ($hParams['return_shopformat_grouped']) ? 1 : 0;
    // shopformat-Parameter nicht ans RP senden
    unset($hParams['return_shopformat']);
    unset($hParams['return_shopformat_group']);
    // Anpassungen fuer Shop-Aufruf
    if ($bRetSF || $bRetGroup) {
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
    if ($bRetSF && $data){
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
                'name' => $hLimit['name'],
                'descr' => $hLimit['descr'],
                'unit' => $hLimit['unit'],
                'fld' => $hLimit['fld'],
                'typ' => $hLimit['typ'],
                'val' => 0,
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


  public static function readInterval($hParams=array()){
    $bRetSF = ($hParams['return_shopformat']) ? 1 : 0;
    if ($bRetSF){
      $hParams['return_lang'] = 1;
      $hParams['return_array'] = 1;
    }
    unset($hParams['return_shopformat']);

    $data = parent::readInterval($hParams);
    if ($bRetSF && $data){
      $lang = 'de';
      $tmp = array('descr' => array());
      foreach($data as $item){
        $tmp[$item['piid']] = $item['name'][$lang];
        $tmp['descr'][$item['piid']] = $item['descr'][$lang];
      }
      $data = $tmp;
      $data[0] = 'einmalig';
      $data['descr'][0] = 'einmalig';
    }

    return $data;
  }


  public static function getTLDNamesFromTLDGroup($hParams=array()) {
    // Angegebene TLD-Gruppen-ID verwenden?
    if ( array_key_exists('ptgid', $hParams) ) {
      $iGroupId = $hParams['ptgid'];
    } else {
      $group = parent::readTldGroup(array(
        'preset' => 1,
      ));
      $iGroupId = $group['ptgid'];
    }

    $ahDefaultTLDs = parent::readTldMap(array(
      'ptgid' => $iGroupId,
    ));

    // IDs zusammenfassen
    $aiIDs = array();
    $iTLDCount = count($ahDefaultTLDs);
    for ( $i = 0; $i < $iTLDCount; $i++ ) {
      $aiIDs[] = $ahDefaultTLDs[$i]['ptid'];
    }

    // Namen der TLDs auslesen
    $hTLDData = parent::readTld(array(
      'ptid' => $aiIDs,
      'return_array' => 1,
    ));
    $hData = array();
    $iTLDCount = count($hTLDData);
    for ( $i = 0; $i < $iTLDCount; $i++ ) {
      $hData[] = $hTLDData[$i]['name'];
    }

    return $hData;
  }


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

    $tlds = static::readTld(array_merge(array(
      'active'            => 1,
      'return_domcon'     => 1,
      'return_product'    => 1,
      'return_array'      => 1,
    ), $hParams));
    if ( !$tlds ) {
      return array();
    }

    // Standard-Defaultkontingent auslesen
    $def_domcon = static::readDomCon(array(
      'preset' => 1,
    ));
    $iDefaultDomConId = $def_domcon['pdid'];
    unset($def_domcon);

    foreach($tlds as $key => &$tld){
      // Subdomains ignorieren
      if ( count(explode('.', $tld['name'])) > 1 ) {
        unset($tlds[$key]);
        continue;
      }
      $domcon = $tld['domcon'][$iDefaultDomConId];
      $tld['shop_price'] = $domcon;
    }
    unset($tld);

    $data = array();
    if ( $bReturnAllTlds ) {
      usort($tlds, array('static','orderByName'));
      $data['all'] = $tlds;
    }

    usort($tlds, array('static','getCheaperDomain'));
    $data['highlights'] = array_slice($tlds, 0, $iCountDomains);

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


  public static function getCheapestStorePrice($hParams=array()) {
    $data = shopShopping::readStore(array_merge(array(
      'check_orderable' => 1,
      'return_array' => 1,
      'return_shop_price' => 1,
    ), $hParams));
    $cheapestPrice = null;
    foreach ( $data as $group ) {
      foreach ( $group['entrys'] as $entry ) {
        if ( $cheapestPrice === null || $entry['shop_price']['price_long'] < $cheapestPrice ) {
          $cheapestPrice = $entry['shop_price']['price_long'];

          // Günstiger als kostenlos wirds nicht...
          if ( $cheapestPrice !== null && $cheapestPrice === 0.00 ) {
            return 0.00;
          }
        }
      }
    }
    return $cheapestPrice;
  }
  public static function getDefaultTLDPrices($hParams=array()){
    $def_domcon = static::readDomCon(array(
      'preset' => 1,
    ));
    $iDefaultDomConId = $def_domcon['pdid'];
    unset($def_domcon);

    $tlds = static::readTld(array_merge(array(
      'active'            => 1,
      'return_domcon'     => 1,
      'return_shop_price' => 1,
      'return_product'    => 1,
      'return_product_edit' => 1,
      'return_array'      => 1,
    ), $hParams));

    $entries = array();

    if ( !$tlds ) {
      return $entries;
    }

    foreach($tlds as $tld){
      $domcon = null;
      $domcon = $tld['domcon'][$iDefaultDomConId];
      $contained = array(
        'sum_net'  => 0,
        'sum_long' => 0,
      );
      if (count($tld['product']['contained'])){
        foreach($tld['product']['contained'] as $peid=>$amount){
          $product = parent::readEntry(array(
            'peid'              => $peid,
            'return_shop_price' => 1,
          ));
          if ($product['norm'] == 'normaly' && !$product['periodical']){
            $contained['sum_net'] += ($product['shop_price']['price_net'] * $amount);
            $contained['sum_long'] += ($product['shop_price']['price_long'] * $amount);
          }
        }
      }
      $entries[$tld['ptid']] = array(
        'ptid' => $tld['ptid'],
        'name' => $tld['name'],
        'descr' => $tld['product']['name']['de'],
        'ptgid' => $tld['ptgid'],
        'piid'  => $domcon['piid'],
        'setup' => $contained,
        'shop_price' => array(
          'price_net' => $domcon['price_net'],
          'price_long' => $domcon['price_long'],
        ),
        'int_shop_price' => array(
          'price_net' => $domcon['int_price_net'],
          'price_long' => $domcon['int_price_long'],
        ),
      );
    }
    return $entries;
  }


  public static function getTLDHash($hParams=array()){
    $bRetInterval = false;
    if ( $hParams['return_interval'] ) {
      $bRetInterval = true;
      unset($hParams['return_interval']);
    }

    $groups = static::readTldGroup(array(
      'return_array' => 1,
    ));
    $tlds = static::getDefaultTLDPrices($hParams);

    $ret = array(
      'entries' => $tlds,
      'groups'  => array(),
    );

    if ( $bRetInterval && count($tlds) ) {
      foreach ( $tlds as $tld ) {
        $ret['interval_piid'] = $tld['piid'];
        break;
      }
    }

    if ( $groups && count($groups) ) {
      foreach ($groups as $group) {
        $ptids = array();
        foreach ($tlds as $tld) {
          if ( $tld['ptgid'] == $group['ptgid'] ) {
            $ptids[] = $tld['ptid'];
          }
        }
        $ret['groups'][] = array(
          'ptgid'   => $group['ptgid'],
          'name'    => $group['name'],
          'preset'  => $group['preset'],
          'entries' => $ptids,
        );
      }
    }
    return $ret;
  }

}

