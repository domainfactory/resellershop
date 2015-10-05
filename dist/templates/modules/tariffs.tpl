{% spaceless %}
<ul class="product-group-list product-type-tariff">
  {% for tariff_group in tariff_groups %}
    {% if tariff_group.visible == 1 and tariff_group.entrys|length > 0 %}
      <li class="product-group">
        <h3 property="name">{{ tariff_group.name }}</h3>
        <ul class="product-list column-multiple-wrapper column-multiple-2">
          {% for tariff in tariff_group.entrys %}
            <li class="product product-tariff{% if tariff.img != "" %} product-hasimage{% endif %} {% if tariff.orderable.amount == 0 %}product-unorderable{% endif %} column" typeof="Product">
              <label>
                <h4 property="name">{{tariff.name}}</h4>

                {# Produktpreis #}
                <p class="product-price" property="offers" typeof="Offer">
                  {{ price(tariff.shop_price.price_long) }}
                  {{ interval[tariff.shop_price.piid] }}
                </p>

                {# Produktbild #}
                {% if tariff.img != "" %}
                  <img src="{{ site.url.rp }}datapool/{{ tariff.img }}" alt="" class="product-image" role="presentation" property="image">
                {% endif %}

                {# Beinhaltete Produkte #}
                {% if tariff.contained|length %}
                  <ul class="product-contained-list">
                    {% for contained in tariff.contained %}
                      <li class="product-contained">
                        <p class="product-contained-name"{% if contained.descr %} title="{{ contained.descr }}"{% endif %}>{{ contained.name }}</p>
                        <p class="product-contained-price">{{ price(contained.shop_price.price_long) }}</p>
                      </li>
                    {% endfor %}
                  </ul>
                {% endif %}

                {# Tarifbeschreibung #}
                {% if tariff.descr != "" %}
                  <p class="product-descr" property="description">
                    {{ tariff.descr }}
                  </p>
                {% endif %}

                {# Tarif-Limits #}
                {% if tariff.limits|length %}
                  <dl class="product-limits">
                    {% for limit in tariff.limits %}
                      <dt{% if limit.descr %}$ title="{{ limit.descr }}"{% endif %}>{{ limit.name }}</dt>
                      {{ unit(limit, 'dd') }}
                    {% endfor %}
                  </dl>
                {% endif %}

                {# Bestellbutton #}
                <p class="product-actions">
                  {% if tariff.orderable.amount == 0 %}
                    <span class="button button-disabled add-to-cart" title="{{ tariff.orderable.msg }}" data-peid="{{ tariff.peid }}" data-label-orderable="in den Warenkorb" data-label-in-cart="im Warenkorb" data-label-unorderable="nicht bestellbar">nicht bestellbar</span>
                  {% else %}
                    <button class="button button-action add-to-cart" data-product='{"peid":"{{ tariff.peid }}"}' data-peid="{{ tariff.peid }}" data-label-orderable="in den Warenkorb" data-label-in-cart="im Warenkorb" data-label-unorderable="nicht bestellbar">in den Warenkorb</button>
                  {% endif %}
                </p>
              </label>
            </li>
          {% endfor %}
        </ul>
      </li>
    {% endif %}
  {% endfor %}
</ul>
{% endspaceless %}

