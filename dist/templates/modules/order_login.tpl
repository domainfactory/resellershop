<section class="order-login order-section">
  <article class="order-login-register">
    <h2>Neukunde</h2>
    <p>
      Sie sind noch kein Kunde bei {{ site.name.short }}? Dann möchten wir Sie bitten, dass Sie sich registrieren und im n&auml;chsten Schritt Ihre vollst&auml;ndigen Kundendaten eingeben.
    </p>

    <p class="form-line form-line-margin form-button-line">
      <a href="{{ url('page_register') }}" class="button button-big" autofocus="autofocus">Registrieren</a>
    </p>
  </article>

  <article class="order-login-existing">
    <h2>Bereits Kunde</h2>
    <p>
      Sie sind bereits Kunde bei {{ site.name.short }}? Dann loggen Sie sich bitte mit Ihrem bekannten Benutzernamen sowie dazugeh&ouml;rigem Passwort ein.
    </p>

    <form class="order-login-form order-form" method="post" action="{{ url('page_login') }}">
      <p class="form-line">
        <label for="order-login-name">Benutzername</label>
        <input id="order-login-name" name="_login[user]" type="text" required="required" autocorrect="none" autocapitalize="none">
      </p>
      <p class="form-line">
        <label for="order-login-password">Ihr Passwort</label>
        <input id="order-login-password" name="_login[password]" type="password" required="required" autocorrect="none" autocapitalize="none">
      </p>
      <p class="form-line form-line-margin form-button-line">
        <button class="button button-big" type="submit">Einloggen</button>
      </p>
    </form>
    <form class="site-login-form" target="_blank" action="{{ url(site.url.rp) }}" method="POST" name="_login" accept-charset="ISO-8859-1">
      <p class="form-line">
        <button type="submit" class="button" name="_login[action]" value="forgot"> Passwort vergessen? </button>
      </p>
    </form>
  </article>
</section>
