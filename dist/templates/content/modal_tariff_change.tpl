{% extends "modules/modal.tpl" %}

{% block modal_class %}page-invert-dark icon icon-alert icon-align{% endblock modal_class %}

{% block modal_title %}
Tarif&shy;wechsel durch&shy;f&uuml;hren?
{% endblock modal_title %}

{% block modal_descr %}
Sie haben bereits einen Tarif in Ihren Warenkorb gelegt. M&ouml;chten Sie wirklich den Tarif "{{ tariff.name }}" in den Warenkorb legen?
{% endblock modal_descr %}

{% block modal_more %}
  {% if alerts|length %}
    <p>Der Tarifwechsel hat folgende Auswirkungen auf Ihren Warenkorb:</p>
    <ul class="tariff-change-alerts">
      {% for alert in alerts %}
        {# Anzahl des Artikels wird reduziert #}
        {% if alert.status == "reduced" %}
          <li>
            <span class="tariff-change-label">
              {% if alert.norm != "domain" %}{{ alert.amount }}{% endif %}
              <b>{{ alert.name }}</b>
            </span>
            <span class="tariff-change-effect"> {% if alert.amount == 1 %}wird{% else %}werden{% endif %} entfernt</span>
          </li>

        {# Domainkontingent aendert sich #}
        {% elseif alert.status == "change_dc" %}
          <li>
            <b class="tariff-change-label">{{ alert.name }}</b>:
            <span class="tariff-change-effect"> Domainpreis &auml;ndert sich</span>
          </li>

        {# Sonstige Aenderungen #}
        {% else %}
          <li>
            <b>{{ alert.name }}</b>
          </li>
        {% endif %}
      {% endfor %}
    </ul>
  {% endif %}
{% endblock modal_more %}

{% block modal_buttons %}
  <p><button class="button button-big button-action tariff-sign modal-window-close" data-product='{"peid":"{{ tariff.peid }}"}' data-peid="{{ tariff.peid }}">Ja, Tarif "{{ tariff.name }}" in Warenkorb legen</button></p>
  <p><button class="button tariff-decline modal-window-close">Nein, bestehenden Tarif beibehalten</button></p>
{% endblock %}
