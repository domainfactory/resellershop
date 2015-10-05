<section class="order-buttons order-section">
  <h2 class="a11y-header">Bestell&shy;fort&shy;schritt</h2>

  <p class="order-button-line">
    {# Warenkorbseite #}
    {% if currentpage == "page_cart" %}

      {# Sind Produkte im Warenkorb? #}
      {% if cart.item_count.all %}
        {% if cart.can_order %}
          <a href="{% if site.register.only_new_customers %}{{ url("page_register") }}{% else %}{{ url("page_login") }}{% endif %}" class="button button-action button-big order-forward">Zur Kasse</a>
        {# Bestellung nicht möglich #}
        {% else %}
          {% if cart.item_count.tariff and not cart.item_count.domain and cart.items.tariff[0].product.need_domain %}
            <a href="#" class="button button-disabled button-big">Zur Kasse (ben&ouml;&shy;tigt Domain)</a>
          {% elseif cart.item_count.domain and not cart.item_count.tariff %}
            <a href="#" class="button button-disabled button-big">Zur Kasse (ben&ouml;&shy;tigt Tarif)</a>
          {% else %}
            <a href="#" class="button button-disabled button-big order-forward">Zur Kasse</a>
          {% endif %}
        {% endif %}
      {% endif %}
      <a href="{{ url("page_index") }}" class="button order-back">Zur&uuml;ck</a>

    {% else %}
      {# Bestellabschluss #}
      {% if currentpage == "page_checkout" %}
        {% if cart.can_order %}
        <button class="button button-action button-big order-forward" data-submit-form="order-checkout-agb">Zahlungs&shy;pflich&shy;tig bestellen</button>
        {% else %}
          <button class="button button-disabled button-big" disabled="disabled">Zahlungs&shy;pflich&shy;tig bestellen</button>
        {% endif %}
        <a href="{{ url("page_register") }}" class="button order-back">Zur&uuml;ck</a>

      {# Vertragsdaten #}
      {% else %}
        <button class="button button-action button-big order-forward" data-submit-form="order-register-form">Fort&shy;fahren</button>
        <a href="{{ url("page_cart") }}" class="button order-back">Zur&uuml;ck</a>
      {% endif %}
    {% endif %}
  </p>
</section>
