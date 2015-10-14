{% spaceless %}
{% if compare_data and compare_data.entries|length %}
  <section id="tarife" class="tariffcompare page-neutral product-type-tariff">
    <h2 class="a11y-header">Unsere Tarife</h2>

    <aside class="tariffcompare-labels tariff product">
      <a class="tariff-limit-details" href="#tariff-more">
        <header>
          <h3 property="name">Tarif</h3>
          <p class="subheadline" property="description" role="presentation">&nbsp;</p>
        </header>
        <div class="price" role="presentation">
          <span>0,00</span>
        </div>
        <dl class="tariff-limits">
          {% for limit in compare_data.entries[0].shop_limits.limits %}
            <dt{% if limit.descr %} title="{{ limit.descr }}"{% endif %}>{{ limit.name }}</dt>
          {% endfor %}
          <dl class="tariff-limit-hidden">
            {% for limit in compare_data.entries[0].shop_limits.limits_hidden %}
              <dt{% if limit.descr %} title="{{ limit.descr }}"{% endif %}>{{ limit.name }}</dt>
            {% endfor %}
          </dl>
        </dl>

        {% if compare_data.has.limits_hidden %}
          <span class="tariff-limit-toggle icon icon-bg-brand icon-plus-small">mehr Info</span>
        {% endif %}
      </a>
    </aside>

    <ul class="list-horizontal list-scroll tarifflist">
      {% for tariff in compare_data.entries %}
        <li class="tariff{% if tariff.peid == compare_settings.products.highlight %} tariff-highlight{% endif %}" typeof="Product">
          {# Weitere Metadaten zum Produkt fuer Suchmaschinen #}
          <link href="http://www.productontology.org/id/Shared_web_hosting_service" property="additionalType">

          <a class="tariff-limit-details" href="#tariff-more">
            {# Name des Tarifs #}
            <header>
              <h3 property="name">{{ tariff.name }}</h3>
              <p class="subheadline" property="description">{{ tariff.descr }}</p>
            </header>

            {# Preis des Produkts #}
            <div class="price" typeof="Offer" property="offers">
              {{ price(tariff.shop_price.price_long,0) }}
            </div>

            {# Limits/Funktionen des Tarifs #}
            <dl class="tariff-limits">
              {#% if tariff.shop_limits.limits|length > 0 %#}
                {% for limit in tariff.shop_limits.limits %}
                  <dt{% if limit.descr %} title="{{ limit.descr }}"{% endif %}>{{ limit.name }}</dt>
                  {{ unit(limit, 'dd') }}
                {% endfor %}
              {#% endif %#}

              {# Limits, die erst nach dem Aufklappen dargestellt werden #}
              <dl class="tariff-limit-hidden">
                {% for limit in tariff.shop_limits.limits_hidden %}
                  <dt{% if limit.descr %} title="{{ limit.descr }}"{% endif %}>{{ limit.name }}</dt>
                  {{ unit(limit, 'dd') }}
                {% endfor %}
              </dl>
            </dl>

            {# Link zum Auf- und Zuklappen der weiteren Limits #}
            {% if compare_data.has.limits_hidden %}
              <span class="tariff-limit-toggle icon icon-bg-brand icon-plus-small">mehr Info</span>
            {% endif %}
          </a>

          {# Aktion "in den Warenkorb legen" #}
          <button class="button button-action add-to-cart" data-product='{"peid":"{{ tariff.peid }}"}' data-peid="{{ tariff.peid }}" data-label-orderable="In den Warenkorb" data-label-in-cart="Im Warenkorb" data-label-unorderable="Nicht bestellbar">In den Warenkorb</button>
        </li>
      {% endfor %}
    </ul>
  </section>
{% endif %}
{% endspaceless %}

