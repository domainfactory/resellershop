{% spaceless %}
<table class="domain-prices-top-list">
  <thead>
    <tr>
      <th class="tld">Domain&shy;endung</th>
      <th class="price">Preis {{ interval[tlds.interval_piid] }}</th>
    </tr>
  </thead>
  <tbody class="domain-prices-top-list-separator" role="presentation">
    <tr>
      <td></td>
      <td></td>
    </tr>
  </tbody>
  <tbody>
    {% for group in tlds.groups %}
      {% if group.preset %}
        {% for ptid in group.entries|slice(0, page.top_tld.max_tlds) %}
          {% set domain = tlds.entries[ptid] %}
          <tr>
            <td class="tld" title="{{ domain.descr }}">.{{ domain.name }}</td>
            {% if domain.piid == 0 or (domain.int_shop_price.price_long == domain.shop_price.price_long) %}
              <td class="price domain-prices-price">
                ab {{ price(domain.shop_price.price_long) }}*
              </td>
            {% else %}
              <td class="price domain-prices-price">
                ab <s>{{ price(domain.shop_price.price_long) }}</s>
                <b>{{ price(domain.int_shop_price.price_long) }}</b>*
              </td>
            {% endif %}
          </tr>
        {% endfor %}
      {% endif %}
    {% endfor %}
  </tbody>
  <tfoot class="domain-prices-top-list-footer" role="presentation">
    <tr>
      <td class="tld"></td>
      <td class="price"></td>
    </tr>
  </tfoot>
</table>
{% endspaceless %}
