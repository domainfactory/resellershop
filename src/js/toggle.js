(function(window, document, shop, $, undefined){
  "use strict";

  shop.toggle = {};

  var css = {
    sectionToggle: 'section-toggle',
    loginToggle: 'toggle-login',
    tarifLimitDetails: 'tariff-limit-details',
    tarifShown: 'tariff-limit-shown',
    tarifAllShown: 'tariff-limits-shown',
    tarifHidden: 'tariff-limit-hidden',
    tarifToggle: 'tariff-limit-toggle'
  };

  var $body;
  var $tarife;
  var $nav;


  // ACCORDION/TABS: Akkordion und Tabs auf- und zuklappen
  shop.toggle.setEventListener = function toggleSetEventListener() {
    var $delegate = $(document);
    var clickEvent = 'click.shop';

    // Auf- und Zuklappen von Elementen
    $delegate.on(clickEvent, '.'+css.sectionToggle, function clickToggleSection(event){
      event.preventDefault();
      shop.toggle.section(this);
    });

    // Login
    $delegate.on(clickEvent, 'a[href="#login"], .'+css.loginToggle, shop.toggle.login);

    // HEADER: Navigation auf- und zuklappen
    $delegate.on(clickEvent, '.site-nav-toggle BUTTON', function(event) {
      event.preventDefault();
      $nav.toggleClass('site-nav-mobile-active');
    });

    // HEADER/CART: Warenkorb auf- und zuklappen
    var $cartWrapper = $('.site-cart-wrapper');
    $('.toggle-cart-preview').attr('href','');
    $delegate.on(clickEvent, '.toggle-cart-preview', function(event) {
      event.preventDefault();
      $nav.toggleClass('site-nav-cart-preview-active');
      $cartWrapper.toggleClass('site-cart-preview-active');
    });

    // Details der Tariflimits
    $delegate.on(clickEvent, '.'+css.tarifLimitDetails, function(){
      shop.toggle.tarifDetails( $(this) );
    });

    // Akkordion und Tabs
    $delegate.on(clickEvent, '.accordion-title,.list-tabs:not(.list-tabs-ui) A,.list-tabs LABEL[role="tab"]', function(event){
      var $this = $(this);
      if ( !$this.is('LABEL') ) {
        event.preventDefault();
      }
      shop.toggle.accordionTab($this);
    });
  };


  //////////////////// SECTION //////////////////////


  /**
   * Bereiche auf- und zuklappen
   *
   * @param {DOMElement} triggerElement 
   */
  shop.toggle.section = function toggleSection(triggerElement) {
    var $trigger = $(triggerElement);

    // In data-toggle werden die Parameter als Hash angegeben
    // Folgende Parameter fuer toggle sind erlaubt:
    // - target              : querySelector, das fuer Oeffnen/Schliessen ferngesteuert wird
    // - activeClass         : Klasse fuer Ziel, das fuer den Aktivzustand verwendet wird
    // - inactiveClass       : Klasse fuer Ziel, das fuer den deaktivierten Zustand verwendet wird
    // - [activeTargetClass] : Klasse fuer Trigger, die fuer den Aktivzustand verwendet wird
    // - [activeLabel]       : Inhalt des Triggers, wenn das Element aktiv ist
    // - [inactiveLabel]     : Inhalt des Triggers, wenn das Element inaktiv ist
    var toggleData = $trigger.data('toggle');

    if ( !toggleData ) {
      return;
    }

    // Element auf-/zuklappen
    if ( toggleData.target ) {
      $(toggleData.target).toggleClass(toggleData.activeTargetClass || 'section-active');
    }

    // Aktive Klasse austauschen
    $trigger.toggleClass(toggleData.activeClass).toggleClass(toggleData.inactiveClass);

    // Text des Elements austauschen
    if ( toggleData.activeLabel && toggleData.inactiveLabel ) {
      if ( $trigger.hasClass(toggleData.activeClass) ) {
        $trigger.html(toggleData.activeLabel);
      } else {
        $trigger.html(toggleData.inactiveLabel);
      }
    }
  };


  //////////////////// LOGIN //////////////////////


  shop.toggle.login = function toggleLogin() {
    var openClass = 'login-opened';
    if ( $body.hasClass(openClass) ) {
      $body.removeClass(openClass);
      shop.ui.stickyGlobalExtraTop = 0;
    } else {
      $body.addClass(openClass);
      shop.ui.stickyGlobalExtraTop = $('.site-login').outerHeight();
      $('#site-login-user').trigger('focus');
    }
  };


  //////////////////// TARIFE //////////////////////


  // TARIFFCOMPARE: Tariflimits auf Mobil komplett ein- und ausblenden
  shop.toggle.tarifDetails = function toggleTariffDetails($tarifDetails) {
    var shownClass = '';
    var $wrapper = {};
    if ( window.innerWidth <= 511 ) {
      shownClass = css.tarifShown;
      $wrapper = $tarifDetails.toggleClass(shownClass);
    } else {
      shownClass = css.tarifAllShown;
      $wrapper = $tarife.toggleClass(shownClass);
    }

    var $target = $wrapper.find('.'+css.tarifToggle);
    var activeClass = 'icon-minus-small';
    var inactiveClass = 'icon-plus-small';

    if ( $wrapper.hasClass(shownClass) ) {
      $target.
        html('weniger Info').
        removeClass(inactiveClass).
        addClass(activeClass);
    } else {
      $target.
        html('mehr Info').
        addClass(inactiveClass).
        removeClass(activeClass);
    }
  };


  //////////////////// ACCORDION / TABS //////////////////////


  shop.toggle.accordionTab = function toggleAccordionTab($clickOrigin) {
    var $wrapper = $clickOrigin.closest('.accordion,.tabs');

    var activeClass = $wrapper.data('active-class');
    var inactiveClass = $wrapper.data('inactive-class');

    var isMultiple = $wrapper.attr('aria-multiselectable');
    var isCurrentSelected = $clickOrigin.attr('aria-selected') === "true";

    // Bestehende Links zuklappen
    if ( !isMultiple || isCurrentSelected ) {
      var $elementsToClose = isCurrentSelected ? $clickOrigin : $wrapper.find('[aria-selected="true"]');
      $elementsToClose.
        attr({
          'aria-selected': 'false',
          'aria-expanded': 'false'
        }).
        removeClass(activeClass).
        addClass(inactiveClass).
        next('.accordion-content,.list-tab-content').
          attr({
            'aria-hidden': 'true',
            'tabindex': -1
          });
    }

    // Neuen Link aufklappen
    if ( $wrapper.is('.tabs') || !isCurrentSelected ) {
      $wrapper.find('[href="'+$clickOrigin.attr('href')+'"]').
        attr({
          'aria-selected': 'true',
          'aria-expanded': 'true'
        }).
        removeClass(inactiveClass).
        addClass(activeClass).
        next('.accordion-content,.list-tab-content').
          attr({
            'aria-hidden': 'false',
            'tabindex': 0
          });
    }
  };

  shop.toggle.createAccordion = function toggleCreateAccordion(i, wrapper){
    var $wrapper = $(wrapper);

    $wrapper.attr({
      'role': 'tablist'
    });

    // Link setzen
    $wrapper.find('.accordion-title').
      attr({
        'aria-expanded': 'false',
        'aria-selected': 'false',
        'role': 'tab',
        'tabindex': 0
      }).
      addClass($wrapper.data('inactive-class')).
      not('A,BUTTON').
        on('keyup', function triggerAccordionClick(event){
          if ( event.keyCode === 13 ) {
            event.preventDefault();
            $(this).trigger('click.shop');
          }
        });

    $wrapper.find('.accordion-content').
      attr({
        'aria-hidden': 'true',
        'role': 'tabpanel',
        'tabindex': '-1'
      }).
      each(function(){
        var $this = $(this);
        var id = $this.attr('id');
        var $label = $this.parent().find('[href$="'+id+'"]');
        var labelid = id + '-label';
        $this.attr('aria-labelled-by', labelid);
        $label.attr({
          'aria-controls': id,
          'href': id,
          'id': labelid
        });
      });
  };


  //////////////////// TABS //////////////////////


  // TABS: Horizontale Tableiste fuer Desktop erstellen
  shop.toggle.createDesktopTabs = function toggleCreateDesktopTabs(i, wrapper){
    var $wrapper = $(wrapper);
    var $newLinks = $('<div/>', {
      "class": $wrapper.find('.list-tabs').prop('className') + ' list-horizontal list-tabs-desktoprow',
      role:'presentation'
    });
    $wrapper.
      find('[role="tab"]').
        clone().
          find('.tab-no-copy').
            remove().
          end().
          appendTo($newLinks);
    $wrapper.
      prepend($newLinks).
      addClass('list-tabs-hasdesktop');
  };



  shop.toggle.init = function toggleInit() {
    shop.toggle.setEventListener();

    $body = $('body');
    $nav = $('.site-nav');
    $tarife = $('#tarife');

    $('.accordion').each(shop.toggle.createAccordion);
    $('.accordion-open-first').find('.accordion-title').first().trigger('click');
    $('.tabs').each(shop.toggle.createDesktopTabs);
  };

  $(document).on('ready', shop.toggle.init);

}(this, this.document, this.shop, this.jQuery));

