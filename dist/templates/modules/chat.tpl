<section class="site-chat">
  <h2 class="a11y-header">Live-Chat</h2>

  {# Chat nicht besetzt #}
  <article class="site-chat-closed">
    <header>
      <h3>Wir sind gerade offline</h3>
    </header>

    <aside>
      <h4>Unseren Chat erreichen Sie zu folgenden Zeiten</h4>
      <p>Mo-Fr 08:00 - 18:00 Uhr</p>
      <p>Sa 08:00 - 12:00 Uhr</p>
    </aside>

    <form class="site-chat-login-form">
      <h4>Schreiben Sie uns eine Nachricht</h4>

      <p class="form-line">
        <label for="site-chat-login-user">Ihr Name</label>
        <input id="site-chat-login-user" type="text" required="required" maxlength="50">
      </p>

      <p class="form-line">
        <label for="site-chat-login-mail">Ihre E-Mail-Adresse</label>
        <input id="site-chat-login-mail" type="email" required="required" maxlength="100">
      </p>

      <p class="form-line">
        <label for="site-chat-login-subject">Betreff</label>
        <input id="site-chat-login-subject" type="text" required="required" maxlength="100">
      </p>

      <p class="form-line form-line-margin">
        <label class="hidden-label" for="site-chat-form-message">Ihre Nachricht an uns</label>
        <textarea id="site-chat-form-message" placeholder="Ihre Nachricht an uns" rows="5" cols="50"></textarea>
      </p>

      <p class="form-line form-line-margin form-button-line">
        <button class="button button-action">Nachricht senden</button>
      </p>
    </form>
  </article>

  {# Anmeldung #}
  <article class="site-chat-login site-chat-active">
    <header>
      <h3>Willkommen im Live-Chat</h3>
    </header>

    <form class="site-chat-login-form">
      <p class="form-line">
        <label for="site-chat-login-user">Ihr Name</label>
        <input id="site-chat-login-user" type="text" required="required" maxlength="50">
      </p>

      <p class="form-line">
        <label for="site-chat-login-mail">Ihre E-Mail-Adresse</label>
        <input id="site-chat-login-mail" type="email" required="required" maxlength="100">
      </p>

      <p class="form-line site-chat-login-notice">
        Bitte hinterlassen Sie Ihre E-Mail-Adresse, damit wir Sie im Falle einer
        Verbindungs&shy;unterbrechung weiterhin in Kontakt bleiben k&ouml;nnen.
      </p>

      <p class="form-line form-line-margin form-button-line">
        <button class="button button-action">Chat beginnen</button>
      </p>
    </form>
  </article>

  {# Verbindung zum Chat verloren #}
  <article class="site-chat-offline">
    <p>Verbindung verloren</p>
  </article>


  {# Konversationsfenster #}
  <article class="site-chat-conversation">
    <header>
      <h3>mediaserver Live-Chat</h3>
      <p class="site-chat-unread">(23 ungelesen)</p>
    </header>

    <aside typeof="Person">
      <img src="images/portrait03.png" alt="Foto von Maximilian Mittermeier-Hinterhuber" class="site-chat-avatar" property="image">
      <h4 property="name">Maximilian Mittermeier-Hinterhuber</h4>
      <p property="jobTitle">mediaserver Support</p>
      <a href="mailto:max@mediaserver.de" property="email" class="icon icon-mail">Max</a>
    </aside>

    <ol class="site-chat-history">
      <li class="site-chat-msg site-chat-msg-host">
        <time>10:45:20</time>
        <blockquote>
          Ist Titan-Hosting perfekt f&uuml;r Blocks?
          <cite property="name">Maximilian</cite>
        </blockquote>
      </li>
      <li class="site-chat-msg site-chat-msg-guest">
        <time>10:46:44</time>
        <blockquote>
          Sit quam fugit officiis a eos perspiciatis ex. Corporis doloremque vitae placeat officiis ea. Rem et officiis in dolore accusamus!
          Sit quam fugit officiis a eos perspiciatis ex. Corporis doloremque vitae placeat officiis ea. Rem et officiis in dolore accusamus!
          <cite property="name">Lisa-Maria Magdalena Vordergeier-Bleistiftspitzerin</cite>
        </blockquote>
      </li>
      <li class="site-chat-typing-host">
        <span property="name">Maximilian</span> tippt gerade.
      </li>
      <li class="site-chat-info">
        Sende Nachricht...
      </li>
    </ol>

    <form class="site-chat-input">
      <textarea id="site-chat-input-src"></textarea>
      <button class="site-chat-emote">Emoticons hinzuf&uuml;gen</button>
    </form>

    <div class="site-chat-emotes">
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
      <button class="site-chat-emoticon emote-happy">:)</button>
      <button class="site-chat-emoticon emote-sad">:(</button>
    </div>

  </article>
</section>
