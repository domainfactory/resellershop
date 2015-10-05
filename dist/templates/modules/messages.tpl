{% for msg in _msgs %}
  {% if msg.fld %}
    <a href="#input{% if msg.parent %}-{{ msg.parent }}{% endif %}-{{ msg.fld }}" 
        title="Durch Klick auf diesen Hinweis fokussieren Sie direkt das Eingabefeld"
        class="notification notification-field-link notification-type-{{ msg.type }}">{{ msg.msg }}</a>
  {% else %}
    <div class="notification notification-type-{{ msg.type }}">{{ msg.msg }}</div>
  {% endif %}
{% endfor %}

