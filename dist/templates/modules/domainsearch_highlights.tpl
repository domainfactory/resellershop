{% spaceless %}
<article class="domainsearch-highlights domainsearch-highlight-links">
  <ul class="list-horizontal">
    {% for i, tld in tlds.highlights %}
    <li typeof="Product">
      <a href="#" typeof="Offer">
        <span property="name">.{{ tld.name }}</span>
        ab {{ price(tld.shop_price.price_long) }}
      </a>
    </li>
    {% endfor %}
  </ul>
</article>
{% endspaceless %}

