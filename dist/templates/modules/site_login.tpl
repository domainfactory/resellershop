{% spaceless %}
<div class="site-login">
  <header>
    <button class="button toggle-login">ausblenden</button>
    <h2>Kundenlogin</h2>
    <p class="subheadline">Bitte geben Sie Ihre Zugangsdaten ein.</p>
  </header>

  <form class="site-login-form" target="_blank" action="{{ url(site.url.rp) }}" method="POST" name="_login" accept-charset="ISO-8859-1">
    <p class="form-line">
      <label for="site-login-user">Benutzername</label>
      <input id="site-login-user" type="text" name="_login[user]" required="required" autocorrect="none" autocapitalize="none" mozactionhint="next">
    </p>

    <p class="form-line">
      <label for="site-login-password">Passwort</label>
      <input id="site-login-password" type="password" name="_login[pass]" pattern=".{3,100}" required="required" autocorrect="none" autocapitalize="none">
    </p>

    <p class="form-line form-line-margin">
      <button type="submit" class="button button-action" name="_login[action]" value="auth"> Login </button>
    </p>
  </form>

  <form class="site-login-forgotpw" target="_blank" action="{{ url(site.url.rp) }}" method="POST" name="_login" accept-charset="ISO-8859-1">
    <p class="form-line">
      <button type="submit" class="button" name="_login[action]" value="forgot"> Passwort vergessen? </button>
    </p>
  </form>
</div>
{% endspaceless %}
