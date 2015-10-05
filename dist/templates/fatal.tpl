<!DOCTYPE html>
<html class="shop" lang="de-DE">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <title>{% block page_title %}{{ page.title }} - {{ site.name.short }}{% endblock page_title %}</title>
  <!--[if lt IE 9]><script>(function(){var t=['section','article','details','aside','footer','header','dialog','abbr','nav','main','summary'],l=t.length;for(var i=0;i<l;i++){document.createElement(t[i]);}}());</script><![endif]-->
  <link rel="stylesheet" href="css/shop.css">
  {% block page_styles %}{% endblock page_styles %}
  <meta content="width=device-width,height=device-height,initial-scale=1,minimum-scale=0.375" name="viewport">
</head>
<body class="no-js" vocab="https://schema.org">
  {% block page_header %}
    {% include "modules/site_header.tpl" %}
  {% endblock page_header %}

  <main class="page">
    {% include "content/modal_fatal.tpl" %} 
  </main>

  {% block page_footer %}
    {% include "modules/site_footer.tpl" %}
  {% endblock page_footer %}

  <section class="notifications"></section>

  {% block page_scripts %}
    <script src="js/shop.js"></script>
  {% endblock page_scripts %}
</body>
</html>

