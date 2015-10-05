{% spaceless %}
<section class="tariffspecials page-brand">
  <h2 class="a11y-header">Aktuelle Angebote</h2>

  <ul class="list-horizontal">
    <li>
      <a href="{{ url("page_tarife") }}" class="tariff-special page-brand-light icon icon-big-top icon-pic-suitcase" typeof="Product">

        {# Ueberschrift #}
        <header>
          <h3 property="name">Business-Hosting</h3>
          <p property="description" class="subheadline">F&uuml;r anspruchsvolle Homepages & Shopsystem</p>
        </header>

        {# Liste der Funktionen eines Tarifs #}
        <ul class="tariff-features">
          <li>15 Domains inklusive</li>
          <li>100 GB Webspace</li>
          <li>Traffic-Flat inkl.</li>
          <li>50 Datenbanken</li>
          <li>5.000 E-Mail-Konten</li>
          <li>PHP5, CGI, Ruby u.v.m.</li>
        </ul>

        {# Preis des Tarifs #}
        <div class="tariff-price" typeof="Offer">
          <span class="price-value">{{ price(19.99) }}</span>
          <span class="price-duration">im Monat</span>

          {# Button mit mehr Details #}
          <span class="button">Mehr</span>
        </div>
      </a>
    </li>
    <li>
      <a href="{{ url("page_domains") }}" class="tariff-special page-brand-light icon icon-big-top icon-pic-speaker" typeof="Product">

        {# Ueberschrift #}
        <header>
          <h3 property="name">Aktuelle Preisaktion</h3>
          <p property="description" class="subheadline">Nutzen Sie die Chance und sparen Sie kr&auml;ftig!</p>
        </header>

        {# Liste der Funktionen eines Tarifs #}
        <ul class="tariff-features">
          <li>.de-Domains</li>
          <li>.at-Domains</li>
          <li>.com-Domains</li>
          <li>.eu-Domains</li>
          <li>.bayern-Domains</li>
          <li>u.v.a. Endungen reduziert</li>
        </ul>

        {# Preis des Tarifs #}
        <div class="tariff-price" typeof="Offer">
          <span class="price-value">30&nbsp;%</span>
          <span class="price-duration">und mehr sparen</span>

          {# Button mit mehr Details #}
          <span class="button">Mehr</span>
        </div>
      </a>
    </li>
  </ul>
</section>
{% endspaceless %}

