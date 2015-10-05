{% spaceless %}
<footer class="site-footer-imprint page-invert-dark">
  <ul class="list-horizontal imprint-links">
    <li>&copy; {{ site.name.full }}</li>
    {% for i, page in site.nav_imprint.page %}
      <li{% if site.nav_imprint.class[i] %} class="{{site.nav_imprint.class[i]}}"{% endif %}>
        <a href="{{ url(page) }}">
          {{ site.nav_imprint.label[i] }}
        </a>
      </li>
    {% endfor %}
  </ul>
</footer>
{% endspaceless %}

