{% spaceless %}
<div class="page-brand-text-light">
  <section class="domain-prices column-multiple-wrapper column-multiple-2 column-mainbox">
    <article class="column column-main">
      <h1>Der <b>preiswerte</b> Weg sich im Internet zu pr&auml;sentieren</h1>

      <p>
      Registrieren Sie noch heute Ihre eigene Domain und profitieren Sie von unseren g&uuml;nstigsten Hosting-Paketen.
      </p>

      <aside class="column-subsection">
        <h3>Profitieren Sie von unseren aktuellen Domainaktionen</h3>
        <p>
          Nutzen Sie die Chance und registrieren/transferieren Sie Ihre Wunsch-Domains zu {{ site.name.title }}. Ausgesuchte TLDs zu g&uuml;nstigen Preisen.
        </p>
      </aside>
    </article>

    <article class="column">
      {% include "modules/domain_prices_highlights.tpl" %}
    </article>
  </section>
  <section class="domain-prices column-multiple-wrapper column-multiple-2 column-mainbox">
    <article class="column column-main">
      <p class="form-line form-line-button js">
        <button class="button button-big button-icon icon icon-plus domain-prices-toggle section-toggle" data-toggle='{"target":".domain-prices-list","activeClass":"icon-minus","inactiveClass":"icon-plus","activeLabel":"Alle Preise ausblenden","inactiveLabel":"Alle Preise ansehen"}'>Alle Domainpreise anzeigen</button>
      </p>
    </article>
    <article class="column"></article>
  </section>
</div>

<div class="page-brand-text-bright">
  {% include "modules/domain_prices.tpl" %}
</div>
{% endspaceless %}

