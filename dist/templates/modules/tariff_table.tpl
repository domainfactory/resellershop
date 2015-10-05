{% spaceless %}
{% if tariffcompare and tariffcompare.entries|length %}
  <table class="tariff-table product-type-tariff">
    {# Produktname #}
    <thead class="tariff-table-head">
      <tr>
        <th class="tariff-table-label">Tarif</th>
        {% for tariff in tariffcompare.entries %}
          <th class="tariff-table-name{% if tariff.peid == product_settings.products.highlight %} tariff-table-highlight{% endif %}" id="tariff-table-{{ tariff.peid }}" title="{{ tariff.descr }}">{{ tariff.name }}</th>
        {% endfor %}
      </tr>
    </thead>

    {% for group in tariffcompare.grouped_limits.groups %}
      {# Bereichueberschrift #}
      <tbody class="tariff-table-group-head">
        <tr>
          <th colspan="{{ tariffcompare.entries|length + 1 }}" id="tariff-table-group-{{ group.name }}">
            <h3>{{ group.name }}</h3>
            {% if group.descr %}
              <p class="subheadline">{{ group.descr }}</p>
            {% endif %}
          </th>
        </tr>
      </tbody>

      {# Einzelne Limits der Gruppe #}
      <tbody class="tariff-table-group">
        {% for group_limit in group.entries %}
          {% set limit = tariffcompare.grouped_limits.limits[group_limit] %}
          <tr>
            <th class="tariff-table-label" id="tariff-table-limit-{{ limit.fld }}" headers="tariff-table-group-{{ group.name }}" title="{{ limit.descr }}">
              {{ limit.name }}
            </th>

            {% for tariff in tariffcompare.entries %}
              <td class="tariff-table-limit{% if tariff.peid == product_settings.products.highlight %} tariff-table-highlight{% endif %}" headers="tariff-table-{{ tariff.peid }} tariff-table-limit-{{ limit[group_limit].fld }}" title="{{ limit.name }}: {{ tariff.name }}">
                {{ unit(tariff.shop_limits.limits_grouped[limit.fld]) }}
              </td>
            {% endfor %}
          </tr>
        {% endfor %}
      </tbody>
    {% endfor %}

    <tfoot class="tariff-table-foot">
      {# Produktname #}
      <tr class="tariff-table-foot-name">
        <th class="tariff-table-label">Tarif</th>
        {% for tariff in tariffcompare.entries %}
          <td class="tariff-table-name{% if tariff.peid == product_settings.products.highlight %} tariff-table-highlight{% endif %}" headers="tariff-table-{{ tariff.peid }} tariff-table-foot-desc" title="{{ tariff.descr }}">{{ tariff.name }}</td>
        {% endfor %}
      </tr>

      {# Produktpreis #}
      <tr class="tariff-table-foot-price">
        <th id="tariff-table-price" class="tariff-table-label">Preis</th>
        {% for tariff in tariffcompare.entries %}
          <td class="tariff-table-price{% if tariff.peid == product_settings.products.highlight %} tariff-table-highlight{% endif %}" headers="tariff-table-{{ tariff.peid }} tariff-table-price">{{ price(tariff.shop_price.price_long) }}</td>
        {% endfor %}
      </tr>

      {# Abrechnung #}
      <tr class="tariff-table-foot-interval">
        <th id="tariff-table-interval" class="tariff-table-label">Abrechnung</th>
        {% for tariff in tariffcompare.entries %}
          <td class="tariff-table-interval{% if tariff.peid == product_settings.products.highlight %} tariff-table-highlight{% endif %}" headers="tariff-table-{{ tariff.peid }} tariff-table-interval">{{ interval[tariff.duration_piid] }}</td>
        {% endfor %}
      </tr>

      {# Button #}
      <tr class="tariff-table-foot-actions">
        <td class="tariff-table-label"></td>
        {% for tariff in tariffcompare.entries %}
          <td class="tariff-table-actions{% if tariff.peid == product_settings.products.highlight %} tariff-table-highlight{% endif %}" headers="tariff-table-{{ tariff.peid }}">
            {# Aktion "in den Warenkorb legen" #}
            <button class="button button-action add-to-cart" data-product='{"peid":"{{ tariff.peid }}"}' data-peid="{{ tariff.peid }}" data-label-orderable="in den Warenkorb" data-label-in-cart="im Warenkorb" data-label-unorderable="nicht bestellbar">in den Warenkorb</button>
          </td>
        {% endfor %}
      </tr>
    </tfoot>

  </table>
{% endif %}
{% endspaceless %}
