{% spaceless %}
<div class="page-invert-light">
  <section class="aboutus column-multiple-wrapper column-multiple-3 column-mainbox">

    <article class="column">
      <h2>Vieles inklusive</h2>
      <p>Bei {{site.name.short}} sind folgende Leistungen stets enthalten:</p>
      <ul>
        <li class="icon icon-bg-brand icon-checkbox-small">E-Mail-Speicherplatz</li>
        <li class="icon icon-bg-brand icon-checkbox-small">Auswahl zwischen zahlreichen gTLDs</li>
        <li class="icon icon-bg-brand icon-checkbox-small">Geld-zur&uuml;ck-Garantie</li>
        <li class="icon icon-bg-brand icon-checkbox-small">garantierte Verf&uuml;gbarkeit mit 99,99%</li>
      </ul>
    </article>

    <article class="column column-main">
      <h2><b>Drei Punkte</b> die f&uuml;r uns sprechen</h2>

      <div class="tabs">
        {% include "content/index_aboutus_tabs.tpl" %}
      </div>

    </article>

    <article class="column">
      <h2>Erste Hilfe</h2>

      <ul class="accordion" data-active-class="icon icon-bg-brand icon-minus-small" data-inactive-class="icon icon-bg-brand icon-plus-small">
        <li>
          <a class="accordion-title" href="#tab-firstaid-website">
            <h3>Was ist Webhosting?</h3>
          </a>
          <div id="tab-firstaid-website-content" class="accordion-content">
            <p>Unter Webhosting oder Hosting versteht man Dienstleistungen, die Speicherplatz zur Verf&uuml;gung stellen, auf welchem Daten einer Website abgelegt werden.</p>
            <p>F&uuml;r eine eigene Webseite ben&ouml;tigen Sie Speicherplatz sowie eine Domain.</p>
          </div>
        </li>
        <li>
          <a class="accordion-title" href="#tab-firstaid-mail">
            <h3>Was ist eine Domain?</h3>
          </a>
          <div id="tab-firstaid-mail-content" class="accordion-content">
            <p>Eine Domain oder Domainname entspricht &uuml;blicherweise der Adresse einer Internetseite, z.B. {{ site.contact.url }}</p>
          </div>
        </li>
        <li>
          <a class="accordion-title" href="#tab-firstaid-domain">
            <h3>Was ist ein FTP-Account?</h3>
          </a>
          <div id="tab-firstaid-domain-content" class="accordion-content">
            <p>Die Abk&uuml;rzung FTP bedeutet "File Transfer Protocol" und bezeichnet das Protokoll, mit welchem Daten von einem lokalen Computer auf den Speicherplatz des Webhosting-Paketes &uuml;bertragen werden.</p>
          </div>
        </li>
        <li>
          <a class="accordion-title" href="#tab-firstaid-server">
            <h3>Was ist ein Auth-Code (Auth-Info)?</h3>
          </a>
          <div id="tab-firstaid-server-content" class="accordion-content">
            <p>F&uuml;r den Domaintransfer zu einem anderen Registrar ben&ouml;tigt der zuk&uuml;nftige Registrar einen sogenannten Auth-Code.</p>
            <p>Dieser Auth-Code dient als Password f&uuml;r die Domain und wird Ihnen vom aktuellen Registrar ausgestellt.</p>
          </div>
        </li>
        <li>
          <a class="accordion-title" href="#tab-firstaid-what">
            <h3>Welche Zahlungs&shy;m&ouml;glich&shy;keiten bietet {{ site.name.title }} an?</h3>
          </a>
          <div id="tab-firstaid-what-content" class="accordion-content">
            <p>Wir bieten Ihnen folgende Zahlungs&shy;m&ouml;glich&shy;keiten an:</p>
            <ul>
              <li>SEPA-Lastschrift</li>
              <li>Kreditkarte</li>
              <li>Rechnungs&shy;zahlung</li>
            </ul>
          </div>
        </li>
      </ul>
    </article>
  </section>
</div>
{% endspaceless %}

