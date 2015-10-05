{% spaceless %}
<section class="tariffspecials {% block tariff_special_class %}page-brand{% endblock tariff_special_class %} product-type-tariff">
  {% block tariff_specials_headline %}
    <h2>&Uuml;berschrift tariff_specials_headline</h2>
  {% endblock tariff_specials_headline %}

  <ul class="list-horizontal">
    {% block tariff_specials_items %}
    <li>
      {# include "components/tariff_special.tpl" #}
    </li>
    {% endblock tariff_specials_items %}
  </ul>

</section>
{% endspaceless %}

