{% spaceless %}
<section id="domains" class="domainsearch">
  <div class="page-neutral-brand-text">
    <article class="claim">
      <h2><b>Wunschdomain</b> pr&uuml;fen und sichern</h2>
      <p class="subheadline">
        Sichern Sie sich Ihre Traumdomains noch heute oder ziehen Sie mit Ihrer registrierten Domain um.
      </p>
    </article>

    {% include "modules/domainsearch.tpl" %}
  </div>

  <div class="page-neutral-light">
    {% include "modules/domainsearch_result_wrapper.tpl" %}
    {% include "modules/domainsearch_template_loading.tpl" %}
    {% include "modules/domainsearch_template_error.tpl" %}
  </div>
</section>
{% endspaceless %}
