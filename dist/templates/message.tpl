{% for message in messages %}
  <p class="notification notification-type-{{ message.type|default('warn') }}">{{ message.msg }}</p>
{% endfor %}
