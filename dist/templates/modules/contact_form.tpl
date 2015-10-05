{% spaceless %}
<form class="contact-form" method="POST" action="#contact-form">
  <input type="hidden" name="return_to" value="{{ currentpage }}" />
  {# Name #}
  <p class="form-line">
    <label class="hidden-label" for="contact-form-name">Ihr Name</label>
    <input id="input-name" type="text" class="{{ markError('name') }}" data-msg="{{ getError('name') }}" placeholder="{% block contact_form_name %}Ihr Name{% endblock contact_form_name %}" name="name" value="{{ mail.name }}" autocomplete="section-contact shipping name" mozactionhint="next">
  </p>

  {# E-Mail #}
  <p class="form-line">
    <label class="hidden-label" for="contact-form-mail">Ihre E-Mail-Adresse</label>
    <input id="input-mail" type="email" class="{{ markError('mail') }}" data-msg="{{ getError('mail') }}" placeholder="{% block contact_form_mail %}Ihre E-Mail-Adresse{% endblock contact_form_mail %}" name="mail" value="{{ mail.mail }}" autocomplete="section-contact shipping email" mozactionhint="next">
  </p>

  {# Telefonnr. (nur Kontakt-Seite) #}
  <p class="form-line form-line-big form-line-optional">
    <label class="hidden-label" for="contact-form-tel">Ihre Telefonnummer</label>
    <input id="input-tel" type="tel" class="{{ markError('tel') }}" data-msg="{{ getError('tel') }}" placeholder="{% block contact_form_tel %}Ihre Telefonnummer (optional){% endblock contact_form_tel %}" name="tel" value="{{ mail.tel }}" autocomplete="section-contact shipping tel" mozactionhint="next">
  </p>

  {# Firma (nur Kontakt-Seite) #}
  <p class="form-line form-line-big form-line-optional">
    <label class="hidden-label" for="contact-form-company">Firma</label>
    <input id="input-company" type="text" class="{{ markError('company') }}" data-msg="{{ getError('company') }}" placeholder="{% block contact_form_company %}Firma (optional){% endblock contact_form_company %}" name="company" value="{{ mail.company }}" autocomplete="section-contact shipping company" mozactionhint="next">
  </p>

  {# Betreff #}
  <p class="form-line">
    <label class="hidden-label" for="contact-form-subject">Betreff</label>
    <input id="input-subject" type="text" class="{{ markError('subject') }}" data-msg="{{ getError('subject') }}" placeholder="{% block contact_form_subject %}Betreff{% endblock contact_form_subject %}" name="subject" value="{{ mail.subject }}" mozactionhint="next">
  </p>

  {# Nachricht #}
  <p class="form-line form-line-margin">
    <label class="hidden-label" for="contact-form-message">Ihre Nachricht an uns</label>
    <textarea id="input-message" class="{{ markError('message') }}" data-msg="{{ getError('message') }}" placeholder="{% block contact_form_message %}Ihre Nachricht an uns{% endblock contact_form_message %}" name="message" rows="5" cols="50" type="text">{{ mail.message }}</textarea>
  </p>

  {# Absende-Button #}
  <p class="form-line form-line-margin form-button-line">
    <button class="button" type="submit">{% block contact_form_submit %}Senden{% endblock contact_form_submit %}</button>
  </p>
</form>
{% endspaceless %}

