(function(window, document, shop, $, undefined){
  "use strict";

  shop.forms = {};

  var css = {
    relationship: 'input-cus-relationship',
    country: 'form-country',
    phonePrefix: 'form-phone-country',
    ustid: 'input-cus-ustid',
    shippingWrapper: 'register-shipping-wrapper',
    shippingToggle: 'input-inv-diff'
  };

  shop.forms.setEventListener = function formsSetEventListener() {
    var $delegate = $(document);
    var clickEvent = 'click.shop';
    var submitEvent = 'submit.shop';
    var changeEvent = 'change.shop';

    // Absenden des Suchformulars
    $delegate.on(submitEvent, '.contact-form', function formsOnContactFormSubmit(event){
      event.preventDefault();
      shop.forms.submitContactRequest(this);
    });

    $delegate.on(clickEvent+' '+changeEvent, '#'+css.shippingToggle, function formsOnSelectShipping(){
      shop.forms.toggleShipping($(this).prop('checked'));
    });

    $delegate.on(changeEvent, '#'+css.relationship, function formsChangeRelationship(){
      shop.forms.toggleUStIdRequirements();
    });

    $delegate.on(changeEvent, '.'+css.country, function formsChangePrefixPlaceholderForCountry(){
      shop.forms.changePhonePrefix(this);
    });

    $delegate.on(clickEvent, '[data-submit-form]', function submitDistantForm(event){
      event.preventDefault();
      shop.forms.submitDistantForm($(this).data('submit-form'));
    });
  };


  //////////////////// SUBMIT //////////////////////


  var contactFormRequested = false;

  shop.forms.submitContactRequest = function formsSubmitContactRequest(form) {
    if ( contactFormRequested ) {
      shop.ui.renderMessage({
        msg: "Sie haben bereits eine Anfrage an uns gesendet. Bitte haben Sie etwas Geduld, bis wir Ihre Anfrage bearbeiten.",
        type: "notice"
      });
      return false;
    }

    var $form = $(form);
    var contactFormInputs = $form.serializeArray();
    var inputLength = contactFormInputs.length;
    var form = {};

    for ( var i = 0; i < inputLength; i++ ) {
      if ( !contactFormInputs.hasOwnProperty(i) ) { continue; }
      form[ contactFormInputs[i].name ] = contactFormInputs[i].value;
    }

    // Absenden-Button deaktivieren,
    // um mehrfaches Versenden des selben Formulars zu verhindern
    $form.find('[type="submit"]').
      prop('disabled', true).
      addClass('button-disabled').
      html('Sende...');

    return shop.rpc.render('.contact-form', {
      'class': 'modIndex',
      method: 'sendContactRequest',
      data: form
    }).then(function onSubmitContactRequested(result) {
      if ( result.success ) {
        contactFormRequested = true;
      }
      if ( result.data.dialog ) {
        shop.ui.showDialog(result.data.dialog);
      }
      shop.ui.showFormErrors();
    });
  };


  shop.forms.toggleShipping = function formsToggleShipping(newShippingState) {
    var $wrapper = $('.'+css.shippingWrapper).find('input,select').prop('disabled', !newShippingState);
    if ( newShippingState ) {
      $wrapper.first().trigger('focus');
    }
  };

  shop.forms.toggleUStIdRequirements = function formsToggleUStIdRequirements() {
    var $ustid = $('#' + css.ustid);
    if ( $ustid.length ) {
      var $relationship = $('#' + css.relationship);
      if ( $relationship.length ) {
        $ustid.prop('required', $relationship.val() === 'b2b');
      }
    }
  };


  shop.forms.changePhonePrefix = function formsChangePhonePrefixForCountry(countryInput) {
    var $countryInput = $(countryInput);
    var newPrefix = $countryInput.find('OPTION').filter(':selected').data('phone-prefix');
    $countryInput.
      closest('.form-line').
        parent().
          find('.' + css.phonePrefix).
            attr('placeholder', newPrefix).
            filter('[required][value=""]').
              val(newPrefix);
  };


  shop.forms.submitDistantForm = function formsSubmitDistantForm(target) {
    $('.'+target).trigger('submit');
  };


  //////////////////// INIT //////////////////////


  shop.forms.init = function formsInit() {
    shop.forms.setEventListener();
    shop.forms.toggleShipping($('#'+css.shippingToggle).prop('checked'));
    shop.forms.toggleUStIdRequirements();
  };

  $(document).on('ready', shop.forms.init);

}(this, this.document, this.shop, this.jQuery));
