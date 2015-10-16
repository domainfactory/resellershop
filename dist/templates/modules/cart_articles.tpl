{% spaceless %}
<article class="cart-wrapper">
  {% if cart.item_count.all %}

    {# Anzahl der Spalten in der Tabelle #}
    {% if cart_editable %}
      {% set column_count = 5 %}
    {% else %}
      {% set column_count = 4 %}
    {% endif %}

    <table>
      {# Tabellen-Überschrift #}
      <thead>
        <tr>
          <th id="cart-count">An&shy;zahl</th>
          <th id="cart-product">Pro&shy;dukt</th>
          <th id="cart-price">Preis</th>
          <th id="cart-interval">Ab&shy;rech&shy;nung</th>
          {% if cart_editable %}
            <th id="cart-remove"></th>
          {% endif %}
        </tr>
      </thead>


      {# TARIFE #}

      {% if cart.item_count.tariff %}
        {% set group_id = "cart-group-tariff" %}
        <tbody>
          <tr class="cart-tariff table-row-head">
            <th class="cart-tariff-header" id="{{ group_id }}" colspan="{{ column_count }}">Ihr gew&auml;hlter Tarif</th>
          </tr>
        </tbody>

        {# Tarife anzeigen #}
        <tbody class="cart-tariff-list cart-list">
          {% for tariff in cart.items.tariff %}
            {% set id = "cart-entry-" ~ tariff.scid %}
            <tr class="cart-item cart-tariff-item{% if tariff.int %} cart-has-int-price{% endif %}" data-product='{"scid":"{{ tariff.scid }}","norm":"tariff"}' data-scid="{{ tariff.scid }}">

              {# Anzahl #}
              <td headers="cart-count {{ group_id }} {{ id }}">1</td>

              {# Name #}
              <th headers="cart-product {{ group_id }}" id="{{ id }}" property="name"><span class="cart-small-data">{{ tariff_amount }} </span>{{ tariff.product.name }}</th>

              {# Preis #}
              <td headers="cart-price {{ group_id }} {{ id }}" class="cart-price-overview">
                {% if tariff.int.piid %}
                  <p class="cart-price-int">
                    {{ price(tariff.int.price_long) }}
                    <span class="cart-small-data" role="presentation"> {{ interval.descr[tariff.int.piid] }}</span>
                  </p>
                  <p class="cart-price-int-post">danach </p>
                {% endif %}
                {{ price(tariff.price.all_long) }}
                <span class="cart-small-data" role="presentation"> {{ interval[tariff.product.duration_piid] }}</span>
              </td>

              {# Abrechnungsintervall #}
              <td headers="cart-interval {{ group_id }} {{ id }}">
                {% if tariff.int.piid %}
                  <p class="cart-price-int">
                    {{ interval.descr[tariff.int.piid] }}
                  </p>
                {% endif %}
                {{ interval[tariff.product.duration_piid] }}
              </td>

              {# Aus Warenkorb entfernen #}
              {% if cart_editable %}
                <td headers="cart-remove {{ group_id }} {{ id }}">
                  {% if cart.can_del_tariff %}
                    <button class="button button-icon icon icon-close remove-from-cart">entfernen</button>
                  {% endif %}
                {% endif %}
              </td>
            </tr>
          {% endfor %}
        </tbody>
      {% endif %}


      {# DOMAINS #}

      {% if cart.item_count.domain %}
        {% set group_id = "cart-group-domains" %}
        <tbody>
          <tr class="cart-domains table-row-head">
            <th class="cart-domain-header" id="{{ group_id }}" colspan="{{ column_count }}">
              {% if cart.item_count.domain == 1 %}
                Ihre Wunschdomain
              {% elseif cart.item_count.domain == 0 %}
                Ihre Wunschdomains
              {% else %}
                Ihre {{ cart.item_count.domain }} Wunschdomains
              {% endif %}
            </th>
          </tr>
        </tbody>

        {# Domains anzeigen #}
        <tbody class="cart-domains-list cart-list">
          {% for domain in cart.items.domain %}
            {% set id = "cart-entry-" ~ domain.scid %}
            <tr class="cart-item cart-domain-item{% if domain.int %} cart-has-int-price{% endif %}" data-product='{"scid":"{{ domain.scid }}","norm":"domain","name":"{{ domain.attribute.name }}"}' data-scid="{{ domain.scid }}">

              {# Anzahl #}
              <td headers="cart-count {{ group_id }} {{ id }}">1</td>

              {# Produktname #}
              <th headers="cart-product {{ group_id }}" id="{{ id }}" property="name">{{ domain.attribute.name }}</th>

              {# Domainpreis #}
              <td headers="cart-price {{ group_id }} {{ id }}" class="cart-price-overview">
                {% if domain.int.piid %}
                  <p class="cart-price-int">
                    {{ price(domain.int.price_long) }}
                    <span class="cart-small-data" role="presentation"> {{ interval.descr[domain.int.piid] }}</span>
                  </p>
                  <p class="cart-price-int-post">danach </p>
                {% endif %}
                {{ price(domain.price.all_long) }}
                <span class="cart-small-data" role="presentation"> {{ interval[domain.product.duration_piid] }}</span>
              </td>

              {# Abrechnung #}
              <td headers="cart-interval {{ group_id }} {{ id }}">
                {% if domain.int.piid %}
                  <p class="cart-price-int">
                    {{ interval.descr[domain.int.piid] }}
                  </p>
                {% endif %}
                {{ interval[domain.product.duration_piid] }}
              </td>

              {# Aus Warenkorb entfernen #}
              {% if cart_editable %}
                <td headers="cart-remove {{ group_id }} {{ id }}">
                  <button class="button button-icon icon icon-close remove-from-cart">entfernen</button>
                </td>
              {% endif %}

            </tr>
          {% endfor %}
        </tbody>
      {% endif %}


      {# ADD-ONS #}

      {% if cart.item_count['add-on'] %}
        {% set group_id = "cart-group-addons" %}
        <tbody>
          <tr class="cart-addons table-row-head">
            <th class="cart-addon-header" id="{{ group_id }}" colspan="{{ column_count }}">
              {% if cart.item_count["add-on"] == 1 %}
                Ihre Zusatzleistung
              {% else %}
                Ihre {{ cart.item_count["add-on"] }} Zusatzleistungen
              {% endif %}
            </th>
          </tr>
        </tbody>

        {# Addons anzeigen #}
        <tbody class="cart-addons-list cart-list">
          {% for addon in cart.items["add-on"] %}
            {% set id = "cart-entry-" ~ addon.scid %}
            {% set addon_amount %}
              {% if (cart_editable) and (addon.attribute.is_contained is not defined) %}
                <input class="cart-addon-count" type="number" min="1" max="999" step="1" maxlength="3" value="{{ addon.amount }}">
              {% else %}
                {{ addon.amount }}
              {% endif %}
            {% endset %}

            <tr class="cart-item cart-addon-item{% if addon.int %} cart-has-int-price{% endif %}" data-product='{"scid":"{{ addon.scid }}","amount":"{{ addon.amount }}","norm":"add-on"}' data-scid="{{ addon.scid }}">

              {# Anzahl #}
              <td headers="cart-count {{ group_id }} {{ id }}">{{ addon_amount }}</td>

              {# Produktname #}
              <th headers="cart-product {{ group_id }}" id="{{ id }}" property="name">
                <span class="cart-small-data">{{ addon_amount }} </span>
                {{ addon.product.name }}
              </th>

              {# Addon-Preis #}
              <td headers="cart-price {{ group_id }} {{ id }}" class="cart-price-overview">
                {% if addon.int.piid %}
                  <p class="cart-price-int">
                    {{ price(addon.int.price_long) }}
                    <span class="cart-small-data" role="presentation"> {{ interval.descr[addon.int.piid] }}</span>
                  </p>
                  <p class="cart-price-int-post">danach</p>
                {% endif %}
                {{ price(addon.price.all_long) }}
                <span class="cart-small-data" role="presentation"> {{ interval[addon.product.duration_piid] }}</span>
              </td>

              {# Abrechnung #}
              <td headers="cart-interval {{ group_id }} {{ id }}">
                {% if addon.int.piid %}
                  <p class="cart-price-int">
                    {{ interval.descr[addon.int.piid] }}
                  </p>
                  <p class="cart-price-int-post">danach</p>
                {% endif %}
                {{ interval[addon.product.duration_piid] }}
              </td>

              {# Aus Warenkorb entfernen #}
              {% if cart_editable %}
                <td headers="cart-remove {{ group_id }} {{ id }}">
                  <button class="button button-icon icon icon-close remove-from-cart">entfernen</button>
                </td>
              {% endif %}
            </tr>
          {% endfor %}
        </tbody>
      {% endif %}


      {# ARTIKEL #}

      {% if cart.item_count.normaly %}
        {% set group_id = "cart-group-article" %}
        <tbody>
          <tr class="cart-article table-row-head">
            <th class="cart-article-header" id="{{ group_id }}" colspan="{{ column_count }}">
              {% if cart.item_count.normaly == 1 %}
                Weiteres Produkt
              {% else %}
                {{ cart.item_count.normaly }} weitere Produkte
              {% endif %}
            </th>
          </tr>
        </tbody>

        {# Artikel anzeigen #}
        <tbody class="cart-article-list cart-list">
          {% for article in cart.items.normaly %}
            {% set id = "cart-entry-" ~ article.scid %}
            {% set article_amount %}
              {% if (cart_editable) and (article.attribute.is_contained is not defined) %}
                <input class="cart-article-count" type="number" min="1" max="999" step="1" maxlength="3" value="{{ article.amount }}">
              {% else %}
                {{ article.amount }}
              {% endif %}
            {% endset %}
            <tr class="cart-item cart-article-item{% if article.int %} cart-has-int-price{% endif %}" data-product='{"scid":"{{ article.scid }}","amount":"{{ article.amount }}","norm":"add-on"}' data-scid="{{ article.scid }}">

              {# Anzahl #}
              <td headers="cart-count {{ group_id }} {{ id }}">{{ article_amount }}</td>

              {# Produktname #}
              <th headers="cart-product {{ group_id }}" id="{{ id }}" property="name">
                <span class="cart-small-data">{{ article_amount }} </span>
                {{ article.product.name }}
              </th>

              {# article-Preis #}
              <td headers="cart-price {{ group_id }} {{ id }}" class="cart-price-overview">
                {% if article.int.piid %}
                  <p class="cart-price-int">
                    {{ price(article.int.price_long) }}
                    <span class="cart-small-data" role="presentation"> {{ interval.descr[article.int.piid] }}</span>
                  </p>
                  <p class="cart-price-int-post">danach</p>
                {% endif %}
                {{ price(article.price.all_long) }}
                <span class="cart-small-data" role="presentation"> {{ interval[article.product.duration_piid] }}</span>
              </td>

              {# Abrechnung #}
              <td headers="cart-interval {{ group_id }} {{ id }}">
                {% if article.int.piid %}
                  <p class="cart-price-int">
                    {{ interval.descr[article.int.piid] }}
                  </p>
                  <p class="cart-price-int-post">danach</p>
                {% endif %}
                {{ interval[article.product.duration_piid] }}
              </td>

              {# Aus Warenkorb entfernen #}
              {% if cart_editable %}
                <td headers="cart-remove {{ group_id }} {{ id }}">
                  {% if article.attribute.is_contained is not defined %}
                  <button class="button button-icon icon icon-close remove-from-cart">entfernen</button>
                  {% endif %}
                </td>
              {% endif %}
            </tr>
          {% endfor %}
        </tbody>
      {% endif %}


      <tbody role="presentation">
        <tr class="table-row-head">
          <th class="cart-summary-header" colspan="{{ column_count }}"></th>
        </tr>
      </tbody>
      <tfoot class="cart-summary">
        <tr>
          <th id="cart-sum" colspan="2">Zwischensumme</th>
          <td headers="cart-price cart-sum">{{ price(cart.sum_net) }}</td>
          <td headers="cart-interval" role="presentation"></td>
          {% if cart_editable %}
            <td role="presentation"></td>
          {% endif %}
        </tr>
        {% if cart.norm_sum_tax %}
          <tr class="cart-tax">
            <th id="cart-norm-tax" colspan="2">+ {{ formatNumber(cart.tax_rate, 1) }}&nbsp;% MwSt. aus {{ price(cart.sum_net) }}</th>
            <td headers="cart-price cart-norm-tax">{{ price(cart.norm_sum_tax) }}</td>
            <td headers="cart-interval" role="presentation"></td>
            {% if cart_editable %}
              <td role="presentation"></td>
            {% endif %}
          </tr>
        {% endif %}
        {% if cart.has_tech_tax %}
          <tr class="cart-tax">
            <th id="cart-tech-tax" colspan="2"><a href="#cart-tech-tax-reference" aria-describedby="cart-tech-tax-reference">+ {{ formatNumber(cart.tech_tax_rate, 1) }}&nbsp;% MwSt. aus {{ price(cart.sum_net) }}*</a></th>
            <td headers="cart-price cart-tech-tax">{{ price(cart.tech_sum_tax) }}</td>
            <td headers="cart-interval" role="presentation"></td>
            {% if cart_editable %}
              <td role="presentation"></td>
            {% endif %}
          </tr>
        {% endif %}
        <tr>
          <th id="cart-summary" colspan="2">Gesamtsumme der ersten Abrechnung</th>
          <td headers="cart-price cart-summary">{{ price(cart.sum_long) }}</td>
          <td headers="cart-interval" role="presentation"></td>
          {% if cart_editable %}
            <td role="presentation"></td>
          {% endif %}
        </tr>
      </tfoot>
    </table>

    {% if cart.has_tech_tax %}
      <p id="cart-tech-tax-reference">
        *) Bei der ausgewiesenen Steuer handelt es sich um eine l&auml;nderspezifische Mehrwertsteuer f&uuml; elektronisch erbrachte Dienstleistungen, welche sich anhand des Ortes des Leistungsempf&auml;ngers ergibt.
      </p>
    {% endif %}
  {% else %}
    <p>Sie haben noch keine Artikel in den Warenkorb gelegt.</p>
  {% endif %}
</article>

{% if not cart.can_order %}
  <div class="modal-notification page-brand-invert icon icon-alert icon-align">
    <h1>Warenkorb unvollst&auml;ndig</h1>
    {% if cart.item_count.tariff and not cart.item_count.domain and cart.items.tariff[0].product.need_domain %}
      <p>Ihr Tarif kann erst bestellt werden, sobald Sie eine Domain in Ihren Warenkorb gelegt haben.</p>
      <p class="form-line form-margin">
        <a href="{{ url("page_domains") }}" class="button button-big button-action" autofocus="autofocus">Wunschdomain suchen</a>
      </p>
    {% elseif cart.item_count.domain and not cart.item_count.tariff %}
      <p>Sie ben&ouml;tigen einen Tarif, um die Bestellung abschlie&szlig;en zu k&ouml;nnen.</p>
      <p class="form-line form-margin">
        <a href="{{ url("page_tarife") }}" class="button button-big button-action" autofocus="autofocus">Tarif ausw&auml;hlen</a>
      </p>
    {% endif %}
  </div>
{% endif %}
{% endspaceless %}

