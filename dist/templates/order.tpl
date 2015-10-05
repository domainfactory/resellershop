<!DOCTYPE html>
<html class="shop-order" lang="de">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="robots" content="nolink,nofollow" />
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
  {% if site.colors.darkmode %}
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
  {% else %}
    <meta name="apple-mobile-web-app-status-bar-style" content="default">
  {% endif %}
</head>
<body class="no-js" vocab="https://schema.org">
  {% block page_header %}
    {% include "modules/order_header.tpl" %}
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

  {% block page_scripts %}
    <script src="js/shop.js"></script>
  {% endblock page_scripts %}
</body>
</html>

