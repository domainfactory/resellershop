{# Nur anzeigen, wenn die Daten der Tarife ausgelesen werden koennen #}
{% if tariffcompare and tariffcompare.entries|length %}
  <section class="tariff-table-section page-brand-light list-scroll">
    <article class="tariff-table-activate-wrapper js">
      <button class="tariff-table-activate section-toggle button button-big button-icon icon icon-plus" data-toggle='{"target":".tariff-table-wrapper","activeClass":"icon-minus","inactiveClass":"icon-plus"}'>Alle Tarife vergleichen (Detailansicht)</button>
    </article>
    <article class="tariff-table-wrapper">
      {% include "modules/tariff_table.tpl" with {'compare_data': tariffcompare, 'compare_settings': product_settings} %}
    </article>
  </section>
{% endif %}

