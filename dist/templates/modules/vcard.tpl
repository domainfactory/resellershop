{# Anschrift als vCard #}
<p property="legalName">{% if master.co_name %}{{ master.co_name }}{% else %}{{ master.company }}{% endif %}</p>
<div property="address" typeof="PostalAdress">
  {% spaceless %}
  <p property="streetAdress">
    {{ master.adress_1 }}
    {% if master.adress_2 %}
      <br/>{{ master.adress_2 }}
    {% endif %}
  </p>
  <span property="postalCode">{{ master.zip }}</span>&nbsp;<span property="addressLocality">{{ master.city }}</span> / <span property="address_country">{{ master.country }}</span>
  {% endspaceless %}
</div>

