{% extends "modules/modal.tpl" %}

{% block modal_class %}page-invert-dark icon icon-alert icon-align{% endblock modal_class %}

{% block modal_title %}
  Fehler beim Initialisieren wichtiger Systemeinstellungen
{% endblock modal_title %}

{% block modal_descr %}
  {{ message }}
{% endblock modal_descr %}

{% block modal_more %}
  Wir sind bald wieder f&uuml;r Sie da.
{% endblock %}

{% block modal_buttons %}
  {% if site.contact.url %}
    <a href="{{ site.contact.url }}" class="button button-action button-big" autofocus="autofocus">Zur&uuml;ck zur Hauptseite</a>
  {% endif %}
{% endblock modal_buttons %}

