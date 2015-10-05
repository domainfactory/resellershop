{% include "modules/cart.tpl" %}

<article class="site-cart-price">
  {% if cart.sum_long %}
    <h3>Summe erster Abrechnung</h3>
    <label>
      {{ price(cart.sum_long) }}
    </label>
  {% endif %}
</article>

<article class="site-cart-secure">
  <h3>Sicher einkaufen</h3>
  <p>Unser Shop wird durch unser SSL-Zertifikat gesch&uuml;tzt. Haben Sie Ihr Zertifikat bereits?</p>
</article>
