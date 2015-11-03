(function(window, document, shop, $, undefined){
  "use strict";

  shop.whois = {
    requestedDomains: [],

    // Maximale Anzahl gleichzeitiger Anfragen
    maxRequestCount: 10,

    // Wurden Bereits abfragen durchgeführt?
    isFirstRequest: true
  };

  // Trennzeichen fuer Whois-Begriffe
  var whoisLineSplitRegExp = /\n/g;
  var whoisTermSplitRegExp = /[\s\n:;,\/]/g;

  // Cache der Vorlagen
  var itemTemplates = {};

  // Nach welchen Domains wurde bereits gesucht?
  var duplicateSearches = {};

  // Standardmaße für das Eingabefeld, damit die mehrzeilige Darstellung optimal bleibt.
  // Bei neueren Browsern wird versucht, diese Werte via getComputedStyle zu ermitteln.
  var inputPadding = 1.5;
  var inputLineHeight = 1.5;

  // Klassennamen
  var cssPrefix = 'domainsearch';
  var css = {
    wrapper           : cssPrefix,
    form              : cssPrefix+'-form',
    formSearching     : cssPrefix+'-form-searching',
    submit            : cssPrefix+'-submit',
    input             : cssPrefix+'-input',
    results           : cssPrefix+'-results',
    resultList        : cssPrefix+'-results-list',
    result            : cssPrefix+'-result',
    authCode          : cssPrefix+'-authcode',
    authCodeMsg       : cssPrefix+'-authcode-msg',
    loading           : cssPrefix+'-loading',
    cartLoading       : 'cart-loading',
    unavailableResult : cssPrefix+'-result-unavailable',
    topTlds           : cssPrefix+'-results-additional',
    topTldWrapper     : cssPrefix+'-results-additional-wrapper',
    transferResult    : cssPrefix+'-result-transfer',
    transferActive    : cssPrefix+'-transfer-active',
    transferAbort     : cssPrefix+'-transfer-abort',
    transferConfirm   : cssPrefix+'-transfer-confirm',
    templateLoading   : cssPrefix+'-template-loading',
    templateError     : cssPrefix+'-template-error',
    tariffFooter      : 'domain-price-tariff-notice'
  };


  /**
   * Events setzen
   *
   * Diese Methode wird bei der Initialisierung der Seite ausgeführt.
   */
  shop.whois.setEventListener = function whoisSetEventListener() {
    var $delegate = $(document);
    var clickEvent = 'click.shop';

    // Absenden des Suchformulars
    $delegate.on(clickEvent, '.'+css.submit, function whoisOnSubmitClick(event){
      event.preventDefault();

      var $formWrapper = $(this).closest('.' + css.wrapper);
      var requestedDomains = $formWrapper.find('.' + css.input).val();

      // Keine TLD bei Suche angegeben -> nach Standard-TLDs suchen
      if ( requestedDomains.indexOf('.') === -1 ) {
        shop.whois.searchForAdditional($formWrapper, $formWrapper.find('.' + css.form).data('tlds'));

      // Nach angegebener Domain suchen
      } else {
        shop.whois.request(requestedDomains, $formWrapper);
      }
    });


    // Klick auf einzelne Domain
    $delegate.on(clickEvent, '.'+css.result+', .'+css.result+' LABEL', function whoisAddToCartEvent(event) {
      var $this = $(this);
      var $target = $(event.target);

      // Links bleiben wie sie sind
      if ( $target.not('A').length ) {
        event.preventDefault();
      }

      // Ist gerade eine Aktion aktiv, dann erst mal nichts machen
      var $wrapper = $this.closest('.'+css.result);
      if ( $wrapper.hasClass(css.loading) || $wrapper.hasClass(css.cartLoading) ) {
        return;
      }

      if ( $this.hasClass(css.transferResult) || $this.hasClass(css.unavailableResult) ) {
        // Nur öffnen, wenn das Popup geschlossen ist
        if ( !$this.hasClass(css.transferActive) || $target.is('.'+css.transferAbort) ) {
          shop.whois.toggleTransferLayer($this.data());
        }
      } else {
        shop.whois.addDomainToCart($this.data());
      }
    });


    // Bestätigen eines Transfers
    $delegate.on(clickEvent, '.'+css.transferConfirm, function whoisConfirmTransferEvent(event) {
      event.preventDefault();

      var $wrapper = $(this).closest('.' + css.result);
      var domainData = $wrapper.data();

      var $authCode = $wrapper.find('.' + css.authCode);
      if ( $authCode.length ) {
        var $authCodeMsg = $wrapper.find('.'+css.authCodeMsg).prop('hidden', true);
        var authcodeInput = $authCode.val();
        if ( !authcodeInput ) {
          $authCodeMsg.prop('hidden', false);
          return;
        }
        domainData.product.authcode = authcodeInput;
        domainData.product.signed = true;
      }

      shop.whois.toggleTransferLayer(domainData);
      shop.whois.addDomainToCart(domainData);
    });


    // Enter-Taste beim Such-Eingabefeld
    $delegate.on('keydown.shop', '.'+css.input, function whoisSubmitOnEnter(event){
      if ( event && event.keyCode === 13 ) {
        // Shift-Taste -> Weitere Zeile hinzufügen
        if ( event.shiftKey ) {
          resizeFormInput(this, true);

        // Normal gedrückt -> Suchen
        } else {
          event.preventDefault();
          onFormInputChange(this);
        }
      }
    });


    // Verlassen/Fokussieren des Such-Eingabefelds
    $delegate.on('blur.shop focus.shop change.shop', '.'+css.input, function whoisSubmitOnChange(event){
      event.preventDefault();
      resizeFormInput(this);
    });


    // Klick auf einzelne TLD-Highlights
    $delegate.on(clickEvent, '.' + cssPrefix + '-highlights A', function whoisAddHighlightToQuery(event){
      event.preventDefault();
      shop.whois.addTldFromHighlights( $(this) );
    });


    // Suche nach weiteren TLDs
    $delegate.on(clickEvent, '.' + css.topTlds, function whoisSearchForAdditional(event) {
      event.preventDefault();
      var $this = $(this);
      var $formWrapper = $this.closest('.' + css.wrapper);
      shop.whois.searchForAdditional($formWrapper, $this.data('tlds'));
    });
  };


  //////////////////// INPUT //////////////////////


  /**
   * Größe des Eingabefelds nach Absenden des Formulars korrigieren
   *
   * @function onFormInputChange
   * @param {DOMElement} input - Eingabefeld
   */
  var onFormInputChange = function whoisOnFormInputChange(input) {
    var $input = $(input);

    // Leerzeile am Ende entfernen
    var value = $input.val();
    var lastCharacterIndex = value.length - 1;
    if ( value.substr(lastCharacterIndex, 1) === "\n" ) {
      $input.val( $.trim(value.substr(0, lastCharacterIndex)) );

      // Cursor ans Ende setzen
      if ( input.setSelectionRange ) {
        input.setSelectionRange(lastCharacterIndex, lastCharacterIndex);
      }
    }

    // Suchbutton drücken, um Suche zu starten
    $input.
      closest('.'+css.form).
        find('.'+css.submit).
          trigger('click.shop');
  };


  /**
   * Eingabefeld auf die korrekte Höhe aller Zeilen setzen
   *
   * @function resizeFormInput
   * @param {DOMElement} input - Eingabefeld
   * @param {boolean} increase - Muss das Feld vergrößert werden?
   */
  var resizeFormInput = function whoisResizeFormInput(input, increase) {
    var $input = $(input);
    var currentLineLength = $input.val().split(whoisLineSplitRegExp).length;
    if ( increase ) {
      currentLineLength += 1;
    }
    $input.css('height', (((currentLineLength) * inputLineHeight) + inputPadding) + 'em');
  };


  /**
   * Dimensionen des Eingabefelds messen, um die korrekte Höhe der Mehrzeiligkeit zu setzen
   */
  shop.whois.getInputLineHeight = function whoisGetInputLineHeight() {
    var $input = $('.' + css.input);
    if ( getComputedStyle && $input.length ) {
      var style = getComputedStyle( $input.get(0) );
      inputPadding = (parseInt(style.paddingTop, 10) + parseInt(style.paddingBottom, 10)) / 16;
      inputLineHeight = (parseInt(style.height, 10) / 16) - inputPadding;
    }
  };


  //////////////////// CART //////////////////////


  /**
   * Domain in den Warenkorb legen
   *
   * @function shop.whois.addDomainToCart
   * @param {object} data - Daten zum Produkt
   * @return {$.Deferred} - Promise mit dem Ergebnis
   */
  shop.whois.addDomainToCart = function whoisAddDomainToCart(data) {
    var productData = data.product;
    var scid = data.scid;

    // Keine Daten vorhanden -> Trotzdem Promise zurückgeben
    if ( !productData ) {
      var errorPromise = $.Deferred();
      errorPromise.reject('Es sind keine Daten zur Domain vorhanden');
      return errorPromise;
    }
    if ( !productData.scid ) {
      productData.scid = scid;
    }

    // Ladezustände in Whois und Warenkorb setzen
    shop.whois.getElementsFromDomain(data.domain).addClass(css.loading);
    if ( scid ) {
      $('[data-scid="'+scid+'"]').addClass(css.cartLoading);
    }

    return shop.rpc.post('modIndex', 'addDomainToCart', productData).
            then(
              // Domain aktualisieren
              shop.whois.updateDomain,
              function onDomainToCartFail() {
                return shop.whois.onQueryFail(data);
              }
            ).
            then(
              // Warenkorb aktualisieren
              function updateCartAfterAddingDomain(){
                // in Wrapper aufrufen, da shop.cart.update sonst den ersten Parameter verarbeitet
                return shop.cart.update();
              },
              shop.rpc.renderMessagesFromRpcResult
            );
  };


  /**
   * Fehler bei Whois-Abfrage verarbeiten
   *
   * @function shop.whois.onQueryFail
   * @param {Object} domainData - Daten zur Identifikation der Domain
   * @return {Object} - Daten zur Identifikation der Domain
   */
  shop.whois.onQueryFail = function whoisOnQueryFail(domainData) {
    shop.whois.getElementsFromDomain(domainData.domain).removeClass(css.loading);
    if ( domainData.scid ) {
      $('[data-scid="'+domainData.scid+'"]').removeClass(css.cartLoading);
    }
    return domainData;
  };


  /**
   * Transfer-Dialog auf- und zuklappen
   *
   * @function shop.whois.toggleTransferLayer
   * @param {Object} data - Daten zur Identifikation der Domain
   */
  shop.whois.toggleTransferLayer = function whoisToggleTransferLayer(data) {
    var $domains = shop.whois.getElementsFromDomain(data.domain);
    $domains.toggleClass(css.transferActive);

    // Fokus auf ersten Abbrechen-Button legen
    $domains.find('.'+css.transferAbort).trigger('focus');
  };


  //////////////////// ADDITIONAL //////////////////////


  /**
   * WHOIS für günstigste TLD abfragen
   *
   * @function shop.whois.addTldFromHighlights
   * @param {$} $domain - Angeklickte Domain
   */
  shop.whois.addTldFromHighlights = function whoisAddTldFromHighlights($domain) {
    var tldToAdd = $domain.find('[property="name"]').html();
    if ( tldToAdd.substr(0, 1) !== '.' ) {
      tldToAdd = '.' + tldToAdd;
    }

    var currentWhoisQueries = shop.whois.getCurrentSearchTerms();
    var queryTerm = '';
    for ( var i in currentWhoisQueries ) {
      if ( !currentWhoisQueries.hasOwnProperty(i) ) { continue; }
      queryTerm = shop.whois.getHostname(currentWhoisQueries[i]);

      if ( !queryTerm ) {
        continue;
      }

      // Kein . im Query? -> TLD hinzufuegen
      if ( queryTerm.lastIndexOf('.') === -1 ) {
        shop.whois.requestSingleDomain(queryTerm + tldToAdd);
      }
    }
  };


  /**
   * Nach zusätzlichen TLDs suchen
   *
   * @function shop.whois.searchForAdditional
   * @param {$} $formWrapper - Hauptelement des aktuellen Formulars
   * @param {Array} tlds - Abzufragende TLDs
   */
  shop.whois.searchForAdditional = function whoisSearchForAdditional($formWrapper, tlds) {
    var requestedDomains = [];
    var requestedDomain = '';
    var currentHostname = '';

    // Unterschiedliche Domains im Eingabefeld suchen
    var currentWhoisQueries = shop.whois.getCurrentSearchTerms();
    var currentQueryCount = currentWhoisQueries.length;

    var iTld = 0;
    var iTldCount = 0;
    if ( tlds instanceof Array ) {
      iTldCount = tlds.length;
    }

    // Keine TLDs vorhanden oder Domains eingegeben? Dann abbrechen.
    if ( !currentQueryCount || !iTldCount ) {
      return false;
    }

    for ( var iDomain=0; iDomain < currentQueryCount; iDomain++ ) {
      currentHostname = shop.whois.getHostname(currentWhoisQueries[iDomain]);

      requestedDomains = [];

      for ( iTld=0; iTld < iTldCount; iTld++ ) {
        // bestehende TLD vom Suchbegriff entfernen
        requestedDomain = currentHostname + '.' + tlds[iTld];

        // bereits gesuchte TLDs entfernen
        if ( shop.whois.requestedDomains.indexOf(requestedDomain) === -1 ) {
          requestedDomains.push(requestedDomain);
        }
      }

      // Domains in natürlicher Sortierung ausgeben.
      // Achtung: Haben Sie in shop.whois.requestSingleDomain die Sortierung
      // von prepend auf append geändert, so deaktivieren Sie hier den Aufruf
      // von requestedDomains.reverse, da sonst die Sortierung der Domains
      // umgekehrt wird.
      requestedDomains.reverse();

      // Abfrage absenden
      if ( currentQueryCount === 1 ) {
        do {
          shop.whois.request(requestedDomains.splice(0, 10), $formWrapper);
        } while (requestedDomains.length);
      } else {
        shop.whois.request(requestedDomains, $formWrapper);
      }
    }

  };


  //////////////////// REQUEST //////////////////////


  /**
   * Daten der Domain aktualisieren
   *
   * @function shop.whois.updateDomain
   * @param {Object} result - Ergebnisse der Abfrage
   * @return {Object} - Ergebnisse der Abfrage
   */
  shop.whois.updateDomain = function whoisUpdateDomain(result) {
    if ( !result || !result.data || !result.data.assigns ) {
      return result;
    }

    var whoisData = result.data.assigns.whois;
    var $domain = {};
    var isDomainFocussed = false;
    var domainData = {};
    var domainName = '';

    for ( var domainIndex in whoisData ) {
      if ( !whoisData.hasOwnProperty(domainIndex) ) { continue; }
      domainData = whoisData[domainIndex];
      if ( !domainData || !domainData.name ) {
        continue;
      }
      domainName = domainData.name;
      $domain = $('.'+css.result).filter('[data-domain="' + domainName + '"]');
      isDomainFocussed = $domain.find('LABEL').is(':focus');

      // Neue Inhalte rendern
      if ( result.data.template ) {
        $domain.replaceWith(result.data.template);

        // Fokus wieder auf das Element setzen
        if ( isDomainFocussed ) {
          $domain.find('LABEL').trigger('focus');
        }
      }
    }

    updateTariffFooter();

    return result;
  };


  /**
   * WHOIS-Abfrage für eine oder mehrere Domains ausführen
   *
   * @function shop.whois.request
   * @param {Array|String} requestedDomains - Abzufragende Domains
   * @param {$} $formWrapper - Hauptelement des aktuellen Formulars
   */
  shop.whois.request = function whoisRequest(requestedDomains, $formWrapper) {
    if ( !$formWrapper ) {
      $formWrapper = $('.' + css.wrapper);
    }

    if ( requestedDomains instanceof Array ) {
      requestedDomains = requestedDomains.join("\n");
    }

    // Domains in Kleinbuchstaben setzen
    requestedDomains = requestedDomains.toLowerCase();

    // Array aus eingegenen Begriffen erstellen
    requestedDomains = $.trim(requestedDomains).split(whoisTermSplitRegExp);

    // Nur die ersten X Domains auslesen
    if ( requestedDomains.length > shop.whois.maxRequestCount ) {
      shop.ui.renderMessage({
        msg: "Es werden nur die ersten " + shop.whois.maxRequestCount + ' Domains abgefragt. Alle Domains ab "' + requestedDomains[shop.whois.maxRequestCount] + '" wurden ignoriert.',
        type: "warning"
      });
      requestedDomains.splice(shop.whois.maxRequestCount, Number.MAX_VALUE);
    }

    var requestedDomain = '';
    for ( var i in requestedDomains ) {
      if ( !requestedDomains.hasOwnProperty(i) ) { continue; }
      requestedDomain = $.trim(requestedDomains[i]);

      // Ungültige Domain? -> Nicht suchen
      if ( !requestedDomain ) {
        continue;
      }

      // Nach Domain wird zum ersten Mal gesucht
      if ( shop.whois.requestedDomains.indexOf(requestedDomain) === -1 ) {
        shop.whois.requestedDomains.push(requestedDomain);

      // Domain wurde bereits gesucht -> Überspringen
      } else {
        // Fehlermeldung nur einmal pro Domain anzeigen
        if ( !duplicateSearches.hasOwnProperty(requestedDomain) ) {
          duplicateSearches[requestedDomain] = true;
          shop.ui.renderMessage({
            msg: "Sie haben bereits nach "+requestedDomain+" gesucht.",
            type: "notice"
          });
        }
        continue;
      }

      // Abfrage für Domain ausführen
      shop.whois.requestSingleDomain( requestedDomain, $formWrapper );
    }
  };



  /**
   * WHOIS-Abfrage für einzelne Domain durchführen
   *
   * @function shop.whois.requestSingleDomain
   * @param {string} requestedDomain - Abzufragende Domain
   * @param {$} $formWrapper - Hauptelement des aktuellen Formulars
   */
  shop.whois.requestSingleDomain = function requestSingleDomain(requestedDomain, $formWrapper) {
    if ( !$formWrapper ) {
      $formWrapper = $('.' + css.wrapper);
    }
    var $resultWrapper = $formWrapper.find('.' + css.results);
    var $submitButton = $formWrapper.find('.' + css.submit);
    var submitLabels = $submitButton.data();
    var currentLabel = '';

    var rpcData = {
      name: requestedDomain
    };

    // Label des Absende-Buttons vor der Abfrage ändern
    if ( submitLabels.labelActive ) {

      // Aktuellen Zustand zwischenspeichern, wenn nicht vorhanden
      currentLabel = $submitButton.html();
      if ( !submitLabels.labelOriginal && currentLabel !== submitLabels.labelActive ) {
        $submitButton.data('label-original', currentLabel);
        submitLabels.labelOriginal = currentLabel;
      }

      $submitButton.html(submitLabels.labelActive);
      $formWrapper.addClass(css.formSearching);
    }

    // Wrapper einblenden
    if ( shop.whois.isFirstRequest ) {
      $resultWrapper.
        removeAttr('hidden').
        prop('hidden', false);
      shop.whois.isFirstRequest = false;
    }

    // Ergebnisse zu den bestehenden Domains hinzufügen
    // Achtung: Ändern Sie die Reihenfolge (z.B. prepend->append), so beachten
    // Sie auch in der domainsearch.scss die abwechselnden Hintergrundfarben.
    // Suchen Sie am Besten im dortigen Quelltext nach nth-of-type.
    // Bearbeiten Sie außerdem den Aufruf von requestedDomains.reverse() in
    // der Methode shop.whois.searchForAdditional
    var $existingElement = $resultWrapper.find('[data-domain="'+requestedDomain+'"]');
    if ( $existingElement.length ) {
      $existingElement.addClass(css.loading);
    } else {
      var loadingTemplate = fillDomainTemplate(requestedDomain, itemTemplates.loading);
      $resultWrapper.find('.' + css.resultList).prepend(loadingTemplate);
    }


    // Die folgenden Methoden sind inline angegeben, um die bestehenden Variablen
    // wiederzuverwenden. Der RPC-Aufruf findet am Ende dieser Methode statt.


    var resetSearchButton = function whoisResetSearch() {
      // Absende-Button wieder zuruecksetzen
      $formWrapper.removeClass(css.formSearching);
      $submitButton.html(submitLabels.labelOriginal);
    };

    /**
     * WHOIS-Ergebnisse rendern
     *
     * @param {Object} result - Ergebnisse der Abfrage
     * @result {Object} - Ergebnisse der Abfrage
     */
    var renderWhoisResults = function renderWhoisResults(result){
      resetSearchButton();

      // Gültigkeitsprüfung
      if ( !result || !result.data || !result.data.assigns ) {
        shop.ui.renderMessage({
          type: "error",
          msg: "Ung&uuml;ltige Whois-Ergebnisse erhalten"
        });
        return result;
      }

      // Daten einfügen
      var template = '';
      if ( result.data.template ) {
        template = result.data.template;
      } else {
        template = fillDomainTemplate(requestedDomain, itemTemplates.error);
      }
      $resultWrapper.
        find('[data-domain="'+requestedDomain+'"]').
          replaceWith(template);

      if ( result.data.assigns.whois && result.data.assigns.whois[0].scid ) {
        $('[data-scid="'+result.data.assigns.whois[0].scid+'"]').removeClass(css.cartLoading);
      }

      setTimeout(updateTariffFooter, 0);

      return result;
    };

    // Fehler des WHOIS anzeigen
    var renderWhoisError = function renderWhoisError(){
      resetSearchButton();

      // Domainnamen in Platzhaltern einfügen
      $resultWrapper.
        find('[data-domain="' + requestedDomain + '"]').
          replaceWith(
            itemTemplates.error.replace('{domain.name}', requestedDomain)
          );

      // Domain als "noch nicht gesucht" markieren, damit sie bei Fehlern
      // evtl. erneut gesucht werden kann (z.B. wegen temporärer Probleme)
      var requestedDomainPosition = shop.whois.requestedDomains.indexOf(requestedDomain);
      if ( requestedDomainPosition !== -1 ) {
        shop.whois.requestedDomains.splice(requestedDomainPosition, 1);
      }
    };


    // Abfrage absenden
    return shop.rpc.post('modIndex', 'checkDomain', rpcData).
            then(
              renderWhoisResults,
              renderWhoisError
            );
  };


  //////////////////// HELFER //////////////////////


  /**
   * Sternchentext bei unbestelltem Tarif ein-/ausblenden
   *
   * @function updateTariffFooter
   */
  var updateTariffFooter = function whoisUpdateTariffFooter() {
    var areAllPricesOriginal = true;

    var $domains = $('[data-domain]');
    $domains.each(function isOriginalPriceMissing(){
      var domainData = $(this).data();
      if ( domainData.product && (domainData.product.price_missing || domainData.product.price_default) ) {
        areAllPricesOriginal = false;
        // return false bricht die Schleife ab
        return false;
      }
    });

    $('.' + css.tariffFooter).prop('hidden', areAllPricesOriginal);
  };


  /**
   * Alle eingegebenen Suchbegriffe des Suchfelds auslesen
   *
   * @function shop.whois.getCurrentSearchTerms
   * @return {Array} Liste aller Begriffe im Sucheingabefeld
   */
  shop.whois.getCurrentSearchTerms = function whoisGetCurrentSearchTerms() {
    return $.trim( $('.' + css.input).val() ).split(whoisTermSplitRegExp);
  };


  /**
   * Alle bestehenden DOM-Elemente ($) zur gesuchten Domain suchen
   *
   * @function shop.whois.getElementsFromDomain
   * @param {string} domainName - Zu suchende Domain
   * @return {$} Objekt mit allen Elementen der gesuchten Domain
   */
  shop.whois.getElementsFromDomain = function whoisGetElementsFromDomain(domainName) {
    return $('[data-domain="' + domainName + '"]');
  };


  /**
   * Hostname eines Domainnamens extrahieren
   *
   * @function shop.whois.getHostname
   * @param {String} sDomain - Domainname
   * @return {String} - Hostname
   */
  shop.whois.getHostname = function whoisGetHostname(sDomain) {
    var queryTerm = $.trim(sDomain);

    if ( !queryTerm ) {
      return '';
    }

    var lastDotPosition = queryTerm.lastIndexOf('.');
    if ( lastDotPosition === -1 ) {
      return queryTerm;
    }

    return queryTerm.substr(0, lastDotPosition);
  };


  /**
   * Befindet sich bereits ein Whois-Formular auf der Seite?
   *
   * @function shop.whois.isVisible
   * @return {Number} - Anzahl der vorhanden $formWrapper
   */
  shop.whois.isVisible = function whoisIsVisible() {
    return $('.' + css.wrapper).length;
  };


  //////////////////// VORLAGEN //////////////////////


  /**
   * Vorlagen cachen
   *
   * @function shop.whois.cacheItemTemplates
   */
  shop.whois.cacheItemTemplates = function whoisCacheItemTemplates() {
    var $itemTemplate = $('.' + css.wrapper).find('TEMPLATE');
    var selector = '';
    var $template = {};
    var templates = {
      loading: '.' + css.templateLoading,
      error: '.' + css.templateError
    };

    for ( var key in templates ) {
      if ( !templates.hasOwnProperty(key) ) { continue; }
      selector = templates[key];
      $template = $itemTemplate.filter(selector);

      itemTemplates[key] = $.trim($template.html());
    }

    // Alle Elemente aus dem DOM entfernen
    $itemTemplate.remove();
  };


  /**
   * Vorlage einer Whois-Domain ausfüllen
   *
   * @function fillDomainTemplate
   * @param {Object} domain - Daten der Domain
   * @param {String} template - Auszufüllende Vorlage
   * @return {$} - Generiertes Element
   */
  var fillDomainTemplate = function whoisFillDomainTemplate(domain, template) {
    var $element = $(template);
    return $element.
            attr('data-domain', domain).
            find('[property="name"]').
              html(domain).
            end();
  };



  //////////////////// INIT //////////////////////


  /**
   * Modul initialisieren
   */
  shop.whois.init = function whoisInit() {
    shop.whois.setEventListener();
    shop.whois.cacheItemTemplates();

    // Standardmäßig Sternchentext ausblenden
    $('.' + css.tariffFooter).prop('hidden', true);

    // Styledaten auslesen kann UI blocken -> asynchroner Aufruf
    setTimeout(shop.whois.getInputLineHeight, 0);
  };

  $(document).on('ready', shop.whois.init);

}(this, this.document, this.shop, this.jQuery));
