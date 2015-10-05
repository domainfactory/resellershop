<!DOCTYPE html>
<html class="shop" lang="de-DE" vocab="https://schema.org/" typeof="Article">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <title>{% block page_title %}{{ page.title }} - {{ site.name.short }}{% endblock page_title %}</title>
  <!--[if lt IE 9]><script>(function(){var t=['section','article','details','aside','footer','header','dialog','abbr','nav','main','summary'],l=t.length;for(var i=0;i<l;i++){document.createElement(t[i]);}}());</script><![endif]-->
  <link rel="stylesheet" href="css/shop.css">
  {% block page_styles %}{% endblock page_styles %}
  <meta content="width=device-width,height=device-height,initial-scale=1,minimum-scale=0.375" name="viewport">
  <meta content="{{ site.colors.main }}" name="theme-color">
  <meta content="{{ site.colors.main }}" name="msapplication-navbutton-color">
  <meta content="{{ site.colors.main }}" name="msapplication-TileColor">
  <meta content="{{ site.name.title }}" name="msapplication-name">
  <meta content="{{ site.name.title }}" name="application-name">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="{% if site.colors.darkmode %}black{% else %}default{% endif %}">
  {% if page.description %}
    <meta name="description" content="{{ page.description }}" />
  {% endif %}
  {# Google+ #}
  <meta property="name" content="{{ page.title }}" />
  {% if page.description %}
    <meta property="description" content="{{ page.description }}" />
  {% endif %}
  <meta property="author" content="{{ site.name.full }}" />
  <meta property="image" content="images/logo/logo.svg" />
  {# Twitter #}
  <meta property="twitter:card" content="summary">
  <meta property="twitter:title" content="{{ page.title }}" />
  {% if page.description %}
    <meta property="twitter:description" content="{{ page.description }}" />
  {% endif %}
  <meta property="twitter:image:src" content="images/logo/logo.svg" />
  {% if site.contact.twitter_name %}
    <meta property="twitter:site" content="@{{ site.contact.twitter_name }}" />
    <meta property="twitter:creator" content="@{{ site.contact.twitter_name }}" />
  {% endif %}
  {# Open Graph #}
  <meta property="og:title" content="{{ page.title }}" />
  {% if page.description %}
    <meta property="og:description" content="{{ page.description }}" />
  {% endif %}
  <meta property="og:type" content="article" />
  <meta property="og:url" content="{{ site.contact.url }}" />
  <meta property="og:image" content="images/logo/logo.svg" />
  {% if site.contact.facebook_name %}
    <meta property="og:site_name" content="{{ site.contact.facebook_name }}" />
  {% endif %}
</head>
<body class="no-js">
  {% block page_header %}
    {% include "modules/site_header.tpl" %}
  {% endblock page_header %}

  <main class="page">
    {% block page_content %}
      {% for module in page.modules.file %}
        {% include module %}
      {% endfor %}
    {% endblock page_content %}
  </main>

  {% block page_footer %}
    {% include "modules/site_footer.tpl" %}
  {% endblock page_footer %}

  {% spaceless %}
  <div class="notifications">
    {% include "modules/messages.tpl" %}
  </div>
  {% endspaceless %}

  {% block page_scripts %}
    <script src="js/shop.js"></script>
  {% endblock page_scripts %}
</body>
</html>
