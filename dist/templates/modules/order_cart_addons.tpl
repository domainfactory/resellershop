{% if addon_groups.orderable_count %}
  <section class="cart-addons">
    {# Auflistung der Addons #}
    <article class="order-section order-section-has-sidebar">
      <h2>Zusatz&shy;leis&shy;tungen</h2>
      {% include "modules/addons.tpl" %}
    </article>

    {# Ab x Addons Warenkorb-Seitenleiste anzeigen #}
    {% if addon_groups.orderable_count > 3 %}
      <section class="site-cart-wrapper site-cart-sidebar make-sticky" data-sticky-top="16">
        {% include "modules/order_cart_sidebar.tpl" %}
      </section>
    {% endif %}
  </section>
{% endif %}
