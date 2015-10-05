<section class="cart-overview order-section">
  <h2>Ihr Warenkorb</h2>
  {% set cart_editable = true %}
  <div class="cart-overview-articles">
    {% include "modules/cart_articles.tpl" %}
  </div>
</section>
