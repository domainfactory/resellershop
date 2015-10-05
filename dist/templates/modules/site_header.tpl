{% spaceless %}
{% include "modules/site_login.tpl" %}

{# Logo #}
<header class="site-header-sticky" typeof="Organization" role="banner">
  {# Eigener Link zum Logo (ohne Sprites) fuer soziale Netzwerke #}
  <link property="logo" href="images/logo/logo.svg">

  <a href="{{ site.url.base }}" class="site-logo"><h1>{{ site.name.title }}</h1></a>
</header>

{# Kontakt-Navigation #}
<aside class="site-header-contact">
  <h2 class="a11y-header">Kontakt</h2>

  <ul class="list-horizontal">
    {% if master.phone_1 %}
      <li class="list-low-priority">
        <a class="icon icon-tel-text" href="tel:{{ master.phone_1|replace({' ':''}) }}" property="telephone">
          {{ master.phone_1|join("") }}
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
</aside>

{# Leiste der Hauptnavigation #}
<nav class="site-nav">
  <h2 class="a11y-header">Navigation</h2>

  {# Button fuer mobile Endgeraete #}
  <p class="site-nav-mobileonly site-nav-toggle">
    <button>Zeige Men&uuml;</button>
  </p>

  {# Hauptnavigation #}
  <ul class="site-nav-list" role="menubar">
    {% for i, page in site.nav_main.page %}
      <li{% if site.nav_main.class[i] %} class="{{site.nav_main.class[i]}}"{% endif %} role="presentation">
        <a href="{{ url(page) }}" {% if currentpage == site.nav_main.page[i] %} aria-current="true"{% endif %} role="menuitem">
          {{ site.nav_main.label[i] }}
        </a>
      </li>
    {% endfor %}
  </ul>

  {# Anzeige des aktuellen Warenkorbzustands #}
  <p class="site-nav-cart">
    <a href="{{ url("page_cart") }}" class="site-nav-cart-itemcount toggle-cart-preview"><span></span></a>
  </p>
</nav>

<section class="site-cart-wrapper site-cart-preview cart-wrapper">
  {% include "modules/cart_nav.tpl" %}
</section>
{% endspaceless %}
