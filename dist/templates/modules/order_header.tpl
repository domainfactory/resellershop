{% spaceless %}
{# Logo #}
<header class="site-header-sticky site-header-order" typeof="Organization">
  {# Eigener Link zum Logo (ohne Sprites) fuer soziale Netzwerke #}
  <link property="logo" href="images/logo/logo.svg">

  <a href="{{ site.url.base }}" class="site-logo"><h1>{{ site.name.title }}</h1></a>
</header>

{# Kontakt-Navigation #}
<footer class="site-header-contact">
  <h2 class="a11y-header">Kontakt</h2>

  <ul class="list-horizontal">
    {% if master.phone_1 %}
      <li class="list-low-priority">
        <a class="icon icon-tel-text" href="tel:{{ master.phone_1|replace({' ':''}) }}" property="telephone">
          {{ master.phone_1 }}
        </a>
      </li>
    {% endif %}
    {% if master.fax %}
      <li class="list-low-priority">
        <a class="icon icon-fax-text" href="fax:{{ master.fax|replace({' ':''}) }}" property="faxNumber">
          {{ master.fax }}
        </a>
      </li>
    {% endif %}
    {% if master.email %}
      <li class="list-low-priority">
        <a class="icon icon-mail-text" href="mailto:{{ master.email }}">
          {{ master.email }}
        </a>
      </li>
    {% endif %}
    {% for i, page in site.nav_contact.page %}
      <li>
        <a href="{{ url(page) }}"{% if site.nav_contact.class[i] %} class="{{site.nav_contact.class[i]}}"{% endif %}>
          {{ site.nav_contact.label[i] }}
        </a>
      </li>
    {% endfor %}
  </ul>
</footer>
{% endspaceless %}

