<noscript class="noscript">
  <section class="notification page-accent">
    <h2>Bitte JavaScript aktivieren!</h2>
    <p>Damit Sie Ihre Wunschdomain bestellen k&ouml;nnen, muss Ihr Browser JavaScript unterst&uuml;tzen.</p>
  </section>
</noscript>

<section id="domains" class="domainsearch domainsearch-index">
  <h2 class="a11y-header">Domainsuche</h2>

  <div class="page-invert">
    {% include "modules/domainsearch_form.tpl" %}
    {% include "modules/domainsearch_highlights.tpl" %}
  </div>


  <div class="page-brand-light">
    {% include "modules/domainsearch_result_wrapper.tpl" %}
    {% include "modules/domainsearch_template_loading.tpl" %}
    {% include "modules/domainsearch_template_error.tpl" %}
  </div>
</section>

