<section class="site-footer-social page-invert-dark" typeof="Person">
  <h2 class="a11y-header">Soziale Netzwerke</h2>
  <link property="url" href="{{ site.contact.url }}">
  <ul class="list-horizontal social-links">
    {% if site.contact.facebook_url %}
      <li>
        <a class="icon icon-facebook" href="{{ site.contact.facebook_url }}" rel="nofollow" property="sameAs">
          <h3>Liken Sie uns!</h3>
          <p>und erhalten Sie Updates</p>
        </a>
      </li>
    {% endif %}
    {% if site.contact.twitter_url %}
      <li>
        <a class="icon icon-twitter" href="{{ site.contact.twitter_url }}" rel="nofollow" property="sameAs">
          <h3>Folgen Sie uns</h3>
          <p>auf Twitter</p>
        </a>
      </li>
    {% endif %}
    {% if site.contact.gplus_url %}
      <li>
        <a class="icon icon-gplus" href="{{ site.contact.gplus_url }}" rel="nofollow" property="sameAs">
          <h3>F&uuml;gen Sie {{ site.name.short }}</h3>
          <p>Ihren Kreisen hinzu</p>
        </a>
      </li>
    {% endif %}
    {% if site.contact.linkedin_url %}
      <li>
        <a class="icon icon-linkedin" href="{{ site.contact.linkedin_url }}" rel="nofollow" property="sameAs">
          <h3>Vernetzen Sie sich</h3>
          <p>mit uns auf LinkedIn</p>
        </a>
      </li>
    {% endif %}
  </ul>
</section>
