{% spaceless %}
<section class="order-checkout">
  <h2>Bitte &uuml;berpr&uuml;fen Sie noch einmal Ihre ange&shy;gebenen Daten</h2>

  {% set customer_adress %}
    <p class="bold">{{ customer.adress.cus.first_name }} {{ customer.adress.cus.last_name }}</p>
    <p>{{ customer.adress.cus.adress_1 }}</p>
    {% if customer.adress.cus.adress_2 %}<p>{{ customer.adress.cus.adress_2 }}</p>{% endif %}
    <p>{{ customer.adress.cus.zip }} {{ customer.adress.cus.city }}</p>
    <p>{{ countries[customer.adress.cus.ccid].name }}</p>
  {% endset %}

  <div class="order-box-row">
    <article class="order-checkout-data order-box">
      <h3>Kunden&shy;adresse</h3>

      {{ customer_adress }}
    </article>

    <article class="order-checkout-data order-box">
      <h3>Rechnungs&shy;adresse</h3>

      {# eigene Rechnungsadresse #}
      {% if customer.adress.inv.diff %}
        <p class="bold">{{ customer.adress.inv.first_name }} {{ customer.adress.inv.last_name }}</p>
        <p>{{ customer.adress.inv.adress_1 }}</p>
        {% if customer.adress.inv.adress_2 %}<p>{{ customer.adress.inv.adress_2 }}</p>{% endif %}
        <p>{{ customer.adress.inv.zip }} {{ customer.adress.inv.city }}</p>
        <p>{{ countries[customer.adress.inv.ccid].name }}</p>

      {# Rechnungsadresse entsprecht Kundenadresse #}
      {% else %}
        {{ customer_adress }}

        <p class="check-state icon icon-checkbox-small icon-bg-brand">ent&shy;spricht Kunden&shy;adresse</p>
      {% endif %}
    </article>

    <article class="order-checkout-data order-box">
      <h3>Bezah&shy;lung</h3>

      {% set payment = payments[customer.payinfo.cpid] %}
      {% if payment %}
        <p class="bold">via {{ payment.name }}</p>

        {# Bankeinzug #}
        {% if payment.typ == "bank" %}
          <dl>
            <dt><abbr title="Kontonummer">Konto-Nr.</abbr></dt><dd>{{ customer.payinfo.bank_account_nr }}</dd>
            <dt><abbr title="Bankleitzahl">BLZ</abbr></dt><dd>{{ customer.payinfo.bank_code }}</dd>
            <dt><abbr title="Kontoinhaber">Konto-Inh.</abbr></dt><dd>{{ customer.payinfo.bank_account_holder }}</dd>
            <dt><abbr title="Bankname">Bank</abbr></dt><dd>{{ customer.payinfo.bank_name }}</dd>
          </dl>

        {# SEPA-Verbindung #}
        {% elseif payment.typ == "sepa" or payment.typ == "sepa_sl" %}
          <dl>
            <dt><abbr title="International Bank Account Number">IBAN</abbr></dt><dd>{{ customer.payinfo.sepa_iban|split('',4)|join(' ') }}</dd>
            <dt><abbr title="Bank Identifier Code">BIC</abbr></dt><dd>{{ customer.payinfo.sepa_bic }}</dd>
            <dt><abbr title="Kontoinhaber">Konto-Inh.</abbr></dt><dd>{{ customer.payinfo.sepa_holder }}</dd>
            <dt>Mandats-ID</dt><dd>{{ customer.payinfo.sepa_mr }}</dd>
          </dl>

        {# Kreditkarte #}
        {% elseif payment.typ == "cc" %}
          {% set cc_type = customer.payinfo.cc_typ %}
          <dl>
            <dt>Typ</dt>
            {% if cc_type == "ae" %}<dd>American Express</dd>{% endif %}
            {% if cc_type == "dc" %}<dd>Diners Club</dd>{% endif %}
            {% if cc_type == "mc" %}<dd>MasterCard</dd>{% endif %}
            {% if cc_type == "vc" %}<dd>Visa</dd>{% endif %}
            <dt>Karten&shy;nummer</dt><dd>{{ customer.payinfo.cc_nr }}</dd>
            <dt>Karten&shy;inhaber</dt><dd>{{ customer.payinfo.cc_holder }}</dd>
          </dl>

        {# Rechnung #}
        {#{% elseif payment.typ == "invoice" %}#}
        {% endif %}
      {% endif %}
    </article>
  </div>

  <article class="order-checkout-cart cart-overview">
    <h3 class="a11y-header">Ihr Warenkorb</h3>
    {% set cart_editable = false %}
    {% include "modules/cart_articles.tpl" %}
  </article>

  <form class="order-checkout-agb" method="POST" action="{{ url("page_successful") }}">
    <p class="form-line form-line-checkbox form-force-error {{ markError('agb') }}" data-msg="{{ getError('agb') }}">
      <input id="input-agb" type="checkbox" name="agb" value="1" autofocus="autofocus" class="ignore-scroll" required="required">
      <label for="input-agb">
        Mit der Aufgabe der Bestellung versichere ich, dass ich die <a href="{{ site.url.pdf_agb }}" download="agb.pdf" target="_blank">Allgemeinen Gesch&auml;fts&shy;bedingungen, Domain-Registrierungs&shy;bedingungen</a> und <a href="{{ url("page_privacy") }}" target="_blank">Datenschutz&shy;bestimmungen</a> der {{ site.name.full }} gelesen habe und verbindlich erkenne.
      </label>
    </p>
  </form>
</section>
{% endspaceless %}

