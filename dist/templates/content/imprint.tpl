{% spaceless %}
<section class="imprint text-only" typeof="Corporation">
  <h1>Impressum</h1>

  <aside>
    <p>Angaben gem&auml;&szlig; <a href="http://www.gesetze-im-internet.de/tmg/__5.html" target="_blank">&sect;&nbsp;5&nbsp;<abbr title="Telemediengesetz">TMG</abbr></a>:</p>
  </aside>

  <div class="imprint-vcard">
    {% include "modules/vcard.tpl" %}
  </div>

  {% if master.phone_1 or master.fax or master.email %}
    <dl class="imprint-address-list">
      {% if master.phone_1 %}
        <dt><abbr title="Telefonnummer">Telefon</dt>
        <dd property="telephone">{{ master.phone_1|join("&nbsp;") }}</dd>
      {% endif %}
      {% if master.fax %}
        <dt><abbr title="Telefaxnummer">Fax</dt>
        <dd property="faxNumber">{{ master.fax|join("&nbsp;") }}</dd>
      {% endif %}
      {% if master.email %}
        <dt><abbr title="E-Mail-Adresse">E-Mail</dt>
        <dd><a href="mailto:{{ master.email }}" property="email">{{ master.email }}</a></dd>
      {% endif %}
    </dl>
  {% endif %}

  <dl class="imprint-list">
    {% if master.first_name and master.last_name %}
      <div property="employee" typeof="Person">
        <dt property="jobTitle">Gesch&auml;fts&shy;f&uuml;hrer</dt>
        <dd><span property="givenName">{{ master.first_name }}</span>&nbsp;<span property="familyName">{{ master.last_name }}</span></dd>
      </div>
    {% endif %}

    {% if master.tr_number %}
      <dt>Handels&shy;register</dt>
      <dd>{{ master.tr_number }}</dd>
    {% endif %}

    {% if master.ust_idnr %}
      <dt><abbr title="Umsatzsteuer-Identifikationsnummer">Ust.-ID-Nr.</abbr></dt>
      <dd property="vatID">{{ master.ust_idnr }}</dd>
    {% endif %}

    {% if master.tax_number %}
      <dt>Steuer&shy;nummer</dt>
      <dd property="taxID">{{ master.tax_number }}</dd>
    {% endif %}

    <div property="employee" typeof="Person">
      <dt property="jobTitle">Datenschutz&shy;beauftragter</dt>
      <dd><span property="givenName">{{ master.first_name }}</span>&nbsp;<span property="familyName">{{ master.last_name }}</span>, <a href="mailto:{{ master.email }}" property="email">{{ master.email }}</a></dd>
    </div>
  </dl>

  <p>
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </p>

  <p>
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </p>

  <p>
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </p>

  <p>
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </p>
</section>
{% endspaceless %}


