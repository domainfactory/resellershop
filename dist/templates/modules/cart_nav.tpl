{% include "modules/cart.tpl" %}

{% spaceless %}
<article class="site-cart-price">
  {% if cart.sum_long %}
    <h3>Summe erster Abrechnung</h3>
    <label>
      {{ price(cart.sum_long) }}
    </label>
  {% endif %}

  {% if cart.item_count.all %}
    {% if cart.can_order %}
      <a href="{% if site.register.only_new_customers %}{{ url("page_register") }}{% else %}{{ url("page_login") }}{% endif %}" class="button button-action button-big">Zur Kasse</a>
    {% else %}
      {% if cart.item_count.tariff and not cart.item_count.domain and cart.items.tariff[0].product.need_domain %}
        <span class="button button-disabled button-big">Zur Kasse (ben&ouml;tigt Domain)</span>
      {% elseif cart.item_count.domain and not cart.item_count.tariff %}
        <span class="button button-disabled button-big">Zur Kasse (ben&ouml;tigt Tarif)</span>
      {% else %}
        <span class="button button-disabled button-big">Zur Kasse</span>
      {% endif %}
    {% endif %}
    <a href="{{ url("page_cart") }}" class="button">Warenkorb einsehen</a>
  {% endif %}
</article>
{% endspaceless %}
