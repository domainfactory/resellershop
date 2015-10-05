<div class="tabs">
  <ol class="list-tabs" role="tablist">
    {% for payment in payments %}
      {# Aktueller Tab aktiv? #}
      {% set payment_selected = (not data.payinfo and payment.preset) or (data.payinfo.cpid == payment.cpid) %}

      {# Tab #}
      {% set payment_tab %}
        <label for="input-cpid-{{ payment.cpid }}" id="tab-payinfo-{{ payment.cpid }}-label" class="register-type register-type-{{ payment.typ }} icon" href="#tab-payinfo-{{ payment.cpid }}" aria-selected="{% if payment_selected %}true{% else %}false{% endif %}" role="tab" title="{{ payment.name }}">
          <input type="radio" id="input-cpid-{{ payment.cpid }}" value="{{ payment.cpid }}" name="data[payinfo][cpid]"{% if payment_selected %} checked="checked"{% endif %} class="tab-no-copy">
          {{ payment.name }}
        </label>
      {% endset %}

      {# Attribute des Tab-Inhalt-Elements #}
      {% set payment_tabpanel_attr %}
        id="tab-payinfo-{{ payment.cpid }}" class="list-tab-content" aria-hidden="{% if payment_selected %}false{% else %}true{% endif %}" aria-labelledby="tab-payinfo-{{ payment.cpid }}-label" role="tabpanel"
      {% endset %}


      {# BANKEINZUG #}

      {% if payment.typ == "bank" and payment.active %}
        <li>
          {{ payment_tab }}
          <div {{ payment_tabpanel_attr }}>
            <h3 class="register-type-headline">{{ payment.name }}</h3>
            <p>Ihre eingebenen Kontodaten werden in IBAN und BIC umgerechnet.</p>

            <p class="form-line form-line-margin">
              <label for="input-payinfo-bank_account_nr">Konto&shy;nummer</label>
              <input id="input-payinfo-bank_account_nr" type="number" name="data[payinfo][bank_account_nr]" placeholder="Beispiel: 1234567" class="form-prevent-spinbox {{ markError('bank_account_nr','payinfo') }}" data-msg="{{ getError('bank_account_nr','payinfo') }}" value="{{ data.payinfo.bank_account_nr }}" mozactionhint="next">
            </p>
            <p class="form-line">
              <label for="input-payinfo-bank_code">Bank&shy;leit&shy;zahl</label>
              <input id="input-payinfo-bank_code" type="number" name="data[payinfo][bank_code]" placeholder="Beispiel: 50010517" class="form-prevent-spinbox {{ markError('bank_code','payinfo') }}" data-msg="{{ getError('bank_code','payinfo') }}" value="{{ data.payinfo.bank_code }}" mozactionhint="next">
            </p>

            <p class="form-line form-line-margin">
              <label for="input-payinfo-bank_account_holder">Konto&shy;inhaber</label>
              <input id="input-payinfo-bank_account_holder" type="text" name="data[payinfo][bank_account_holder]" placeholder="Beispiel: Max Mustermann" class="{{ markError('bank_account_holder','payinfo') }}" data-msg="{{ getError('bank_account_holder','payinfo') }}" value="{{ data.payinfo.bank_account_holder }}" mozactionhint="next">
            </p>
            <p class="form-line">
              <label for="input-payinfo-bank_name">Bank&shy;name</label>
              <input id="input-payinfo-bank_name" type="text" name="data[payinfo][bank_name]" placeholder="Beispiel: Testbank" class="{{ markError('bank_name','payinfo') }}" data-msg="{{ getError('bank_name','payinfo') }}" value="{{ data.payinfo.bank_name }}" mozactionhint="next">
            </p>
          </div>
        </li>
      {% endif %}

      {# RECHNUNG #}

      {% if payment.typ == "invoice" and payment.active %}
        <li>
          {{ payment_tab }}
          <div {{ payment_tabpanel_attr }}>
            <h3 class="register-type-headline">{{ payment.name }}</h3>
            <p>Sie erhalten Ihre Rechnung per E-Mail an Ihre angegebene Rechnungsadresse.</p>
          </div>
        </li>
      {% endif %}

      {# KREDITKARTE #}

      {% if payment.typ == "cc" and payment.active %}
        <li>
          {{ payment_tab }}
          <div {{ payment_tabpanel_attr }}>
            <h3 class="register-type-headline">{{ payment.name }}</h3>

            <p class="form-line {{ markError('cc_typ','payinfo') }}" data-msg="{{ getError('cc_typ','payinfo') }}">
              <label for="input-payinfo-cc_typ">Wir akzeptieren</label>
            </p>
            <p class="form-line">
              {% for type, use_type in payment.extendet %}
                {% if type == "ae" and use_type %}
                  <label class="form-radio-image" title="American Express">
                    <input type="radio" name="data[payinfo][cc_typ]" value="{{ type }}" {% if data.payinfo.cc_typ == type %}checked="checked"{% endif %}>
                    <span class="form-radio-text icon icon-only icon-payment-aexpress">American Express</span>
                  </label>
                {% endif %}
                {% if type == "dc" and use_type %}
                  <label class="form-radio-image" title="Diners Club">
                    <input type="radio" name="data[payinfo][cc_typ]" value="{{ type }}" {% if data.payinfo.cc_typ == type %}checked="checked"{% endif %}>
                    <span class="form-radio-text icon icon-only icon-payment-dinersclub">Diners Club</span>
                  </label>
                {% endif %}
                {% if type == "mc" and use_type %}
                  <label class="form-radio-image" title="MasterCard">
                    <input type="radio" name="data[payinfo][cc_typ]" value="{{ type }}" {% if data.payinfo.cc_typ == type %}checked="checked"{% endif %}>
                    <span class="form-radio-text icon icon-only icon-payment-mastercard">MasterCard</span>
                  </label>
                {% endif %}
                {% if type == "vc" and use_type %}
                  <label class="form-radio-image" title="Visa">
                    <input type="radio" name="data[payinfo][cc_typ]" value="{{ type }}" {% if data.payinfo.cc_typ == type %}checked="checked"{% endif %}>
                    <span class="form-radio-text icon icon-only icon-payment-visa">Visa</span>
                  </label>
                {% endif %}
              {% endfor %}
            </p>

            <p class="form-line form-line-margin">
              <label for="input-payinfo-cc_nr">Karten&shy;nummer</label>
              <input id="input-payinfo-cc_nr" type="text" inputmode="numeric" pattern="^(\d{4}\s*){4}$" maxlength="20" name="data[payinfo][cc_nr]" placeholder="Beispiel: 1234567890123456" autocomplete="section-order billing cc-number" class="form-prevent-spinbox {{ markError('cc_nr','payinfo') }}" data-msg="{{ getError('cc_nr','payinfo') }}" value="{{ data.payinfo.cc_nr }}" mozactionhint="next">
            </p>
            <p class="form-line">
              <span class="form-short-2of3">
                <label for="input-payinfo-cc_valid_month">G&uuml;ltig bis</label>
                <select id="input-payinfo-cc_valid_month" type="month" name="data[payinfo][cc_valid_month]" autocomplete="section-order billing cc-exp-month" class="{{ markError('cc_valid_month') }}" data-msg="{{ getError('cc_valid_month') }}" value="{{ data.payinfo.cc_valid_month }}">
                  {% for month in 1..12 %}
                    <option{% if month == data.payinfo.cc_valid_month %} selected="selected"{% endif %} value="{{ month }}">{{ months[month] }}</option>
                  {% endfor %}
                </select>
              </span>
              <span class="form-short-1of3">
                <label for="input-payinfo-cc_valid_year">Jahr</label>
                <select id="input-payinfo-cc_valid_year" type="year" name="data[payinfo][cc_valid_year]" autocomplete="section-order billing cc-exp-year" class="{{ markError('cc_valid_year','payinfo') }}" data-msg="{{ getError('cc_valid_year','payinfo') }}" value="{{ data.payinfo.cc_valid_year }}">
                  {% for inc in 0..8 %}
                    <option{% if (min_year + inc) == data.payinfo.cc_valid_year %} selected="selected"{% endif %}>{{ (min_year + inc) }}</option>
                  {% endfor %}
                </select>
              </span>
            </p>
            <p class="form-line form-line-margin">
              <label for="input-payinfo-cc_holder">Name auf Karte</label>
              <input id="input-payinfo-cc_holder" type="text" name="data[payinfo][cc_holder]" placeholder="Beispiel: Max Mustermann" autocomplete="section-order billing cc-name" maxlength="100" class="{{ markError('cc_holder','payinfo') }}" data-msg="{{ getError('cc_holder','payinfo') }}" value="{{ data.payinfo.cc_holder }}" mozactionhint="next">
            </p>
          </div>
        </li>
      {% endif %}

      {# SEPA #}

      {% if (payment.typ == "sepa" or payment.typ == "sepa_sl") and payment.active %}
        <li>
          {{ payment_tab }}
          <div {{ payment_tabpanel_attr }}>
            <h3 class="register-type-headline">{{ payment.name }}</h3>

            <p class="form-line">
              <label for="input-sepa_iban"><abbr title="International Bank Account Number">IBAN</abbr></label>
              <input id="input-sepa_iban" type="pattern" pattern="^[A-Z]{2}[0-9\s]{15,45}$" name="data[payinfo][sepa_iban]" placeholder="Beispiel: DE99 50010517 000 1234567" class="{{ markError('sepa_iban','payinfo') }}" data-msg="{{ getError('sepa_iban','payinfo') }}" value="{{ data.payinfo.sepa_iban }}" mozactionhint="next">
            </p>
            <p class="form-line">
              <label for="input-sepa_bic"><abbr title="Business Identifier Code">BIC</abbr></label>
              <input id="input-sepa_bic" type="pattern" pattern="^[A-Z0-9]{8}([A-Z0-9]{3})?$" maxlength="11" name="data[payinfo][sepa_bic]" placeholder="Beispiel: INGDDEFFXXX" class="{{ markError('sepa_bic','payinfo') }}" data-msg="{{ getError('sepa_bic','payinfo') }}" value="{{ data.payinfo.sepa_bic }}" mozactionhint="next">
            </p>

            <p class="form-line form-line-margin">
              <label for="input-sepa_holder">Kontoinhaber</label>
              <input id="input-sepa_holder" type="text" pattern="^.{5,}$" name="data[payinfo][sepa_holder]" placeholder="Beispiel: Max Mustermann" class="{{ markError('sepa_holder','payinfo') }}" data-msg="{{ getError('sepa_holder','payinfo') }}" value="{{ data.payinfo.sepa_holder }}" mozactionhint="next">
            </p>

            <p>Wir ermitteln den Banknamen automatisch aus Ihren eingegebenen Daten.</p>
          </div>
        </li>
      {% endif %}
    {% endfor %}
  </ol>
</div>

