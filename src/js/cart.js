(function(window, document, shop, $, undefined){
  "use strict";

  shop.cart = {
    isOrderPage: 0
  };

  var css = {
    countElement: 'site-nav-cart-itemcount',
    countFx: 'item-cart-updated',
    countLoading: 'item-count-loading',
    cartOverview: 'cart-overview-articles',
    inCart: 'in-cart',
    item: 'cart-item',
    loading: 'cart-item-updating',
    productInCart: 'product-in-cart',
    unorderable: 'button-disabled',
    productUnorderable: 'product-unorderable',
    addElement: 'add-to-cart',
    removeElement: 'remove-from-cart',
    wrapperElement: 'site-cart-wrapper'
  };


  /**
   * Events setzen
   *
   * Diese Methode wird bei der Initialisierung der Seite ausgefuehrt.
   */
  shop.cart.setEventListener = function cartSetEventListener() {
    var $delegate = $(document);
    var clickEvent = 'click.shop';

    // Produkt in den Warenkorb hinzufuegen
    $delegate.on(clickEvent, '.add-to-cart', function addProductToCartEvent(event){
      event.preventDefault();
      var $this = $(this);
      var $wrapper = $this.closest('.' + css.item);
      if ( !$wrapper.hasClass(css.loading) ) {
        $wrapper.addClass(css.loading);
        if ( !$this.hasClass(css.unorderable) ) {
          shop.cart.addProduct($this.data('peid'));
        }
      }
    });

    // Produkt aus dem Warenkorb entfernen
    $delegate.on(clickEvent, '.remove-from-cart', function removeProductFromCartEvent(event){
      event.preventDefault();
      var $this = $(this);
      var $wrapper = $this.closest('.' + css.item);
      if ( !$wrapper.hasClass(css.loading) ) {
        var data = $this.closest('[data-scid]').data();
        $wrapper.addClass(css.loading);
        $('[data-scid="'+data.scid+'"]').addClass(css.loading);
        if ( !$this.hasClass(css.unorderable) ) {
          shop.cart.remove(data.product);
        }
      }
    });

    // Anzahl der Produkte aktualisieren
    $delegate.on('input.shop', '.cart-addon-count', function updateProductAmountEvent(){
      var $this = $(this);
      var productElement = $this.closest('[data-product]').data('product');
      shop.cart.changeProductAmount(productElement.scid, $this.val());
    });

    // Tarifwechsel bestaetigen
    $delegate.on(clickEvent, '.tariff-sign', function confirmTariffChangeEvent(event){
      event.preventDefault();
      shop.cart.confirmTariffChange($(this).data('peid'));
    });

    // Chaining ermoeglichen
    return shop.cart;
  };


  //////////////////// CART //////////////////////


  var $itemCount;


  /**
   * Status des Warenkorbs aktualisieren
   *
   * @return {$.Deferred}
   */
  shop.cart.update = function updateCart() {
    var rpcData = {
      'class': 'modIndex',
      method: 'getCart',
      data: {
        'return_norms': shop.cart.getCurrentProductTypes(),
        'return_shop_cart_order': shop.cart.isOrderPage
      }
    };

    var updateForced = arguments[0] || false;

    // Ladeanimation starten
    $itemCount.
      addClass(css.countLoading);

    return shop.rpc.render('.'+css.wrapperElement, rpcData).
      then(function updateItemsWithForceData(result) {
        return shop.cart.updateItems(result, updateForced);
      });
  };


  shop.cart.updateItems = function updateItems(result, forced) {
    // Ladeanimation beenden
    $itemCount.
      removeClass(css.countLoading);

    // Abbruch bei ungueltigen Daten
    if ( !result || !result.data || !result.data.assigns ) {
      return result;
    }

    // Anzahl in der Navigation aktualisieren
    var cartNr = result.data.assigns.count.all > 99 ? "99+" : result.data.assigns.count.all;
    $itemCount.find('SPAN').html( cartNr );
    if ( !forced ) {
      $itemCount.addClass(css.countFx);

      // Animation nach x Sekunden deaktivieren
      setTimeout(function removeCountChangedFx(){
        $itemCount.removeClass(css.countFx);
      }, 4000);
    }

    // Asynchron alle Elemente aktualisieren
    setTimeout(function updateAllItemsWithCurrentResult(){
      shop.cart.updateAllItems(result.data.assigns);
    }, 0);

    // Übersicht in Bestellung aktualisieren
    if ( result.data.assigns.hasOwnProperty('overview') ) {
      shop.ui.inject('.'+css.cartOverview, result.data.assigns.overview);
    }

    return result;
  };


  /**
   * Inhalt des Elements zuruecksetzen
   *
   * @function resetProductLabel
   * @private {Function}
   * @see {@link shop.cart.updateAllItems}
   */
  var resetProductLabel = function cartResetProductLabel(){
    var $this = $(this);
    var itemData = $this.data();

    if ( itemData && itemData.labelOrderable ) {
      $this.html(itemData.labelOrderable);
    }
  };


  /**
   * Produkte aktualisieren
   *
   * @function shop.cart.updateAllItems
   * @param {Object} assigns - Metadaten der updateCart-Abfrage
   */
  shop.cart.updateAllItems = function updateAllItems(assigns) {
    var groupId = '';

    // Produkte des Warenkorbs
    var allCartItemGroups = assigns.items;
    var cartItemGroup = {};
    var cartItemId = '';
    var cartItem = {};
    var cartItemData = {};
    var cartItemProductGroupId = '';
    var normItemGroup = {};
    var normItemId = '';
    var normItem = {};
    var normGroup = {};
    var $cartProduct = {};
    var $cartWrapper = {};

    // Sind keine Daten zu den Gruppen vorhanden, dann gibts nichts zu aktualisieren
    if ( !assigns.norms || !assigns.items ) {
      return;
    }

    // Schnellzugriff auf die einzelnen Produktgruppen erstellen
    var currentNormItemGroups = assigns.norms;
    var normGroups = {};
    for ( groupId in currentNormItemGroups ) {
      if ( !currentNormItemGroups.hasOwnProperty(groupId) ) { continue; }
      normItemGroup = currentNormItemGroups[groupId];
      normGroups[ normItemGroup.pgid ] = normItemGroup.entrys;
    }


    // Alle Produkte der Seite auslesen
    var $allProducts = $('.'+css.addElement).filter('BUTTON');
    var $allDomains = $('[data-domain]');

    // Zustand aller Domains zuruecksetzen
    $allProducts.
      removeClass(css.inCart).
      removeClass(css.loading).
      removeClass(css.unorderable).
      prop('disabled', false).
      each(resetProductLabel).
      closest('.product').
        removeClass(css.productInCart).
        removeClass(css.productUnorderable);

    $allDomains.
      removeClass(css.loading).
      removeClass(css.productInCart);


    // Cart-ID dem aktuellen Produkt hinzufuegen
    if ( assigns.scid ) {
      $allProducts.filter('[data-peid="' + assigns.peid + '"]').data('scid', assigns.scid);
    }

    // Produkttypen des Warenkorbs durchlaufen
    for ( groupId in allCartItemGroups ) {
      if ( !allCartItemGroups.hasOwnProperty(groupId) ) { continue; }
      cartItemGroup = allCartItemGroups[groupId];

      // Produkte des Warenkorbs durchlaufen
      for ( cartItemId in cartItemGroup ) {
        if ( !cartItemGroup.hasOwnProperty(cartItemId) ) { continue; }
        cartItem = cartItemGroup[cartItemId];
        cartItemProductGroupId = cartItem.product.pgid;

        // Ist das Produkt eine Domain?
        if ( cartItem.norm === 'domain' ) {
          // Domain-Element um Shopping-Cart-ID anreichern
          if ( cartItem.attribute && cartItem.attribute.hasOwnProperty('name') ) {
            $allDomains.filter('[data-domain="'+ cartItem.attribute.name + '"]').
              addClass(css.productInCart).
              data('scid', cartItem.scid);
          }

        // Keine Domain -> Nach Norms durchsuchen
        } else if ( !normGroups.hasOwnProperty(cartItemProductGroupId) ||
             !normGroups[cartItemProductGroupId].length ) { continue; }
        normGroup = normGroups[cartItemProductGroupId];

        // Produkt in der Liste der Produkte des aktuellen Produkttypen suchen
        for ( normItemId in normGroup ) {
          if ( !normGroup.hasOwnProperty(normItemId) ) { continue; }
          normItem = normGroup[normItemId];
          if ( normItem.peid != cartItem.peid ) { continue; }

          // Element des Produkts und dessen Metadaten auslesen
          $cartProduct = $allProducts.filter('[data-peid="' + cartItem.peid + '"]');
          $cartWrapper = $cartProduct.closest('.product');
          cartItemData = $cartProduct.data() || {};

          if ( cartItemData.labelInCart ) {
            if ( cartItem.amount != 1 ) {
              $cartProduct.html(cartItem.amount + ' ' + cartItemData.labelInCart);
            } else {
              $cartProduct.html(cartItemData.labelInCart);
            }
          }

          // Ist das Produkt ein Tarif?
          if ( normItem.norm === 'tariff' ) {
            // Hinzufügen des Produkts unterbinden
            $cartProduct.
              addClass(css.inCart).
              addClass(css.unorderable).
              prop('disabled', true);
            $cartWrapper.
              addClass(css.productInCart).
              addClass(css.productUnorderable);

          // Kein Tarif - Darf das Produkt nicht mehr bestellt werden?
          } else if ( normItem.hasOwnProperty('orderable') && !normItem.orderable.amount ) {
            // Hinzufügen des Produkts unterbinden
            $cartProduct.
              prop('disabled', true).
              attr('title', normItem.orderable.msg).
              addClass(css.unorderable);
            $cartWrapper.addClass(css.productUnorderable);

            // Produkt als "nicht bestellbar" markieren
            if ( !cartItemData.labelInCart && cartItemData.labelInCart ) {
              $cartProduct.html(cartItemData.labelInCart);
            }

          } else {
            // Produkt als "im Warenkorb" markieren
            $cartProduct.
              addClass(css.inCart);
            $cartWrapper.
              addClass(css.productInCart);
          }

        } // Produkt in Typliste suchen
      } // Produkte des Warenkorbs
    } // Produkttypen des Warenkorbs

  };


  /**
   * Darstellen der Aenderungen am Warenkorb
   *
   * @param {object} result - Ergebnis des RPC
   */
  shop.cart.renderChangeResult = function cartRenderChangeResult(result) {
    if ( result && result.data && result.data.assigns ) {
      var assigns = result.data.assigns;
      // Dialog fuer Tarifwechsel darstellen
      if ( assigns.hasOwnProperty('action') && assigns.action === 'show_dialog' ) {
        shop.ui.showDialog(result.data.template);
      } else {
        var target = '.' + css.wrapperElement;

        // Wird das fokussierte Element beim Ueberschreiben geloescht?
        var focussedProductId;
        var focussedShoppingCartId;
        var $focussed = $(':focus');
        var $elementToFocus = {};
        if ( $focussed.closest(target).length ) {
          focussedProductId = $focussed.closest('[data-peid]').data('peid');
          focussedShoppingCartId = $focussed.closest('[data-scid]').data('scid');
        }

        // Zusaetzliche Dialoge anzeigen und trotzdem den Warenkorb aktualisieren
        if ( assigns.hasOwnProperty('action') && assigns.action === 'add_dialog' ) {
          shop.ui.showDialog(assigns.dialog);
        }

        shop.rpc.injectRenderedResult(target, result);
        shop.cart.updateItems(result);

        if ( focussedShoppingCartId ) {
          $elementToFocus = $(target).find('[data-scid="'+focussedShoppingCartId+'"]');
          if ( $elementToFocus.find('INPUT').length ) {
            $elementToFocus = $elementToFocus.find('INPUT');
          }
        } else if ( focussedProductId ) {
          $elementToFocus = $(target).find('[data-peid="'+focussedProductId+'"]');
          if ( $elementToFocus.find('INPUT').length ) {
            $elementToFocus = $elementToFocus.find('INPUT');
          }
        }
        if ( $elementToFocus instanceof $ ) {
          $elementToFocus.removeClass(css.loading).trigger('focus');
        }
      }
    }
    return result;
  };


  //////////////////// CHANGE AMOUNT //////////////////////


  shop.cart.changeProductAmount = function cartChangeProductAmount(scid, newAmount) {
    var data = {
      scid: scid,
      amount: newAmount,
      return_norms: shop.cart.getCurrentProductTypes(),
      return_shop_cart_order: shop.cart.isOrderPage
    };

    return shop.rpc.post('modIndex','changeAmount', data).
            then(shop.cart.renderChangeResult);
  };



  //////////////////// ADD //////////////////////


  /**
   * Produkt in den Warenkorb legen
   *
   * @see {@link shop.cart.add}
   * @param {int} peid - Produkt-ID
   * @return {$.Deferred} - Promise mit dem Ergebnis des RPC
   */
  shop.cart.addProduct = function cartAddProduct(peid) {
    return shop.cart.add({
      peid: peid
    });
  };


  /**
   * Tarifwechsel bestaetigen
   *
   * @see {@link shop.cart.add}
   * @param {int} peid - Produkt-ID
   * @return {$.Deferred} - Promise mit dem Ergebnis des RPC
   */
  shop.cart.confirmTariffChange = function cartConfirmTariffChange(peid) {
    return shop.cart.add({
      peid: peid,
      signed: true
    });
  };


  /**
   * Element in den Warenkorb legen
   *
   * @param {object} data - Parameter fuer RPC
   * @return {$.Deferred} - Promise mit den Ergebnissen der Abfrage
   */
  shop.cart.add = function cartAdd(data) {
    if ( !data || !data.peid ) {
      var errorPromise = $.Deferred();
      errorPromise.reject("Es wird die Produkt-ID benoetigt, um ein Produkt in den Warenkorb zu legen");
      return errorPromise;
    }

    // Die Daten welcher Produkttypen sollen mitgeliefert werden?
    data.return_norms = shop.cart.getCurrentProductTypes();
    data.return_shop_cart_order = shop.cart.isOrderPage;

    return shop.rpc.post('modIndex','addToCart', data).
            then(shop.cart.renderChangeResult);
  };


  //////////////////// REMOVE //////////////////////


  /**
   * Produkt aus dem Warenkorb entfernen
   *
   * @see {@link shop.cart.remove}
   * @param {int} scid - Shopping-Cart-ID des zu entfernenden Produkts
   * @return {$.Deferred} - Promise mit den Ergebnis des RPC
   */
  shop.cart.removeProduct = function cartRemove(scid) {
    return shop.cart.remove({
      scid: scid
    });
  };


  /**
   * Element aus dem Warenkorb entfernen
   *
   * @param {object} data - Parameter fuer RPC
   * @return {$.Deferred} - Promise mit den Ergebnissen der Abfrage
   */
  shop.cart.remove = function cartRemove(data) {
    if ( !data || !data.scid ) {
      var errorPromise = $.Deferred();
      errorPromise.reject("Es wird die Shopping-Cart-ID benoetigt, um ein Produkt aus dem Warenkorb zu entfernen");
      return errorPromise;
    }

    // Anzahl des Produkts zuruecksetzen
    data.amount = 0;

    // Die Daten welcher Produkttypen sollen mitgeliefert werden?
    data.return_norms = shop.cart.getCurrentProductTypes();
    data.return_shop_cart_order = shop.cart.isOrderPage;

    var removePromise = shop.rpc.post('modIndex', 'changeAmount', data).
            then(function removeLoadingFromSameElement(result) {
              $('[data-scid="'+data.scid+'"]').removeClass(css.loading);
              return result;
            }).
            then(shop.cart.renderChangeResult);

    // Daten des WHOIS aktualisieren
    if ( data.norm === "domain" && shop.whois.isVisible() ) {
      removePromise.then(function cartUpdateWhoisAfterRemove() {
        shop.whois.requestSingleDomain(data.name);
      });
    }

    return removePromise;
  };


  //////////////////// PRODUCT TYPES //////////////////////


  /**
   * Cache der Liste aller Produkttypen auf der aktuellen Seiten
   * @private {Array<String>}
   */
  var productTypes = [];

  /**
   * Liste der verfuegbaren Produkttypen
   * @private {Object<String, String>}
   */
  var availableProductTypes = {
    addon   : 'add-on',
    article : 'normaly',
    domain  : 'domain',
    tariff  : 'tariff'
  };


  /**
   * Auf der aktuellen Seite suchen, welche Produkttypen angeboten werden
   *
   * @return {Array<String>} Liste der Produkttypen der aktuellen Seite
   */
  shop.cart.getCurrentProductTypes = function cartGetCurrentProductTypes() {
    if ( !productTypes.length ) {
      for ( var type in availableProductTypes ) {
        if ( !availableProductTypes.hasOwnProperty(type) ) {
          continue;
        }
        if ( $('.product-type-' + type).length ) {
          productTypes.push( availableProductTypes[type] );
        }
      }
    }
    return productTypes;
  };


  //////////////////// INIT //////////////////////


  /**
   * Modul initialisieren
   */
  shop.cart.init = function cartInit() {
    $itemCount = $('.' + css.countElement);

    // Befindet sich der Benutzer gerade auf der Shop-Übersicht?
    shop.cart.isOrderPage = $('html').hasClass('shop-order') ? 1 : 0;

    shop.cart.setEventListener();
    shop.cart.getCurrentProductTypes();
    shop.cart.update(true);
  };

  $(document).on('ready', shop.cart.init);

}(this, this.document, this.shop, this.jQuery));

