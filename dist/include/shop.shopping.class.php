<?php

class shopShopping extends rpShopping {

  public static function getAddons($hParams=array()) {
    $ahAddons = shopShopping::readStore(array(
      'norm' => 'add-on',
      'check_orderable' => 1,
      'return_array' => 1,
      'return_detail_limits' => 1,
      'return_shop_price' => 1,
    ));

    $iAllOrderableCount = 0;
    if ( $ahAddons ) {

      foreach ( $ahAddons as &$hGroup ) {
        $iGroupOrderableCount = 0;

        foreach ( $hGroup['entrys'] as $hEntry ) {
          if ( $hEntry['orderable']['amount'] != 0 ) {
            $iGroupOrderableCount++;
          }
        }

        $hGroup['orderable_entrys'] = $iGroupOrderableCount;
        $iAllOrderableCount += $iGroupOrderableCount;
      }
      unset($hGroup);
    }

    return array(
      'groups' => $ahAddons,
      'orderable_count' => $iAllOrderableCount,
    );
  }


  public static function getCartData($hParams=array()){
    // Warenkorbstatus aus dem RP abfragen
    $cart = shopShopping::readCart(array(
      'sid' => bbRpc::getSid(),
      'return_items' => 1,
      'return_orderable' => 1,
    ));

    $haItems = array(
      'tariff'  => array(),
      'domain'  => array(),
      'add-on'  => array(),
      'normaly' => array(),
    );
    $aiItemCount = array(
      'all' => 0,
      'tariff'  => 0,
      'domain'  => 0,
      'add-on'  => 0,
      'normaly' => 0,
    );
    $bTariffNeedsDomain = false;

    // Artikel im Warenkorb vorhanden
    if ( $cart ) {
      // Gruppierung nach Produkttyp
      foreach ( $haItems as $sNorm => &$aItems ) {
        foreach ( $cart['items'] as $hItem ) {
          if ( $hItem['product']['norm'] === $sNorm ) {
            $aItems[] = $hItem;
            if ( array_key_exists('amount', $hItem) ) {
              $aiItemCount[$sNorm] += $hItem['amount'];
            } else {
              $aiItemCount[$sNorm]++;
            }

          }
        }
        $aiItemCount['all'] += $aiItemCount[$sNorm];
      }
      $bTariffNeedsDomain = $aiItemCount['tariff'] && !$aiItemCount['domain'] && $haItems['tariff'][0]['product']['need_domain'];
    } else {

      $cart = array();
    }
    // Cart um formatierte Daten erweitern
    $cart['items'] = $haItems;
    $cart['item_count'] = $aiItemCount;
    $cart['tariff_needs_domain'] = $bTariffNeedsDomain;
    return $cart;
  }

}

