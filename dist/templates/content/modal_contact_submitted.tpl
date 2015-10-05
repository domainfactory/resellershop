{% extends "modules/modal.tpl" %}

{% block modal_class %}page-brand-invert icon icon-checkbox icon-align{% endblock modal_class %}

{% block modal_title %}
  Ihre Anfrage wurde abgesendet.
{% endblock modal_title %}

{% block modal_descr %}
  Herzlichen Dank f&uuml;r Ihre Nachricht. Wir werden uns schnellst&shy;m&ouml;glich bei Ihnen melden.
{% endblock modal_descr %}

{% block modal_buttons %}
  <p><button class="button button-action button-big modal-window-close" autofocus="autofocus">Fenster schlie&szlig;en</button></p>
  {% if site.contact.url %}
    <p><a href="{{ url("page_index") }}" class="button">Zur&uuml;ck zur Startseite</a></p>
  {% endif %}
{% endblock modal_buttons %}


