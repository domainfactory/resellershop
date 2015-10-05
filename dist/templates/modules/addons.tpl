{% spaceless %}
<ul class="product-group-list product-type-addon">
  {% for addon_group in addon_groups.groups %}
    {% if addon_group.visible == 1 and addon_group.entrys|length > 0 %}
      <li class="product-group {% if addon_group.orderable_entrys == 0 %}product-group-unorderable{% endif %}">
        <h3 property="name">{{ addon_group.name }}</h3>
        <ul class="product-list column-multiple-wrapper column-multiple-2">
          {% for addon in addon_group.entrys %}
            <li class="product product-addon{% if addon.img != "" %} product-hasimage{% endif %} {% if addon.orderable.amount == 0 %}product-unorderable{% endif %} column" typeof="Product">
              <label>
                <h4 property="name">{{addon.name}}</h4>

                {# Produktpreis #}
                <p class="product-price" property="offers" typeof="Offer">
                  {{ price(addon.shop_price.price_long) }}
                  {{ interval[addon.shop_price.piid] }}
                </p>

                {# Produktbild #}
                {% if addon.img != "" %}
                  <img src="{{ site.url.rp }}datapool/{{ addon.img }}" alt="" class="product-image" role="presentation" property="image">
                {% endif %}

                {# Addon-Beschreibung #}
                {% if addon.descr != "" %}
                  <p class="product-descr" property="description">
                    {{ addon.descr }}
                  </p>
                {% endif %}

                {# Addon-Limits #}
                {% if addon.limits|length %}
                  <dl class="product-limits">
                    {% for limit in addon.limits %}
                      <dt{% if limit.descr %}$ title="{{ limit.descr }}"{% endif %}>{{ limit.name }}</dt>
                      {{ unit(limit, 'dd') }}
                    {% endfor %}
                  </dl>
                {% endif %}

                {# Bestellbutton #}
                <p class="product-actions">
                  {% if addon.orderable.amount == 0 %}
                    <span class="button button-disabled add-to-cart" data-product='{"peid":"{{ addon.peid }}"}' data-peid="{{ addon.peid }}" data-label-in-cart="im Warenkorb" data-label-unorderable="nicht bestellbar" title="{{ addon.orderable.msg }}">nicht bestellbar</span>
                  {% else %}
                    <button class="button button-action add-to-cart" data-product='{"peid":"{{ addon.peid }}"}' data-peid="{{ addon.peid }}" data-label-orderable="Hinzuf&uuml;gen" data-label-in-cart="im Warenkorb" data-label-unorderable="nicht bestellbar">Hinzuf&uuml;gen</button>
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

