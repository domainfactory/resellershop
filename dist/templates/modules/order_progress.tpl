{% spaceless %}
<section class="order-progress page-order">
  <h2 class="a11y-header">Bestellverlauf</h2>

  <div class="tabs">
    <ol class="list-tabs list-tabs-numbers list-tabs-ui" role="tablist">
      {% if currentpage == "page_cart" %}
        <li><span aria-selected="true" role="tab">Ihr Waren&shy;korb</span></li>
      {% else %}
        <li><a href="{{ url("page_cart") }}" aria-selected="false" role="tab">Ihr Waren&shy;korb</a></li>
      {% endif %}
      {% if not site.register.only_new_customers %}
        {% if currentpage == "page_login" %}
          <li><span aria-selected="true" role="tab">Anmel&shy;dung</span></li>
        {% elseif currentpage != "page_cart" %}
          <li><a href="{{ url("page_login") }}" aria-selected="false" role="tab">Anmel&shy;dung</a></li>
        {% else %}
          <li><span aria-selected="false" role="tab">Anmel&shy;dung</span></li>
        {% endif %}
      {% endif %}
      {% if currentpage == "page_register" %}
        <li><span aria-selected="true" role="tab">Kunden&shy;daten</span></li>
      {% elseif currentpage != "page_cart" and currentpage != "page_login" %}
        <li><a href="{{ url("page_register") }}" aria-selected="false" role="tab">Kunden&shy;daten</a></li>
      {% else %}
        <li><span aria-selected="false" role="tab">Kunden&shy;daten</span></li>
      {% endif %}
      {% if currentpage == "page_checkout" %}
        <li><span aria-selected="true" role="tab">Zusammen&shy;fassung</span></li>
      {% else %}
        <li><span aria-selected="false" role="tab">Zusammen&shy;fassung</span></li>
      {% endif %}
    </ol>
  </div>
</section>

{% if currentpage != "page_checkout" %}
  <div class="page-messages">
    {% include "modules/messages.tpl" %}
  </div>
{% endif %}
{% endspaceless %}
