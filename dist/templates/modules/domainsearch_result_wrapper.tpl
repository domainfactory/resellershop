{% spaceless %}
<article class="domainsearch-results product-type-domain"{% if not whois %} hidden="hidden"{% endif %}>
  <h2 class="a11y-header">Ergebnisse Ihrer Domainsuche</h2>

  <div class="domainsearch-results-additional-wrapper">
    <button class="button domainsearch-results-additional" data-tlds='{{ tlds.additional|json_encode() }}'>Weitere Endungen abfragen</button>
  </div>

  <form class="domainsearch-results-form" action="#tariff">
    <ul class="domainsearch-results-list">
      {% if whois %}
        {% include "modules/domainsearch_results.tpl" %}
      {% endif %}
    </ul>
  </form>

  {% include "content/domain_price_tariff_notice.tpl" %}
</article>
{% endspaceless %}
