{% spaceless %}
<section class="contact-us column-multiple-wrapper column-multiple-2 column-mainbox page-brand-text-bright">

  <article class="column column-main has-form-line-big" id="contact-us">
    <h2>Kontaktieren Sie uns</h2>

    <p>
      Sie haben eine Frage zu unserem Angebot? {{ site.name.short }} ist für Sie da und steht Ihnen kompetent zur Seite. Wir freuen uns auf Sie und Ihre Kontaktaufnahme!
    </p>

    {% include "modules/contact_form.tpl" %}
  </article>

  <article class="column contact-data-wrapper" typeof="LocalBusiness">
    <h3>Anschrift</h3>

    {% include "modules/vcard.tpl" %}
    <dl class="contact-data contact-phone">
      {% if master.phone_1 %}
        <dt>Telefon</dt>
        <dd><a href="tel:{{ master.phone_1|join('') }}" property="telephone">{{ master.phone_1|join(' ') }}</a></dd>
      {% endif %}

      {% if master.fax %}
        <dt>Telefax</dt>
        <dd><a href="fax:{{ master.fax }}" property="faxNumber">{{ master.fax|join(' ') }}</a></dd>
      {% endif %}

      {% if master.email %}
        <dt>E-Mail</dt>
        <dd><a href="mailto:{{ master.email }}" property="email">{{ master.email }}</a></dd>
      {% endif %}
    </dl>


    <h3>B&uuml;rozeiten</h3>
    {% include "modules/opening_hours.tpl" %}


    <h3>Bankverbindung</h3>
    <dl class="contact-data contact-bank">
      {% if master.bank_name %}
        <dt>Bank</dt>
        <dd>{{ master.bank_name }}</dd>
      {% endif %}
      {% if master.sepa_iban %}
        <dt>IBAN</dt>
        <dd>{{ master.sepa_iban|split('', 4)|join(' ') }}</dd>
      {% endif %}
      {% if master.sepa_bic %}
        <dt>BIC</dt>
        <dd>{{ master.sepa_bic }}</dd>
      {% endif %}
    </dl>
  </article>

</section>
{% endspaceless %}

