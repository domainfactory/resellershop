<ul class="accordion accordion-open-first" aria-multiselectable="true" role="tablist" data-active-class="icon icon-bg-brand icon-minus-small" data-inactive-class="icon icon-bg-brand icon-plus-small">

  <li class="icon-small icon-small-bg-brand icon-small-plus">
    <a class="accordion-title" href="#tab-userdata-customer" id="tab-userdata-customer-label" aria-controls="tab-userdata-customer-content" role="tab" aria-selected="true">
      <h3>Kunden&shy;adresse</h3>
    </a>

    <div id="tab-userdata-customer-content" aria-labelled-by="tab-userdata-customer-label" class="accordion-content" role="tabpanel" aria-hidden="false">

      <p class="form-line form-line-margin">
        <span class="form-short-1of3">
          <label for="input-cus-title">Anrede</label>
          <select id="input-cus-title" name="data[adress][cus][ctid]" class="{{ markError('title', 'cus') }}" autocomplete="section-order billing honorific-prefix">
            {% for title in titles %}
              <option value="{{ title.ctid }}"{% if title.preset %} selected="selected"{% endif %}>{{ title.name }}</option>
            {% endfor %}
          </select>
        </span>
        <span class="form-short-2of3">
          <label for="input-cus-first_name">Vorname</label>
          <input id="input-cus-first_name" class="{{ markError('first_name','cus') }}" data-msg="{{ getError('first_name','cus') }}" inputtype="latin-name" pattern="^\w[\w\d\s.-,]{1,49}$" maxlength="50" required="required" type="text" autofocus="autofocus" autocorrect="none" name="data[adress][cus][first_name]" autocomplete="section-order billing given-name" value="{{ data.adress.cus.first_name }}" placeholder="2 - 50 Zeichen erlaubt" mozactionhint="next">
        </span>
      </p>

      <p class="form-line">
        <label for="input-cus-last_name">Name</label>
        <input id="input-cus-last_name" class="{{ markError('last_name','cus') }}" data-msg="{{ getError('last_name','cus') }}" inputtype="latin-name" pattern="^\w[\w\d\s.-,]{1,49}$" maxlength="50" required="required" type="text" name="data[adress][cus][last_name]" autocorrect="none" autocomplete="section-order billing family-name" value="{{ data.adress.cus.last_name }}" placeholder="2 - 50 Zeichen erlaubt" mozactionhint="next">
      </p>

      {% if site.register.show_company %}
        <p class="form-line form-line-margin">
          <label for="input-cus-company">Firma</label>
          <input id="input-cus-company" class="{{ markError('company','cus') }}" data-msg="{{ getError('company','cus') }}" type="text" maxlength="100" name="data[adress][cus][company]" autocorrect="none" autocomplete="section-order billing organization" value="{{ data.adress.cus.company }}" placeholder="Beispiel: Musterfirma GmbH" mozactionhint="next">
        </p>
      {% endif %}

      {% if site.register.show_relationship %}
        <p class="form-line">
          <label for="input-cus-relationship">Handels&shy;beziehung</label>
          <select id="input-cus-relationship" name="data[adress][cus][relationship]" mozactionhint="next">
            <option value="b2c"{% if data.adress.cus.relationship == "b2c" %} selected="selected"{% endif %}>Privatkunde</option>
            <option value="b2b"{% if data.adress.cus.relationship == "b2b" %} selected="selected"{% endif %}>Gewerblicher Kunde</option>
          </select>
        </p>
      {% endif %}

      {% if site.register.show_ustid or site.register.show_relationship %}
        <p class="form-line">
          <label for="input-cus-ustid"><abbr title="Umsatzsteuer-Identifikationsnummer">USt-ID</abbr></label>
          <input id="input-cus-ustid" class="{{ markError('ustid','cus') }}" data-msg="{{ getError('ustid','cus') }}" type="text" name="data[adress][cus][ustid]" value="{{ data.adress.cus.ustid }}" placeholder="Beispiel: {% if master.ust_idnr %}{{ master.ust_idnr }}{% else %}DE123456789{% endif %}" mozactionhint="next">
        </p>
      {% endif %}

      <p class="form-line form-line-margin">
        <label for="input-cus-adress_1">Stra&szlig;e und Haus&shy;nummer</label>
        <input id="input-cus-adress_1" class="{{ markError('adress_1','cus') }}" data-msg="{{ getError('adress_1','cus') }}" type="text" maxlength="200" required="required" name="data[adress][cus][adress_1]" autocomplete="section-order billing address-line1" value="{{ data.adress.cus.adress_1 }}" placeholder="4 - 200 Zeichen erlaubt" mozactionhint="next">
      </p>

      {% if site.register.show_adress_2 %}
        <p class="form-line">
          <label for="input-cus-adress_2">Adress&shy;zusatz</label>
          <input id="input-cus-adress_2" class="{{ markError('adress_2','cus') }}" data-msg="{{ getError('adress_2','cus') }}" type="text" maxlength="200" name="data[adress][cus][adress_2]" autocomplete="section-order billing address-line2" value="{{ data.adress.cus.adress_2 }}" placeholder="4 - 200 Zeichen erlaubt" mozactionhint="next">
        </p>
      {% endif %}

      <p class="form-line">
        <span class="form-short-1of3">
          <label for="input-cus-zip"><abbr title="Postleitzahl">PLZ</abbr></label>
          <input id="input-cus-zip" class="{{ markError('zip','cus') }}" data-msg="{{ getError('zip','cus') }}" type="text" maxlength="10" name="data[adress][cus][zip]" required="required" autocomplete="section-order billing postal-code" value="{{ data.adress.cus.zip }}" placeholder="12345" mozactionhint="next">
        </span>
        <span class="form-short-2of3">
          <label for="input-cus-city">Ort</label>
          <input id="input-cus-city" class="{{ markError('city','cus') }}" data-msg="{{ getError('city','cus') }}" type="text" maxlength="50" required="required" name="data[adress][cus][city]" autocomplete="section-order billing address-level2" value="{{ data.adress.cus.city }}" placeholder="2 - 50 Zeichen erlaubt" mozactionhint="next">
        </span>
      </p>

      {% set country_tel_prefix = "" %}
      <p class="form-line">
        <label for="input-cus-country">Land</label>
        <select id="input-cus-country" class="form-country" name="data[adress][cus][ccid]">
          {% for country in countries %}
            {% set country_selected = (not data.adress.cus and country.preset) or (data.adress.cus.ccid == country.ccid) %}
            <option value="{{ country.ccid }}" data-phone-prefix="{{ country.phone_prefix }}"{% if country_selected %} selected="selected"{% endif %}>{{ country.name }}</option>
            {% if country_selected %}
              {% set country_tel_prefix = country.phone_prefix %}
            {% endif %}
          {% endfor %}
        </select>
      </p>

      <p class="form-line form-line-margin">
        <label for="input-cus-phone_1">Telefon</label>
        <span class="form-line-prefix">+</span>
        <input id="input-cus-phone_1" class="form-phone form-phone-country form-prevent-spinbox {{ markError('phone_1','cus') }}" type="number" min="1" maxlength="5" required="required" name="data[adress][cus][phone_1][land]" value="{% if data.adress.cus.phone_1.land %}{{ data.adress.cus.phone_1.land }}{% endif %}" placeholder="{{ country_tel_prefix }}" autocomplete="section-order billing tel-country-code" mozactionhint="next">
        <input class="form-phone form-phone-prefix form-prevent-spinbox {{ markError('phone_1','cus') }}" type="number" min="1" required="required" name="data[adress][cus][phone_1][prefix]" value="{{ data.adress.cus.phone_1.prefix }}" placeholder="1234" autocomplete="section-order billing tel-area-code" mozactionhint="next">
        <input class="form-phone form-phone-number form-prevent-spinbox {{ markError('phone_1','cus') }}" data-msg="{{ getError('phone_1','cus') }}" type="number" min="1" required="required" name="data[adress][cus][phone_1][number]" value="{{ data.adress.cus.phone_1.number }}" placeholder="567890" autocomplete="section-order billing tel-local" mozactionhint="next">
      </p>

      {% if site.register.show_phone_2 %}
        <p class="form-line">
          <label for="input-cus-phone_2">Telefon 2</label>
          <span class="form-line-prefix">+</span>
          <input id="input-cus-phone_2" class="form-phone form-phone-country form-prevent-spinbox {{ markError('phone_2','cus') }}" type="number" min="1" maxlength="5" name="data[adress][cus][phone_2][land]" value="{% if data.adress.cus.phone_2.land %}{{ data.adress.cus.phone_2.land }}{% endif %}" placeholder="{{ country_tel_prefix }}" mozactionhint="next">
          <input class="form-phone form-phone-prefix form-prevent-spinbox {{ markError('phone_2','cus') }}" type="number" min="1" name="data[adress][cus][phone_2][prefix]" value="{{ data.adress.cus.phone_2.prefix }}" placeholder="1234" mozactionhint="next">
          <input class="form-phone form-phone-number form-prevent-spinbox {{ markError('phone_2','cus') }}" data-msg="{{ getError('phone_2','cus') }}" type="number" min="1" name="data[adress][cus][phone_2][number]" value="{{ data.adress.cus.phone_2.number }}" placeholder="567890" mozactionhint="next">
        </p>
      {% endif %}

      {% if site.register.show_fax %}
        <p class="form-line">
          <label for="input-cus-fax">Telefax</label>
          <span class="form-line-prefix">+</span>
          <input id="input-cus-fax" class="form-phone form-phone-country form-prevent-spinbox {{ markError('fax','cus') }}" type="number" min="1" maxlength="5" name="data[adress][cus][fax][land]" value="{% if data.adress.cus.fax.land %}{{ data.adress.cus.fax.land }}{% endif %}" placeholder="{{ country_tel_prefix }}" autocomplete="section-order billing fax-country-code" mozactionhint="next">
          <input class="form-phone form-phone-prefix form-prevent-spinbox {{ markError('fax','cus') }}" type="number" min="1" name="data[adress][cus][fax][prefix]" value="{{ data.adress.cus.fax.prefix }}" placeholder="1234" autocomplete="section-order billing fax-area-code" mozactionhint="next">
          <input class="form-phone form-phone-number form-prevent-spinbox {{ markError('fax','cus') }}" data-msg="{{ getError('fax','cus') }}" type="number" min="1" name="data[adress][cus][fax][number]" value="{{ data.adress.cus.fax.number }}" placeholder="567890" autocomplete="section-order billing fax-local" mozactionhint="next">
        </p>
      {% endif %}

      <p class="form-line form-line-margin">
        <label for="input-cus-email">E-Mail-Adresse</label>
        <input id="input-cus-email" class="{{ markError('email','cus') }}" data-msg="{{ getError('email','cus') }}" type="email" required="required" name="data[adress][cus][email]" autocomplete="section-order billing email" value="{{ data.adress.cus.email }}" placeholder="Beispiel: shop@example.com" mozactionhint="next">
      </p>

    </div>
  </li>


  <li class="icon-small icon-small-bg-brand icon-small-plus">
    <a class="accordion-title" href="#tab-userdata-order" id="tab-userdata-order-label" aria-controls="tab-userdata-order-content" role="tab" aria-selected="false">
      <h3>Rech&shy;nungs&shy;adresse</h3>
    </a>

    <div id="tab-userdata-order-content" aria-labelled-by="tab-userdata-order-label" class="accordion-content" role="tabpanel" aria-hidden="true">

      <p class="form-line form-line-margin form-line-checkbox">
        <input type="checkbox" name="data[adress][inv][diff]" id="input-inv-diff" {% if data.adress.inv.diff %}checked="checked" {% endif %}value="1">
        <label for="input-inv-diff">Abwei&shy;chende Rech&shy;nungs&shy;adresse ver&shy;wenden</label>
      </p>

      <div class="register-shipping-wrapper">

        <p class="form-line form-line-margin">
          <span class="form-short-1of3">
            <label for="input-inv-title">Anrede</label>
            <select id="input-inv-title" name="data[adress][inv][ctid]" autocomplete="section-order shipping honorific-prefix">
              {% for title in titles %}
                <option value="{{ title.ctid }}"{% if title.preset %} selected="selected"{% endif %}>{{ title.name }}</option>
              {% endfor %}
            </select>
          </span>
          <span class="form-short-2of3">
            <label for="input-inv-first_name">Vorname</label>
            <input id="input-inv-first_name" class="{{ markError('first_name','inv') }}" data-msg="{{ getError('first_name','inv') }}" inputtype="latin-name" pattern="\w[\w\d\s.-,]{1,49}" maxlength="50" required="required" type="text" name="data[adress][inv][first_name]" autocorrect="none" autocomplete="section-order shipping given-name" value="{{ data.adress.inv.first_name }}" placeholder="2 - 50 Zeichen erlaubt" mozactionhint="next">
          </span>
        </p>

        <p class="form-line">
          <label for="input-inv-last_name">Name</label>
          <input id="input-inv-last_name" class="{{ markError('last_name','inv') }}" data-msg="{{ getError('last_name','inv') }}" inputtype="latin-name" pattern="\w[\w\d\s.-,]{1,49}" maxlength="50" required="required" type="text" name="data[adress][inv][last_name]" autocorrect="none" autocomplete="section-order shipping family-name" value="{{ data.adress.inv.last_name }}" placeholder="2 - 50 Zeichen erlaubt" mozactionhint="next">
        </p>

        {% if site.register.show_company %}
          <p class="form-line form-line-margin">
            <label for="input-inv-company">Firma</label>
            <input id="input-inv-company" class="{{ markError('company','inv') }}" data-msg="{{ getError('company','inv') }}" type="text" maxlength="100" name="data[adress][inv][company]" autocorrect="none" autocomplete="section-order shipping company" value="{{ data.adress.inv.company }}" placeholder="Beispiel: Musterfirma GmbH" mozactionhint="next">
          </p>
        {% endif %}

        <p class="form-line form-line-margin">
          <label for="input-inv-adress_1">Stra&szlig;e und Hausnummer</label>
          <input id="input-inv-adress_1" class="{{ markError('adress_1','inv') }}" data-msg="{{ getError('adress_1','inv') }}" type="text" maxlength="200" name="data[adress][inv][adress_1]" autocomplete="section-order shipping address-line1" value="{{ data.adress.inv.adress_1 }}" placeholder="4 - 200 Zeichen erlaubt" mozactionhint="next">
        </p>

        {% if site.register.show_adress_2 %}
          <p class="form-line">
            <label for="input-inv-adress_2">Adresszusatz</label>
            <input id="input-inv-adress_2" class="{{ markError('adress_2','inv') }}" data-msg="{{ getError('adress_2','inv') }}" type="text" maxlength="200" name="data[adress][inv][adress_2]" autocomplete="section-order shipping address-line2" value="{{ data.adress.inv.adress_2 }}" placeholder="4 - 200 Zeichen erlaubt" mozactionhint="next">
          </p>
        {% endif %}

        <p class="form-line">
          <span class="form-short-1of3">
            <label for="input-inv-zip"><abbr title="Postleitzahl">PLZ</abbr></label>
            <input id="input-inv-zip" class="{{ markError('zip','inv') }}" data-msg="{{ getError('zip','inv') }}" type="text" maxlength="10" required="required" name="data[adress][inv][zip]" autocomplete="section-order shipping postal-code" value="{{ data.adress.inv.zip }}" placeholder="12345" mozactionhint="next">
          </span>
          <span class="form-short-2of3">
            <label for="input-inv-city">Ort</label>
            <input id="input-inv-city" class="{{ markError('city','inv') }}" data-msg="{{ getError('city','inv') }}" type="text" maxlength="50" name="data[adress][inv][city]" autocomplete="section-order shipping address-level2" value="{{ data.adress.inv.city }}" placeholder="2 - 50 Zeichen erlaubt" mozactionhint="next">
          </span>
        </p>

        {% set country_tel_prefix = "" %}
        <p class="form-line">
          <label for="input-inv-country">Land</label>
          <select id="input-inv-country" class="form-country" name="data[adress][inv][ccid]">
            {% for country in countries %}
              {% set country_selected = (not data.adress.inv and country.preset) or (data.adress.inv.ccid == country.ccid) %}
              <option value="{{ country.ccid }}" data-phone-prefix="{{ country.phone_prefix }}"{% if country_selected %} selected="selected"{% endif %}>{{ country.name }}</option>
              {% if country_selected %}
                {% set country_tel_prefix = country.phone_prefix %}
              {% endif %}
            {% endfor %}
          </select>
        </p>

        <p class="form-line form-line-margin">
          <label for="input-inv-phone_1">Telefon</label>
          <span class="form-line-prefix">+</span>
          <input id="input-inv-phone_1" class="form-phone form-phone-country form-prevent-spinbox {{ markError('phone_1','inv') }}" type="number" min="1" maxlength="5" name="data[adress][inv][phone_1][land]" value="{% if data.adress.inv.phone_1.land %}{{ data.adress.inv.phone_1.land }}{% else %}+{{ country_tel_prefix }}{% endif %}" placeholder="{{ country_tel_prefix }}" mozactionhint="next">
          <input class="form-phone form-phone-prefix form-prevent-spinbox {{ markError('phone_1','inv') }}" type="number" min="1" name="data[adress][inv][phone_1][prefix]" value="{{ data.adress.inv.phone_1.prefix }}" placeholder="1234" mozactionhint="next">
          <input class="form-phone form-phone-number form-prevent-spinbox {{ markError('phone_1','inv') }}" data-msg="{{ getError('phone_1','inv') }}" type="number" min="1" name="data[adress][inv][phone_1][number]" value="{{ data.adress.inv.phone_1.number }}" placeholder="567890" mozactionhint="next">
        </p>

        {% if site.register.show_phone_2 %}
          <p class="form-line">
            <label for="input-inv-phone_2">Telefon 2</label>
            <span class="form-line-prefix">+</span>
            <input id="input-inv-phone_2" class="form-phone form-phone-country form-prevent-spinbox {{ markError('phone_2','inv') }}" type="number" min="1" maxlength="5" name="data[adress][inv][phone_2][land]" value="{% if data.adress.inv.phone_2.land %}{{ data.adress.inv.phone_2.land }}{% endif %}" placeholder="{{ country_tel_prefix }}" mozactionhint="next">
            <input class="form-phone form-phone-prefix form-prevent-spinbox {{ markError('phone_2','inv') }}" type="number" min="1" name="data[adress][inv][phone_2][prefix]" value="{{ data.adress.inv.phone_2.prefix }}" placeholder="1234" mozactionhint="next">
            <input class="form-phone form-phone-number form-prevent-spinbox {{ markError('phone_2','inv') }}" data-msg="{{ getError('phone_2','inv') }}" type="number" min="1" name="data[adress][inv][phone_2][number]" value="{{ data.adress.inv.phone_2.number }}" placeholder="567890" mozactionhint="next">
          </p>
        {% endif %}

        {% if site.register.show_fax %}
          <p class="form-line">
            <label for="input-inv-fax">Telefax</label>
            <span class="form-line-prefix">+</span>
            <input id="input-inv-fax" class="form-phone form-phone-country form-prevent-spinbox {{ markError('fax','inv') }}" type="number" min="1" maxlength="5" name="data[adress][inv][fax][land]" value="{% if data.adress.inv.fax.land %}{{ data.adress.inv.fax.land }}{% endif %}" placeholder="{{ country_tel_prefix }}" mozactionhint="next">
            <input class="form-phone form-phone-prefix form-prevent-spinbox {{ markError('fax','inv') }}" type="number" min="1" name="data[adress][inv][fax][prefix]" value="{{ data.adress.inv.fax.prefix }}" placeholder="1234" mozactionhint="next">
            <input class="form-phone form-phone-number form-prevent-spinbox {{ markError('fax','inv') }}" data-msg="{{ getError('fax','inv') }}" type="number" min="1" name="data[adress][inv][fax][number]" value="{{ data.adress.inv.fax.number }}" placeholder="567890" mozactionhint="next">
          </p>
        {% endif %}

        <p class="form-line form-line-margin">
          <label for="input-inv-email">E-Mail-Adresse</label>
          <input id="input-inv-email" class="{{ markError('email','inv') }}" data-msg="{{ getError('email','inv') }}" type="email" name="data[adress][inv][email]" autocomplete="section-order shipping email" value="{{ data.adress.inv.email }}" placeholder="Beispiel: shop@example.com" mozactionhint="next">
        </p>

      </div> {# .register-shipping-wrapper #}

    </div>

  </li>
</ul>

