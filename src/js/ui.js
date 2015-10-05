(function(window, document, shop, $, undefined){
  "use strict";

  shop.ui = {
    logMessages: true,  // Fehlermeldungen in der Konsole ausgeben?
    stickyGlobalExtraTop: 0
  };

  var css = {
    notificationWrapper: 'modal-notification-wrapper',
    notificationClose: 'modal-window-close',
    notificationLink: 'notification-field-link'
  };


  /**
   * Events setzen
   *
   * Diese Methode wird bei der Initialisierung der Seite ausgefuehrt.
   */
  shop.ui.setEventListener = function uiSetEventListener() {
    var $delegate = $(document);
    var clickEvent = 'click.shop';

    // Bei Escape-Taste aktiven Dialog schliessen
    $delegate.on('keyup', function closeDialogOnEscape(event){
      if ( event && event.keyCode === 27 && isDialogActive ) {
        event.preventDefault();
        shop.ui.closeDialog();
      }
    });


  // REFERENCES: Scroll-Buttons scrollen lassen
    $delegate.
      on(clickEvent, '.scroll-back', function(e){
        e.preventDefault();
        shop.ui.scroll(this, true);
      }).
      on(clickEvent, '.scroll-forward', function(e){
        e.preventDefault();
        shop.ui.scroll(this, false);
      });

    // Modale Fenster schliessen
    $delegate.on(clickEvent, '.'+css.notificationClose, shop.ui.closeDialog);

    $delegate.on(clickEvent, '.'+css.notificationLink, shop.ui.focusElementFromNotification);

    if ( 'TransitionEvent' in window ) {
      $delegate.on('scroll.shop', shop.ui.updateStickyOnScrollThrottled);
    }
  };


  shop.ui.focusElementFromNotification = function uiFocusElementFromNotification(event) {
    var elementToFocus = $('#' + this.hash.substr(1));
    if ( elementToFocus.length ) {
      if ( event.preventDefault ) {
        event.preventDefault();
      }

      elementToFocus.trigger('focus');
    }
  };


  //////////////////// RENDER //////////////////////


  shop.ui.inject = function uiInject(target, renderedSource) {
    var src = $.trim(renderedSource);
    // TODO: Anstaendige XSS-Prevention!
    src = src.replace(/(iframe)/gi, '');
    if ( src ) {
      $(target).html(src);
    }
  };


  //////////////////// MESSAGES //////////////////////


  var $notificationWrapper = $('.notifications');

  shop.ui.renderMessage = function uiRenderMessage(message) {
    if ( !message ) {
      message = {
        type: "error",
        msg: "Es trat ein unbekanter Fehler auf"
      };
    }

    if ( message.msg ) {
      var notification = $(
        '<div class="notification notification-type-'+message.type+'">' +
          message.msg +
        '</div>'
      ).appendTo($notificationWrapper);

      setTimeout(function removeHiddenNotification(){
        notification.remove();
      }, 12000);
    }
  };


  //////////////////// ERRORS //////////////////////


  shop.ui.showFormErrors = function uiShowFormErrors() {
    $('[data-msg]').each(function uiShowFormErrorForElement() {
      var $input = $(this);
      var $messageElement = $input.next('.form-error-msg');
      var msg = $input.data('msg');
      // Meldung anzeigen
      if ( msg !== '' ) {
        // Meldung existiert bereits
        if ( $messageElement.length ) {
          $messageElement.html(msg);

        // Meldung neu erstellen
        } else {
          $('<span/>', {
            "class": "form-error-msg",
            html: msg
          }).insertAfter($input);
        }
      // Keine Meldung angezeigen, aber bestehende Meldung existiert
      } else if ( $messageElement.length ) {
        $messageElement.remove();
      }
    });
  };


  //////////////////// STICKY //////////////////////


  // Helper: Nicht zu viele Eventcallbacks auf einmal ausfuehren
  // via http://sampsonblog.com/749/simple-throttle-function
  function throttle(callback, limit) {
    var wait = false;
    return function() {
      if (!wait) {
        callback.call();
        wait = true;
        setTimeout(function() {
          wait = false;
        }, limit);
      }
    };
  }


  var stickyElements = [];
  var stickyPositions = {};
  var stickyPreviousScrollPosition = 0;

  var initStickyHeader = function uiInitStickyHeader() {
    var stickyElementIndex = stickyElements.push({
      element: $('body'),
      toggleClass: 'site-header-fixed',
      startPosition: 66,
      top: 0
    });
    stickyPositions[66] = [ stickyElements[stickyElementIndex-1] ];
  };

  var prepareElementToMakeSticky = function uiPrepareElementToMakeSticky() {
    var $this = $(this);

    // Urspruengliche Position im DOM suchen
    var currentPosition = $this.offset().top;

    // Elemente zu Cache hinzufuegen
    var newElementIndex = stickyElements.push({
      element: $this,
      toggleClass: 'is-sticky',
      startPosition: currentPosition,
      top: $this.data('stickyTop') ? $this.data('stickyTop') : 0
    });

    // Moeglichkeit fuer mehrere Elemente an der selben Position schaffen
    if ( !stickyPositions.hasOwnProperty(currentPosition) ) {
      stickyPositions[currentPosition] = [];
    }

    // Referenz bei den einzelnen Positionen merken
    stickyPositions[currentPosition].push(stickyElements[newElementIndex-1]);
  };

  shop.ui.initSticky = function uiInitSticky() {
    $('.make-sticky').each(prepareElementToMakeSticky);
  };

  var $window = $(window);

  shop.ui.updateStickyOnScroll = function uiUpdateStickyOnScroll() {
    var currentScrollPosition = $window.scrollTop() - shop.ui.stickyGlobalExtraTop;

    var stickyElements = [];
    var elementCount = 0;
    var elementToChange = {};
    var i = 0;

    for ( var elementStartPosition in stickyPositions ) {
      if ( !stickyPositions.hasOwnProperty(elementStartPosition) ) { continue; }
      stickyElements = stickyPositions[elementStartPosition];

      elementCount = stickyElements.length;

      for ( i = 0; i < elementCount; i++ ) {
        elementToChange = stickyElements[i];
        // Aktuelle Position war vorher noch nicht erreicht
        //if ( stickyPreviousScrollPosition <= (currentScrollPosition + elementToChange.top) ) {
          // Position wird jetzt ueberschritten
          if ( currentScrollPosition >= (elementStartPosition - elementToChange.top) ) {
            elementToChange.element.toggleClass(elementToChange.toggleClass, true);
          //}
        // Aktuelle Position war bereits ueberschritten
        //} else {
          } else if ( currentScrollPosition <= elementStartPosition ) {
            elementToChange.element.toggleClass(elementToChange.toggleClass, false);
          }
        //}
      }
    }

    // Position fuer naechsten Aufruf cachen
    stickyPreviousScrollPosition = currentScrollPosition;
  };

  shop.ui.updateStickyOnScrollThrottled = function uiUpdateStickyOnScrollThrottled() {
    throttle(setTimeout(shop.ui.updateStickyOnScroll, 0));
  };


  //////////////////// DIALOG //////////////////////


  var lastFocussed = null;
  var isDialogActive = false;

  /**
   * Modalen Dialog erzeugen
   *
   * @param {string} template Quelltext des zu rendernden Templates
   * @return {$} Element des erzeugten Fensters
   */
  shop.ui.showDialog = function uiShowDialog(template) {
    if ( isDialogActive ) {
      // Bestehenden Dialog schliessen, sobald ein neuer Dialog kommt
      shop.ui.closeDialog();
    } else {
      // Speichern, welches Element vor Oeffnen des Dialogs fokussiert ist
      lastFocussed = $(':focus');
    }

    // Element zum DOM hinzufuegen 
    var $dialog = $(template).appendTo('body');
    isDialogActive = true;

    // Erstes Eingabefeld des Dialogs fokussieren
    $dialog.find(':input').
      first().
        trigger('focus');

    return $dialog;
  };


  /**
   * Aktuellen Dialog schliessen
   */
  shop.ui.closeDialog = function uiCloseDialog() {
    if ( !isDialogActive ) {
      return;
    }

    var $dialog = $(this);

    // Wrapper des Dialogs suchen
    var wrapperSelector = '.'+css.notificationWrapper;
    var $dialogWrapper = $dialog.closest(wrapperSelector);
    if ( !$dialogWrapper.length ) {
      $dialogWrapper = $(wrapperSelector);
    }
    $dialog = null;

    // Wrapper aus DOM entfernen
    $dialogWrapper.remove();
    isDialogActive = false;

    // Zuletzt fokussiertes Element der Seite wieder fokussieren
    if ( (lastFocussed instanceof $) && lastFocussed.length ) {
      lastFocussed.trigger('focus');
    }
    lastFocussed = null;
  };


  // HEADER: Fonts asynchron bei guter Verbindung nachladen
  var addStylesheet = function uiAddStylesheet(src){
    var c = document.createElement('link');
    c.rel="stylesheet";
    c.href="css/"+src+".css";
    c.async=true;
    document.getElementsByTagName('head')[0].appendChild(c);
  };


  shop.ui.initFonts = function uiInitFonts() {
    // Aktuelle Verbindungsdetails (neue Browser):
    var conn = window.navigator.connection || window.navigator.mozConnection || window.navigator.webkitConnection;
    var perf = false;
    if ( conn ) {
      // Mindestens 10 Mbit/s werden erwartet.
      if ( conn.downlinkMax >= 10 || ( conn.type != "bluetooth" && conn.type != "none" ) ) {
        addStylesheet('fonts-sources');
      }
    // Geschwindigkeit des Seitenaufbaus
    } else if ( window.performance && window.performance.timing ) {
      perf = window.performance.timing;
      // Ist die Ladegeschwindigkeit aller Resourcen unter 5 Sekunden?
      if ( (perf.responseEnd - perf.requestStart) < 5000 ) {
        addStylesheet('fonts-sources');
      }
    }
  };


  //////////////////// REFERENCES //////////////////////


  // REFERENCES: Scrollen
  shop.ui.scroll = function(button, backward) {
    var $list = $(button).parent().find('.list-scroll');
    var listCurrentPosition = $list.prop('scrollLeft');
    var listOffset = $list.prop('offsetLeft');
    var nextPosition = 0;

    // scrollLeft des folgenden Elements herausfinden
    var isFirstElementInVisibleViewport = function isFirstElementInVisibleViewport(){
      var iScrollLeft = this.offsetLeft;
      if ( nextPosition !== 0 ) {
        nextPosition = iScrollLeft - listOffset;
        return false;
      }
      if (!backward && (iScrollLeft >= listCurrentPosition)) {
        nextPosition = iScrollLeft;
      }
      if (backward && (iScrollLeft <= listCurrentPosition)) {
        nextPosition = iScrollLeft - listOffset;
        return false;
      }
    };

    // Element suchen, das sich aktuell am linken Rand befindet
    var $children = $list.children();
    if (backward) {
      $children = $($children.get().reverse());
    }
    $children.each(isFirstElementInVisibleViewport);
    $list.prop('scrollLeft', nextPosition);
  };


  // REFERENCES: Scroll-Buttons erstellen
  shop.ui.createScrollButtons = function uiCreateScrollButtons(i, wrapper){
    var $rwd = $('<button/>', {
      "class": "scroll-back icon icon-align icon-scroll-left",
      html: "<span>zur&uuml;ck scrollen</span>"
    });
    var $fwd  = $('<button/>', {
      "class": "scroll-forward icon icon-align icon-scroll-right",
      html: "<span>vorw&auml;rts scrollen</span>"
    });

    $(wrapper).
      prepend($rwd).
      append($fwd);
  };


  //////////////////// INIT //////////////////////


  /**
   * Modul initialisieren
   */
  shop.ui.init = function uiInit() {
    shop.ui.setEventListener();

    // Regelmaessig Meldungen aus dem DOM entfernen, die nicht mehr dargestellt werden
    $notificationWrapper = $('.notifications');

    // Sticky-Header, sofern vorhanden
    if ( $('.site-header-sticky').length > 0 && !$('.shop-order').length ) {
      initStickyHeader();
    }

    // weitere Sticky-Elemente
    shop.ui.initSticky();

    // Formularfehlermeldungen anzeigen
    if ( $('.form-line').length > 0 ) {
      shop.ui.showFormErrors();
    }

    // Scroll-Buttons
    $('.page-scroll-buttons').each(shop.ui.createScrollButtons);

    setTimeout(shop.ui.updateStickyOnScroll, 50);

    // Trotz Autofokus zum oberen Bildschirmrand scrollen
    if ( $('[autofocus]').filter('.ignore-scroll').length ) {
      setTimeout(function scrollToWindowTop() {
        window.scrollTo(0,0);
      }, 0);
    }

    shop.ui.initFonts();

    // NOSCRIPT: Meldungen ausblenden (auch bei NoScript-Addons)
    $('body').addClass('js').removeClass('no-js');
  };


  $(document).on('ready', shop.ui.init);

}(this, this.document, this.shop, this.jQuery));

