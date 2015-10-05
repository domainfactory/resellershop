<div class="contact-address" typeof="Corporation">
  {# Kartenausschnitt #}
  {% spaceless %}
    {% include "modules/contact_map.tpl" %}
  {% endspaceless %}

  {# Anschrift als vCard #}
  <div class="address-vcard">
    {% include "modules/vcard.tpl" %}
  </div>

  {# Telefonnummer #}
  {% spaceless %}
  {% if master.phone_1 %}
    <p class="address-tel">
      Sie haben Fragen? Rufen Sie uns an:
      <a href="tel:{{ master.phone_1|replace({' ':''}) }}" class="icon icon-tel" property="telephone">{{ master.phone_1 }}</a>
      {% if master.fax %}
        <a href="fax:{{ master.fax|replace({' ':''}) }}" class="icon icon-fax" property="faxNumber">{{ master.fax }}</a>
      {% endif %}
    </p>
  {% endif %}

  {% endspaceless %}
</div>

