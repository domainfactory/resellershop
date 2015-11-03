{% extends "modules/modal.tpl" %}

{% block modal_class %}page-brand-invert{% endblock modal_class %}

{% block modal_title %}
  {% if tariff.need_domain %}
    Bestellen Sie jetzt Ihre Wunschdomain!
  {% else %}
    Holen Sie noch mehr aus Ihrem Tarif heraus!
  {% endif %}
{% endblock modal_title %}

{% block modal_descr %}
  {% if tariff.need_domain %}
    <p>Damit Sie Ihren "{{ tariff.name }}" bestellen k&ouml;nnen, m&uuml;ssen Sie eine Domain in den Warenkorb legen.</p>
  {% else %}
    <p>Erweitern Sie Ihren "{{ tariff.name }}" mit noch mehr Funktionen.</p>
  {% endif %}
{% endblock modal_descr %}

{% block modal_more %}
  {% if not tariff.need_domain %}
    <p>Bestellen Sie jetzt Domains und Addons von {{ site.name.title }}.</p>
  {% endif %}
{% endblock %}

{% block modal_buttons %}
  <p class="form-line">
    <a href="{{ url("page_domains") }}" class="button button-action button-big" autofocus="autofocus">Wunschdomain abfragen</a>
    &nbsp;
  {% if not tariff.need_domain %}
    <a href="{{ url("page_addons") }}" class="button button-action button-big">Addon hinzuf&uuml;gen</a>
  {% endif %}
  </p>
  <p><button class="button modal-window-close">Nein, danke</button></p>
{% endblock modal_buttons %}

