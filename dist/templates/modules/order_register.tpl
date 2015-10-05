{% spaceless %}
<section class="order-register">
  <form class="order-register-form order-form" method="post" action="{{ url("page_register") }}">

    <article class="order-register-userdata order-section">
      <h2>Kunden&shy;daten</h2>
      {% include "modules/order_register_customer.tpl" %}
    </article>

    <article class="order-register-payment order-section">
      <h2>Zah&shy;lungs&shy;informa&shy;tionen</h2>
      {% include "modules/order_register_payment.tpl" %}


      <h2 class="order-section-padding">Weitere Einstel&shy;lungen</h2>

      {# Sprachauswahl nur anzeigen, wenn mehr als eine Sprache zur Auswahl steht #}
      {% if languages|length > 1 %}
        <p class="form-line">
          <label for="order-register-language">Sprache ihres Kundenmen&uuml;s</label>
          <select id="order-register-language" name="data[laid]" autocomplete="section-order language">
            {% for lang in languages %}
              {% if lang.active %}
                <option value="{{ lang.laid }}"{% if lang.preset %} selected="selected"{% endif %}>{{ lang.name }}</option>
              {% endif %}
            {% endfor %}
          </select>
        </p>
      {% else %}
        <input name="data[laid]" type="hidden" value="{{ languages[0].laid }}">
      {% endif %}

      {# Geburtsdatum #}
      {% if site.register.show_birthdate %}
        <p class="form-line form-line-margin">
          <label for="input-birthdate">Ihr Geburtsdatum</label>
          <input id="input-birthdate" type="date" class="{{ markError('birthdate') }}" data-msg="{{ getError('birthdate') }}" pattern="\d{2}\.\d{2}\.(19|20)\d{2}" min="1900-01-01" max="{{ youngest_date_allowed }}" maxlength="10" required="required" name="data[birthdate]" autocomplete="section-order bday" value="{{ data.birthdate }}" placeholder="Beispiel: 22.08.2000" mozactionhint="next">
        </p>
      {% endif %}

      {# Passwörter #}
      <p class="form-line form-line-margin">
        <label for="input-user-password">Passwort f&uuml;r Ihr Kundenmen&uuml;</label>
        <input id="input-user-password" type="password" class="{{ markError('password','user') }}" data-msg="{{ getError('password','user') }}" pattern=".{6,100}" maxlength="100" required="required" name="data[user][password]" autocomplete="off" placeholder="mind. 6 Zeichen" mozactionhint="next">
      </p>
      <p class="form-line">
        <label for="input-user-password2">Passwort wiederholen</label>
        <input id="input-user-password2" type="password" class="{{ markError('password2','user') }}" data-msg="{{ getError('password2','user') }}" pattern=".{6,100}" maxlength="100" required="required" name="data[user][password2]" autocomplete="off" placeholder="mind. 6 Zeichen">
      </p>
    </article>

  </form>
</section>
{% endspaceless %}

