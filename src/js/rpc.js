var shop=shop||{};
(function(window, document, shop, $, undefined){
  "use strict";

  shop.rpc = {};


  /**
   * Standardeinstellungen fuer AJAX-Abfragen
   * @private {Object}
   */
  var xhrDefaultOptions = {
    url: "rpc.php",   // Standard-Ziel fuer RPC-Aufrufe
    async: true,      // Aufrufe asynchron durchfuehren. false wird NICHT empfohlen!
    cache: false,     // Ergebnisse nicht cachen
    dataType: "json", // Nur JSON als Rueckgabe akzeptieren
    method: "POST",   // HTTP-Methode
    timeout: 60000    // Dauer in Millisekunden, nach dem die Abfrage abgebrochen wird
  };


  //////////////////// RENDER //////////////////////


  /**
   * RPC (POST) absenden und gerendertes Template im Zielobjekt einfuegen
   *
   * @function shop.rpc.render
   * @see {@link shop.rpc.injectRenderedResult}
   * @param {string} target - querySelector, in dem das Element eingefuegt werden soll
   * @param {Object} rpcOptions - Optionen fuer den RPC
   * @return {$.Deferred} Promise mit dem Ergebnis des RPC
   */
  shop.rpc.render = function rpcRender(target, rpcOptions) {
    return shop.rpc.post(rpcOptions["class"], rpcOptions.method, rpcOptions.data).
      then(function injectResult(result) {
        shop.rpc.injectRenderedResult(target, result);
        return result;
      });
  };


  /**
   * Gerendertes Template in Zielobjekt einfuegen
   *
   * @function shop.rpc.injectRenderedResult
   * @param {Object} result - Ergebnis des RPC
   */
  shop.rpc.injectRenderedResult = function rpcInjectRenderedResult(target, result) {
    // Grobe Prüfung auf Rückgabe
    if ( !result || !result.messages ) {
      shop.ui.renderMessage({
        msg: 'Ung&uuml;tige Antwort des Servers!',
        type: "error"
      });
      return result;
    }

    // Inhalt in DOM einfuegen
    if ( result.data.template ) {
      shop.ui.inject(target, result.data.template);
    }
    return result;
  };


  //////////////////// SEND REQUESTS //////////////////////


  /**
   * RPC-Abfrage als POST absenden
   *
   * @function shop.rpc.post
   * @see {@link shop.rpc.xhr}
   * @param  {string} method
   * @param  {*} data - Nutzdaten, die an den Server gesendet werden
   * @return {$.Deferred} Promise mit dem Ergebnis des Servers
   */
  shop.rpc.post = function rpcPost(rpcClass, rpcMethod, data) {
    return shop.rpc.xhr({
      data: {
        "class": rpcClass,
        method: rpcMethod,
        data: data
      }
    });
  };


  /**
   * XmlHttpRequests absenden
   *
   * @function shop.rpc.xhr
   * @param  {Object} options Einstellungen der XHR-Abfrage
   * @return {$.Deferred} Promise mit dem Ergebnis des Servers
   */
  shop.rpc.xhr = function rpcXhr(options) {
    var xhrOptions = $.extend(xhrDefaultOptions, options);
    return $.ajax(xhrOptions).then(
      function onXhrSuccess(result) {
        return shop.rpc.renderMessagesFromRpcResult(result);
      },
      shop.rpc.onXhrError
    );
  };


  /**
   * Fehler bei Ausfuehrung des Requests
   *
   * @function shop.rpc.onXhrError
   * @param {Object} xhr XHR-Objekt von jQuery.ajax
   * @param {string} textStatus Statusmeldung
   */
  shop.rpc.onXhrError = function rpcOnXhrError(xhr, textStatus/*, error*/) {
    // Verhindern, dass beim Seitenwechsel Fehler angezeigt werden
    if ( textStatus === 'error' && !xhr.status ) {
      return;
    }

    var msg = 'Es trat der Fehler "' + textStatus + '" bei der Abfrage an den Server auf';
    if ( textStatus === 'timeout' ) {
      msg = 'Abfrage an den Server &uuml;berschritt das Zeitlimit';
    }
    if ( textStatus === 'abort' ) {
      msg = 'Abfrage wurde vom Server abgebrochen';
    }
    if ( textStatus === 'parsererror' ) {
      msg = 'Es wurden ung&uuml;ltige Daten &uuml;bermittelt';
    }

    msg += '. Bitte versuchen Sie es sp&auml;ter erneut.';

    shop.ui.renderMessage({
      msg: msg,
      type: 'error'
    });
  };


  //////////////////// HANDLE RESULTS //////////////////////


  /**
   * RPC-Meldungen ausgeben
   *
   * @function shop.rpc.renderMessagesFromRpcResult
   * @param {Object} result - Ergebnisse des RPC
   * @return {Object} result - Eregebnisse des RPC
   */
  shop.rpc.renderMessagesFromRpcResult = function rpcRenderMessagesFromResult(result) {
    if ( result && result.hasOwnProperty('messages') && result.messages instanceof Array ) {
      // Fehlermeldungen anzeigen
      var messages = result.messages;
      var msgCount = result.messages.length;
      if ( msgCount ) {
        for ( var i = 0; i < msgCount ; i++ ) {
          if ( !messages.hasOwnProperty(i) ) { continue; }
          shop.ui.renderMessage(messages[i]);
        }
      }
    }

    // Ergebnis fuer nachfolgende Anfragen weitergeben
    return result;
  };

}(this, this.document, this.shop, this.jQuery));
