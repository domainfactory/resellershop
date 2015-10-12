{% spaceless %}
{% for domain in whois %}
  {# Metadaten fuer Warenkorb #}
  {% set domaindata %} data-domain="{{ domain.name }}" data-scid="{{ domain.scid }}" data-product='{{ domain|json_encode() }}'{% endset %}

  {# Ueberschrift TLD #}
  {% if domain.whois.tld == "de" %}
    {% set authlabel = "Auth-Info" %}
  {% else %}
    {% set authlabel = "Auth-Code" %}
  {% endif %}

  {% if domain.status %}
    {# Ergebnisse werden geladen #}
    {% if domain.status == "whois" %}
      {% include "modules/domainsearch_template_loading.tpl" %}

    {# Domain frei #}
    {% elseif domain.status == "free" %}
      <li class="domainsearch-result domainsearch-result-free{% if domain.status == "cart" %} product-in-cart{% endif %}" {{ domaindata }}>
        <label class="domainsearch-price" tabindex="0">
          <h3 property="name">{{ domain.name|e }}</h3>
          {% if domain.price_long is null %}
            <p title="Je nach Tarif bieten wir verschiedene Domainpreise an. Bitte legen Sie einen Tarif in den Warenkorb, um den f&uuml;r diese Domain g&uuml;ltigen Preis zu erfahren.">Preis tarifabh&auml;ngig</p>
          {% else %}
            {% if domain.piid == 0 or (domain.int.price_long == 0) or (domain.int.price_long == domain.price_long) %}
              <p>
                {% if domain.price_default %}ab {% endif %}
                {{ price(domain.price_long) }}
                <span property="duration">{{ interval[domain.piid] }}</span>
                {% if domain.price_default %}*{% endif %}
              </p>
            {% else %}
              <p>
                {% if domain.price_default %}ab {% endif %}
                <s>{{ price(domain.price_long) }}</s>
                {{ price(domain.int.price_long) }}
                <span property="duration">{{ interval[domain.piid] }}</span>
                {% if domain.price_default %}*{% endif %}
              </p>
            {% endif %}
          {% endif %}
          <aside class="domainsearch-action" title="Domain steht zum Kauf frei">
            <span class="button button-action icon icon-plus icon-only"></span>
          </aside>
        </label>
      </li>

    {# Domain im Warenkorb #}
    {% elseif domain.status == "cart" %}
      <li class="domainsearch-result domainsearch-result-in-cart product-in-cart" {{ domaindata }}>
        <label class="domainsearch-price" tabindex="0">
          <h3 property="name">{{ domain.name|e }}</h3>
          {% if domain.price_long is null %}
            <p title="Je nach Tarif bieten wir verschiedene Domainpreise an. Bitte legen Sie einen Tarif in den Warenkorb, um den f&uuml;r diese Domain g&uuml;ltigen Preis zu erfahren.">Preis tarifabh&auml;ngig</p>
          {% else %}
            {% if domain.piid == 0 or (domain.int.price_long == 0) or (domain.int.price_long == domain.price_long) %}
              <p>
                {% if domain.price_default %}ab {% endif %}
                {{ price(domain.price_long) }}
                <span property="duration">{{ interval[domain.piid] }}</span>
                {% if domain.price_default %}*{% endif %}
              </p>
            {% else %}
              <p>
                {% if domain.price_default %}ab {% endif %}
                <s>{{ price(domain.price_long) }}</s>
                {{ price(domain.int.price_long) }}
                <span property="duration">{{ interval[domain.piid] }}</span>
                {% if domain.price_default %}*{% endif %}
              </p>
            {% endif %}
          {% endif %}
          <aside class="domainsearch-action" title="Produkt liegt im Warenkorb. Klicken zum Entfernen">
            <span class="button icon icon-checkbox icon-only" role="presentation"></span>
          </aside>
        </label>
      </li>

    {# Domain belegt, KANN transferiert werden #}
    {% elseif domain.status == "reserved" and domain.orderable != "0" %}
      <li class="domainsearch-result domainsearch-result-transfer{% if domain.status == "cart" %} product-in-cart{% endif %}" {{ domaindata }}>
        <label class="domainsearch-price" tabindex="0">
          <h3 property="name">{{ domain.name|e }}</h3>
          {% if domain.price_long is null %}
            <p title="Je nach Tarif bieten wir verschiedene Domainpreise an. Bitte legen Sie einen Tarif in den Warenkorb, um den f&uuml;r diese Domain g&uuml;ltigen Preis zu erfahren.">Preis tarifabh&auml;ngig</p>
          {% else %}
            {% if domain.piid == 0 or (domain.int.price_long == 0) or (domain.int.price_long == domain.price_long) %}
              <p>
                {% if domain.price_default %}ab {% endif %}
                {{ price(domain.price_long) }}
                <span property="duration">{{ interval[domain.piid] }}</span>
              </p>
            {% else %}
              <p>
                {% if domain.price_default %}ab {% endif %}
                <s>{{ price(domain.price_long) }}</s>
                {{ price(domain.int.price_long) }}
                <span property="duration">{{ interval[domain.piid] }}</span>
                {% if domain.price_default %}*{% endif %}
              </p>
            {% endif %}
          {% endif %}
          <aside class="domainsearch-action" title="Domain transferieren">
            <span class="button button-action icon icon-item-more icon-only" role="presentation"></span>
          </aside>
        </label>
        <div class="domainsearch-transfer" hidden="hidden">
          <h3><span property="name">{{ domain.name|e }}</span> ist belegt.</h3>
          <p>
            Falls Sie der Inhaber dieser Domain sind, haben Sie die M&ouml;glichkeit mittels {{ authlabel }} die Domain zu uns zu transferieren.
          </p>
          <p>
            Mit Klick auf "In den Warenkorb" best&auml;tigen Sie, dass Sie &uuml;ber die Domain {{ domain.name|e }} verf&uuml;gungsberechtigt sind. Bitte beachten Sie, dass <b>ein unberechtigter Providerwechsel zu straf- und zivilrechtlichen Konsequenzen f&uuml;r Sie f&uuml;hren kann</b>.
          </p>
          {% if domain.authcode %}
          <p class="form-line form-line-margin">
            <label for="domainsearch-{{ domain.token }}">
              {% if authlabel == "Auth-Info" %}
                Geben Sie bitte die {{ authlabel }} ein, die
              {% else %}
                Geben Sie bitte den {{ authlabel }} ein, den
              {% endif %}
              Sie von Ihrem bisherigen Provider bei der K&uuml;ndigung der Domain erhalten haben:
            </label>
            <input type="text" maxlength="50" class="domainsearch-authcode" name="authcode" placeholder="{{ authlabel }} f&uuml;r {{ domain.name|e }}" id="domainsearch-{{ domain.token }}" required="required" autofocus="autofocus">
          </p>
          <aside class="notification notification-type-warning domainsearch-authcode-msg" hidden="hidden">
            {% if authlabel == "Auth-Info" %}
              <p><b>Bitte geben Sie eine g&uuml;ltige {{ authlabel }} ein.</b></p>
            {% else %}
              <p><b>Bitte geben Sie einen g&uuml;ltigen {{ authlabel }} ein.</b></p>
            {% endif %}
            <p>Haben Sie Probleme beim Transfer Ihrer Domain? <a href="{{ url("page_contact") }}" target="_blank">Wir helfen Ihnen gerne.</a></p>
          </aside>
          {% endif %}
          <aside class="domainsearch-action">
            <button class="button button-action button-big domainsearch-transfer-confirm" title="Der Transfer wird erst bei Abschluss der Bestellung durchgef&uuml;hrt.">In den Warenkorb</button>
            <button class="button domainsearch-transfer-abort button-lowprio">Abbrechen</button>
          </aside>
        </div>
      </li>

    {# Domain belegt, kann NICHT transferiert werden #}
    {% elseif domain.status == "local" or (domain.status == "reserved" and domain.orderable == "0") %}
      <li class="domainsearch-result domainsearch-result-unavailable{% if domain.status == "cart" %} product-in-cart{% endif %}" {{ domaindata }}>
        <label class="domainsearch-price" tabindex="0">
          <h3 property="name">{{ domain.name|e }}</h3>
          <p>
            nicht transferierbar
          </p>
          <aside class="domainsearch-action" title="Domain ist nicht transferierbar">
            <span class="button button-disabled icon icon-item-more icon-only" role="presentation"></span>
          </aside>
        </label>
        <div class="domainsearch-transfer" hidden="hidden">
          <h3><span property="name">{{ domain.name|e }}</span> kann nicht bestellt werden.</h3>
          <p>
            Diese Domain ist belegt und kann nicht online bestellt werden. Wenden Sie sich bei Fragen hierzu gerne <a href="{{ url("page_contact") }}" target="_blank">an unseren Support</a>.
          </p>
          <aside class="domainsearch-action">
            <button class="button domainsearch-transfer-abort button-lowprio">Schlie&szlig;en</button>
          </aside>
        </div>
      </li>

    {# Belegt/Fehler #}
    {% elseif domain.status == "err" %}
      <li class="domainsearch-result domainsearch-result-unavailable{% if domain.status == "cart" %} product-in-cart{% endif %}" {{ domaindata }}>
        <label class="domainsearch-price" tabindex="0">
          <h3 property="name">{{ domain.name|e }}</h3>
          <p>
            nicht bestellbar
          </p>
          <aside class="domainsearch-action" title="Domain kann nicht bestellt werden">
            <span class="button button-disabled icon icon-item-more icon-only" role="presentation"></span>
          </aside>
        </label>
        <div class="domainsearch-transfer" hidden="hidden">
          <h3><span property="name">{{ domain.name|e }}</span> kann nicht bestellt werden.</h3>
          <p>
            {{ domain.msg }}
          </p>
          <aside class="domainsearch-action">
            <button class="button domainsearch-transfer-abort button-lowprio">Schlie&szlig;en</button>
          </aside>
        </div>
      </li>


    {# Fehler bei der Abfrage #}
    {% else %}
      {% include "modules/domainsearch_template_error.tpl" %}

    {% endif %}
  {% endif %}
{% endfor %}
{% endspaceless %}
