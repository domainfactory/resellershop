{% spaceless %}
<header>
  {% if cart.item_count.all %}
    <h2>{{ cart.item_count.all }} Produkt{% if cart.item_count.all != 1 %}e{% endif %} im Warenkorb</h2>
  {% else %}
    <h2>Ihr Warenkorb ist leer</h2>
  {% endif %}
  <button class="button toggle-cart-preview">schlie&szlig;en</button>
</header>

<div class="site-cart-scroller">
  {# Keine Artikel im Warenkorb #}
  {% if cart.item_count.all == 0 %}
    <article class="cart-empty" aria-hidden="false">
      <p class="cart-message">Sie haben noch keine Artikel in den Warenkorb gelegt.</p>
      <p class="cart-message">Ist vielleicht bei <a href="{{ url("page_tarife") }}">einem unserer Tarife</a> etwas f&uuml;r Sie dabei?
    </article>

  {# Artikel im Warenkorb #}
  {% else %}

    {# Tarife #}
    {% if cart.item_count.tariff %}
      <article class="cart-tariff">
        <h3>Ihr gew&auml;hlter Tarif</h3>
        <ul class="cart-list cart-tariff-list">
          {% for tariff in cart.items.tariff %}
            <li class="cart-item cart-tariff-item" tabindex="0" data-product='{"scid":"{{ tariff.scid }}","norm":"tariff"}' data-scid="{{ tariff.scid }}" title="{{ tariff.product.name }}">
              <span property="name">{{ tariff.product.name }}</span>
              {% if tariff.int %}
                <p class="cart-price">{{ price(tariff.int.price_long) }}</p>
              {% else %}
                <p class="cart-price">{{ price(tariff.price.all_long) }}</p>
              {% endif %}
              {% if cart.can_del_tariff %}
                <button class="button icon button-icon icon-only icon-align icon-close remove-from-cart" title="entfernen" data-peid="{{ tariff.peid }}"></button>
              {% endif %}
            </li>
          {% endfor %}
        </ul>
      </article>
    {% endif %}

    {# Domains #}
    {% if cart.item_count.domain or cart.tariff_needs_domain %}
      <article class="cart-domains">
        <h3>
          {% if cart.item_count.domain == 1 %}
            Ihre Wunschdomain
          {% elseif cart.item_count.domain == 0 %}
            Ihre Wunschdomains
          {% else %}
            Ihre {{ cart.item_count.domain }} Wunschdomains
          {% endif %}
        </h3>
        {% if cart.tariff_needs_domain %}
          <p class="cart-message">
            <a href="{{ url("page_domains") }}" class="cart-has-requirements">Domain im Tarif inklusive. Jetzt suchen!</a>
          </p>
        {% elseif not cart.item_count.tariff %}
          <p class="cart-message cart-has-requirements">Domainpreise sind vom Tarif abh&auml;ngig!</p>
        {% endif %}
        <ul class="cart-list cart-domain-list">
          {% for domain in cart.items.domain %}
            <li class="cart-item cart-domain-item" tabindex="0" data-product='{"scid":"{{ domain.scid }}","norm":"domain","name":"{{ domain.attribute.name }}"}' data-scid="{{ domain.scid }}" title="{{ domain.attribute.name }}">
              <span property="name" title="{{ domain.attribute.name }}">{{ domain.attribute.name }}</span>
              {% if cart.item_count.tariff %}
                {% if domain.int %}
                  <p class="cart-price">{{ price(domain.int.price_long) }}</p>
                {% else %}
                  <p class="cart-price">{{ price(domain.price.all_long) }}</p>
                {% endif %}
              {% endif %}
              <button class="button icon button-icon icon-only icon-align icon-close remove-from-cart" title="entfernen" data-peid="{{ domain.peid }}"></button>
            </li>
          {% endfor %}
        </ul>
      </article>
    {% endif %}

    {# Addons #}
    {% if cart.item_count["add-on"] %}
      <article class="cart-addons">
        <h3>
          {% if cart.item_count["add-on"] == 1 %}
            Ihre Zusatzleistung
          {% else %}
            Ihre {{ cart.item_count["add-on"] }} Zusatzleistungen
          {% endif %}
        </h3>
        <ul class="cart-list cart-addon-list">
          {% for addon in cart.items["add-on"] %}
            <li class="cart-item cart-addon-item" tabindex="0" data-product='{"scid":"{{ addon.scid }}","amount":"{{ addon.amount }}","norm":"add-on"}' data-scid="{{ addon.scid }}" title="{{ addon.product.name }}">
              <input class="cart-addon-count" type="number" step="1" min="1" max="999" value="{{ addon.amount }}" maxlength="3">
              <span property="name">{{ addon.product.name }}</span>
              {% if addon.int %}
                <p class="cart-price">{{ price(addon.int.price_long) }}</p>
              {% else %}
                <p class="cart-price">{{ price(addon.price.all_long) }}</p>
              {% endif %}
              <button class="button icon button-icon icon-only icon-align icon-close remove-from-cart" title="entfernen" data-peid="{{ addon.peid }}"></button>
            </li>
          {% endfor %}
        </ul>
      </article>
    {% endif %}

    {# Sonstige #}
    {% if cart.item_count.normaly %}
      <article class="cart-articles">
        <h3>
          {% if cart.item_count.normaly == 1 %}
            Weiteres Produkt
          {% else %}
            {{ cart.item_count.normaly }} weitere Produkte
          {% endif %}
        </h3>
        <ul class="cart-list cart-article-list">
          {% for article in cart.items.normaly %}
            <li class="cart-item cart-article-item" tabindex="0" data-product='{"scid":"{{ article.scid }}","amount":"{{ article.amount }}","norm":"normaly"}' data-scid="{{ article.scid }}" title="{{ article.product.name }}">
              {% if article.attribute.is_contained is not defined %}
                <input class="cart-article-count" type="number" step="1" min="1" max="999" value="{{ article.amount }}" maxlength="3">
              {% endif %}
              <span property="name" title="{{ article.product.name }}">{{ article.product.name }}</span>
              {% if article.int %}
                <p class="cart-price">{{ price(article.int.price_long) }}</p>
              {% else %}
                <p class="cart-price">{{ price(article.price.all_long) }}</p>
              {% endif %}
              {% if article.attribute.is_contained is not defined %}
                <button class="button icon button-icon icon-only icon-align icon-close remove-from-cart" title="entfernen" data-peid="{{ article.peid }}"></button>
              {% endif %}
            </li>
          {% endfor %}
        </ul>
      </article>
    {% endif %}
  {% endif %}
</div>
{% endspaceless %}
