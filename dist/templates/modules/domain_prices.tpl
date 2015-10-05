{% spaceless %}
<article class="domain-prices-list">

  <ul class="accordion accordion-open-first" aria-multiselectable="true" data-active-class="icon icon-bg-brand icon-minus" data-inactive-class="icon icon-bg-brand icon-plus">
    {% for group in tlds.groups %}
      {% if group.entries|length %}
        <li>
          <a class="accordion-title" href="#group-{{ group.ptgid }}">
            <h4>{{ group.name }}</h4>
          </a>
          <div class="accordion-content">
            <header>
              <p property="name">Domainendung</p>
              <p property="description"></p>
              <p class="domain-prices-price">Preis pro Jahr</p>
              <p class="domain-prices-extra">Einrichtung</p>
            </header>
            <ul id="group-{{ group.ptgid }}" class="domain-prices-domains">
              {% for ptid in group.entries %}
                {% set domain = tlds.entries[ptid] %}
                <li>
                  <p property="name">.{{ domain.name }}</p>
                  {% if domain.descr != (domain.name ~ " Domain") and domain.descr != domain.name %}
                    <p property="description">{{ domain.descr }}</p>
                  {% endif %}
                  {% if domain.piid == 0 or (domain.int_shop_price.price_long == domain.shop_price.price_long) %}
                    <p class="domain-prices-price">
                      ab {{ price(domain.shop_price.price_long) }}*
                    </p>
                  {% else %}
                    <p class="domain-prices-price">
                      ab <s>{{ price(domain.shop_price.price_long) }}</s>
                      <b>{{ price(domain.int_shop_price.price_long) }}</b>*
                    </p>
                  {% endif %}
                  {% if domain.setup %}
                    <p class="domain-prices-extra{% if not domain.setup.sum_long %} domain-prices-extra-empty{% endif %}">
                      {% if domain.setup.sum_long %}
                        <span class="domain-prices-extra-label">+ Einrichtung </span>
                        {{ price(domain.setup.sum_long) }}
                      {% else %}
                        -
                      {% endif %}
                    </p>
                  {% endif %}
                </li>
              {% endfor %}
            </ul>
          </div>
        </li>
      {% endif %}
    {% endfor %}
  </ul>

  {% include "content/domain_price_tariff_notice.tpl" %}
</article>
{% endspaceless %}

