{% spaceless %}
<section class="modal-notification-wrapper">
  <article class="modal-notification {% block modal_class %}page-accent{% endblock modal_class %}" role="dialog" aria-labelledby="modal-title" aria-describedby="modal-desc">
    <h1 id="modal-title">{% block modal_title %}{{ modal.title }}{% endblock modal_title %}</h1>
    <p id="modal-desc">{% block modal_descr %}{{ modal.descr }}{% endblock modal_descr %}</p>
    {% block modal_more %}{% endblock modal_more %}
    <div class="form-line form-line-margin">
      {% block modal_buttons %}<button class="button button-big modal-notification-close">{{ modal.button }}</button>{% endblock %}
    </div>
  </article>
</section>
{% endspaceless %}
