{% spaceless %}
Name:    {{ mail.name }}
{% if mail.company %}
Firma:   {{ mail.company }}
{% endif %}
{% endspaceless %}


{% spaceless %}
{% if mail.mail %}
E-Mail:  {{ mail.mail }}
{% endif %}
{% if mail.tel %}
Telefon: {{ mail.tel }}
{% endif %}
{% endspaceless %}


{% spaceless %}
{% if mail.return_to %}{% if site.url[mail.return_to] %}
Seite:   {{ site.url.base }}{{ site.url[mail.return_to] }}
{% else %}
Seite:   {{ mail.return_to }}
{% endif %}{% endif %}

{% if mail.subject %}
Thema:   "{{ mail.subject }}"
{% else %}
Thema:   (nicht angegeben)
{% endif %}
{% endspaceless %}


Nachricht:
----------
{{ mail.message }}
----------
