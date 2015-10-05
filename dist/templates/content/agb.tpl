{% spaceless %}
<section class="terms-of-service">
  {#
    Hinweis zum Anpassen der Vorlagen.
    Entfernen Sie dieses Element, sobald Sie alle Inhalte angepasst haben.
  #}
  <div class="text-only relative">
    <div class="modal-notification page-accent icon icon-alert icon-align">
      <h2>Vorlagen anpassen</h2>
      <p>
      Für eine rechtskonforme auf Ihr Unternehmen passende Datenschutzerklärung ist es notwendig, dass diese von Ihnen individuell erstellt und angelegt wird. Diese Möglichkeit steht Ihnen über das ResellerProfessional-System zur Verfügung.
      </p>
    </div>
  </div>
  {# ENDE Bereich Hinweis zum Anpassen der Vorlagen #}

  {#
    Stand der AGB
    Setzen Sie als Wert dieser Variable das Datum, zu welchem Zeitpunkt die AGB gültig sind.
  #}
  {% set stand %}
    <p>(Stand: 22.10.2015)</p>
  {% endset %}
  {# ENDE Stand der AGB #}


  <header class="text-only">
    <h1>Allgemeine Gesch&auml;fts&shy;bedingungen der {{ site.name.full }}</h1>
  </header>

  <div class="text-only">

<h3 id="1">1.      Allgemeines, Geltungsbereich</h3>

<p id="1-1">1.1.    {{ master.co_name }}, ("Anbieter") erbringt alle Lieferungen und Leistungen ausschließlich auf Grundlage dieser Allgemeinen Geschäftsbedingungen ("AGB"). Handelt es sich beim Kunden um einen Unternehmer (§ 14 BGB) haben diese AGB sowie gegebenenfalls die Domain-Registrierungsbedingungen des Anbieters auch für alle zukünftigen Geschäfte der Vertragsparteien Geltung.</p>

<p id="1-2">1.2.    Von diesen AGB insgesamt oder teilweise abweichende Geschäftsbedingungen des Kunden werden nicht anerkannt, es sei denn, diesen wurde vom Anbieter schriftlich zugestimmt. Die AGB des Anbieters gelten auch dann ausschließlich, wenn in Kenntnis entgegenstehender Geschäftsbedingungen des Kunden vom Anbieter Leistungen vorbehaltlos erbracht werden.</p>


<h3 id="2">2.      Vertragsschluss, Widerrufsrecht</h3>

<p id="2-1">2.1.    Der Antrag des Kunden auf Abschluss des beabsichtigten Vertrages besteht entweder in der Übermittlung des online erstellten Auftragsformulars in schriftlicher Form an den Anbieter oder aber in der Absendung einer elektronischen Erklärung soweit dies im Einzelfall angeboten wird. Der Kunde hält sich an seinen Antrag für 14 Tage gebunden. Der Vertrag kommt erst mit der ausdrücklichen Annahme des Kundenantrags durch den Anbieter oder der ersten für den Kunden erkennbaren Erfüllungshandlung des Anbieters zustande.</p>

<p id="2-2">2.2.    Widerrufsrecht des Kunden nach dem Fernabsatzgesetz</p>

<p>Dem Verbraucher steht bei Fernabsatzverträgen ein Widerrufsrecht zu:</p>
  </div>


  {# Hervorgehobener Bereich #}
  <div class="page-neutral-light" id="widerrufsbelehrung">
    <section class="text-only">
      <h3>Widerrufsbelehrung</h3>

      <h4>Widerrufsrecht</h4>

      <p>Sie haben das Recht, binnen vierzehn Tagen ohne Angabe von Gründen diesen Vertrag zu widerrufen.
      Die Widerrufsfrist beträgt vierzehn Tage ab dem Tag des Vertragsabschlusses.
      Um Ihr Widerrufsrecht auszuüben, müssen Sie uns</p>

      <p>{{ master.co_name }}</p>
      <p>{{ master.adress_1 }}</p>
      <p>{{ master.zip }} {{ master.city }}</p>

      <p>mittels einer eindeutigen Erklärung (z.B. ein mit der Post versandter Brief, Telefax oder E-Mail) über Ihren Entschluss, diesen Vertrag zu widerrufen, informieren. Sie können dafür das beigefügte Muster-Widerrufsformular verwenden, das jedoch nicht vorgeschrieben ist.
      Zur Wahrung der Widerrufsfrist reicht es aus, dass Sie die Mitteilung über die Ausübung des Widerrufsrechts vor Ablauf der Widerrufsfrist absenden. </p>

      <h4>Folgen des Widerrufs</h4>
      <p>Wenn Sie diesen Vertrag widerrufen, haben wir Ihnen alle Zahlungen, die wir von Ihnen erhalten haben, einschließlich der Lieferkosten (mit Ausnahme der zusätzlichen Kosten, die sich daraus ergeben, dass Sie eine andere Art der Lieferung als die von uns angebotene, günstigste Standardlieferung gewählt haben), unverzüglich und spätestens binnen vierzehn Tagen ab dem Tag zurückzuzahlen, an dem die Mitteilung über Ihren Widerruf dieses Vertrags bei uns eingegangen ist. Für diese Rückzahlung verwenden wir dasselbe Zahlungsmittel, das Sie bei der ursprünglichen Transaktion eingesetzt haben, es sei denn, mit Ihnen wurde ausdrücklich etwas anderes vereinbart; in keinem Fall werden Ihnen wegen dieser Rückzahlung Entgelte berechnet.</p>
      <p>Haben Sie verlangt, dass die Dienstleistungen während der Widerrufsfrist beginnen soll, so haben Sie uns einen angemessenen Betrag zu zahlen, der dem Anteil der bis zu dem Zeitpunkt, zu dem Sie uns von der Ausübung des Widerrufsrechts hinsichtlich dieses Vertrags unterrichten, bereits erbrachten Dienstleistungen im Vergleich zum Gesamtumfang der im Vertrag vorgesehenen Dienstleistungen entspricht.</p>

      <p>--- Ende der Widerrufsbelehrung ---</p>
    </section>
  </div>


  {# Hervorgehobener Bereich #}
  <div class="page-neutral-light" id="musterwiderrufsformular">
    <section class="text-only">
      <h3>Muster-Widerrufsformular</h3>

      <p>(Wenn Sie den Vertrag widerrufen wollen, dann füllen Sie bitte dieses Formular aus und senden Sie es zurück.)</p>

      <p>An</p>
      <p>{{ master.co_name }}</p>
      <p>{{ master.adress_1 }}</p>
      <p>{{ master.zip }} {{ master.city }}</p>

      <p>- Hiermit widerrufe(n) ich/wir (*) den von mir/uns (*) abgeschlossenen Vertrag über den Kauf der folgenden Waren (*)/die Erbringung der folgenden Dienstleistung (*)<br>
      - Bestellt am (*)/erhalten am (*)<br>
      - Name des/der Verbraucher(s)<br>
      - Anschrift des/der Verbraucher(s)<br>
      - Unterschrift des/der Verbraucher(s) (nur bei Mitteilung auf Papier)<br>
      - Datum</p>

      <p>(*) Unzutreffendes streichen.</p>

      <p>--- Ende des Muster-Widerrufsformulars ---</p>
    </section>
  </div>

  <div class="text-only">

<h3 id="3">3.      Vertragsgegenstand und Vertragsänderung</h3>

<p id="3-1">3.1.    Der Anbieter stellt dem Kunden entsprechend der jeweiligen Leistungsbeschreibung des gewählten Tarifs ein betriebsbereites, dediziertes Rechnersystem bestehend aus der entsprechenden Hard- und Software oder aber Speicherplatz auf einem virtuellen Webserver zur Verfügung und schuldet sein Bemühen, die vom Kunden vertragsgemäß gespeicherten Daten über das vom Anbieter zu unterhaltende Netz und das damit verbundene Internet für die Öffentlichkeit abrufbar zu machen (insgesamt als "Webhostingleistungen" oder als "Webserver" bezeichnet). Der Kunde hat weder dingliche Rechte an der Serverhardware noch ein Recht auf Zutritt zu den Räumlichkeiten, in denen sich die Serverhardware befindet. Der Anbieter gewährleistet eine Erreichbarkeit von 99,9% im Jahresdurchschnitt. Der Anbieter ist für die Erreichbarkeit nur insoweit verantwortlich, als die Nichtabrufbarkeit auf den von ihm betriebenen Teil des Netzes oder den Webserver selbst zurückzuführen ist.</p>

<p id="3-2">3.2.    Soweit in der jeweiligen Leistungsbeschreibung des gewählten Tarifs eine bestimmte Speicherkapazität genannt ist, gilt diese für den gesamten, gemäß Leistungsbeschreibung auf dem Webserver zur Verfügung stehenden Speicherplatz und dient unter anderem auch der Speicherung von Log-Files etc.</p>

<p id="3-3">3.3.    Dem Anbieter bleibt das Recht vorbehalten, Leistungen zu erweitern und Verbesserungen vorzunehmen, wenn diese dem technischen Fortschritt dienen, notwendig erscheinen, um Missbrauch zu verhindern, oder der Anbieter aufgrund gesetzlicher Vorschriften hierzu verpflichtet ist. Sonstige Änderungen des Vertragsinhalts, einschließlich dieser AGB, kann der Anbieter - mit Zustimmung des Kunden - vornehmen, sofern die Änderung unter Berücksichtigung der Interessen des Anbieters für den Kunden zumutbar ist. Unzumutbar ist insbesondere jede Vertragsänderung, die eine Reduzierung der vertraglichen Hauptleistungen des Anbieters zur Folge hat. Die vertraglichen Hauptleistungen sind in der jeweiligen Tarifleistungsbeschreibung als solche bezeichnet. Besteht die Änderung des Vertrages in einer Erhöhung der vom Kunden zu entrichtenden Entgelte, so richtet sich deren Zulässigkeit nach Ziffer 9.5 dieser AGB. Die Zustimmung zur Änderung des Vertrages gilt als erteilt, wenn der Kunde der Änderung nicht innerhalb eines Monats nach Zugang der Änderungsmitteilung widerspricht. Der Anbieter verpflichtet sich, den Kunden im Zuge der Änderungsmitteilung auf die Folgen eines unterlassenen Widerspruchs hinzuweisen.</p>

<p id="3-4">3.4.     Freiwillige, unentgeltliche Dienste und Leistungen des Anbieters, die ausdrücklich als solche bezeichnet und nicht Teil der Leistungsbeschreibung sind, können vom Anbieter jederzeit eingestellt werden. Der Anbieter wird bei Änderungen und der Einstellung kostenloser Dienste und Leistungen auf die berechtigten Interessen des Kunden Rücksicht nehmen.</p>

<p id="3-5">3.5.    Der Anbieter hat das Recht, sich zur Leistungserbringung jederzeit und in beliebigem Umfang Dritter zu bedienen.</p>

<p id="3-6">3.6.    Der Anbieter kann darüber hinaus seine Rechte und Pflichten aus diesem Vertrag auf einen oder mehrere Dritte übertragen ("Vertragsübernahme"). Der Anbieter hat dem Kunden die Vertragsübernahme mindestens vier Wochen vor dem Zeitpunkt der Übernahme mitzuteilen. Für den Fall der Vertragsübernahme steht dem Kunden das Recht zu, den Vertrag mit Wirkung zum Zeitpunkt der Vertragsübernahme zu kündigen.</p>


<h3 id="4">4.      Resellertarife, Vertragsstrafe</h3>

<p>Soweit es sich bei dem jeweiligen Tarif nicht um einen Resellertarif handelt, darf der Kunde die Webhostingleistungen Dritten weder entgeltlich noch unentgeltlich zur Verfügung stellen ("Reseller-Tätigkeit"). Ausgenommen hiervon ist das zur Verfügung stellen an Familienangehörige und Freunde, soweit dieses unentgeltlich erfolgt. Der Kunde verpflichtet sich im Falle eines Verstoßes zur Zahlung einer Vertragsstrafe gem. Ziffer 13.</p>


<h3 id="5">5.      Vertragslaufzeit, Vertragsverlängerung und -kündigung, Einstellung der Leistung</h3>

<p id="5-1">5.1.      Soweit sich nicht aus der jeweiligen Leistungsbeschreibung etwas anderes ergibt, hat der Vertrag eine Laufzeit von einem Jahr und verlängert sich jeweils um denselben Zeitraum, wenn der Vertrag nicht einen Monat vor Ende der jeweiligen Laufzeit gekündigt wird.</p>

<p id="5-2">5.2.    Unberührt bleibt das Recht beider Vertragsparteien zur fristlosen Kündigung aus wichtigem Grund. Ein wichtiger Grund für den Anbieter ist insbesondere dann gegeben, wenn mindestens einer der folgenden Sachverhalte vorliegt: </p>
<ul>
  <li>der Kunde verstößt trotz Abmahnung schuldhaft gegen eine vertragliche Pflicht;</li>
  <li>der Kunde beseitigt trotz Abmahnung nicht innerhalb angemessener Frist eine Vertrags- oder Rechtsverletzung.</li>
</ul>

<p>Eine Abmahnung ist entbehrlich wenn es sich um einen Verstoß handelt, der eine Fortsetzung des Vertrages für den Anbieter unzumutbar macht. Dies ist insbesondere der Fall:</p>
<ul>
  <li>bei gravierenden Vertrags- oder Rechtsverstößen, wie z.B.</li>
  <li>erheblichen Verstößen i.S.d §§ 23, 24 Jugendmedienschutz- Staatsvertrages und/oder</li>
  <li>erheblichen Urheberrechtsverstößen durch Speicherung und/oder zum Abruf Bereithalten solcher Inhalte insbesondere Musik, Bilder, Videos, Software etc. und/oder</li>
  <li>der Speicherung und/oder dem zum Abruf Bereithalten von Inhalten, deren Speicherung und/oder das zum Abruf Bereithalten strafbar ist</li>
  <li>bei Straftaten des Kunden gegen den Anbieter oder andere Kunden des Anbieters, insbesondere bei strafbarer Ausspähung oder Manipulationen der Daten des Anbieters oder anderer Kunden des Anbieters.</li>
</ul>

<p id="5-3">5.3.    Die Kündigung zum jeweiligen Tarif zusätzlich gewählter Optionen, insbesondere zusätzlicher Domains, lässt das Vertragsverhältnis insgesamt unberührt.</p>

<p id="5-4">5.4.    Die ordentliche und außerordentliche Kündigung bedürfen zu ihrer Wirksamkeit der Schriftform. Eine ordentliche (fristgerechte Kündigung zum regulären Laufzeitende) kann seitens des Kunden alternativ auch als "Online-Kündigung" über das Kundenmenü erfolgen, wenn zwischen dem Kunden und dem Anbieter diese
Möglichkeit vereinbart wurde.</p>

<p id="5-5">5.5.    Nach Beendigung des Vertragsverhältnisses ist der Anbieter zur Erbringung der vertraglichen Leistungen nicht mehr verpflichtet. Spätestens sieben Tage nach Vertragsende kann der Anbieter sämtliche auf dem Webserver befindliche Daten des Kunden, einschließlich in den Postfächern befindlicher E-Mails, löschen. Die rechtzeitige Speicherung und Sicherung der Daten liegt daher in der Verantwortung des Kunden. Darüber hinaus ist der Anbieter nach Beendigung des Vertrages berechtigt Domains des Kunden, die nicht zu einem neuen Provider übertragen wurden, freizugeben.</p>


<h3 id="6">6.      Allgemeine Pflichten des Kunden</h3>

<p id="6-1">6.1.    Für die Domain selbst sowie für sämtliche Inhalte, die der Kunde auf dem Webserver abrufbar hält oder speichert ist alleine der Kunde verantwortlich. Dies gilt auch, soweit die Inhalte auf einem anderen Webserver als dem des Anbieters abgelegt sind und lediglich unter einer über den Anbieter registrierten Domain bzw. Subdomain abrufbar sind. Der Kunde ist im Rahmen seiner Verpflichtung zur Einhaltung der gesetzlichen und vertraglichen Regelungen auch für das Verhalten Dritter, die in seinem Auftrag tätig werden, insbesondere von Erfüllungs- und Verrichtungsgehilfen verantwortlich. Dies gilt auch für sonstige Dritte, denen er wissentlich Zugangsdaten zu den Diensten und Leistungen des Anbieters zur Verfügung stellt. Der Anbieter ist nicht verpflichtet, den Webserver des Kunden auf eventuelle Verstöße zu prüfen.</p>

<p id="6-2">6.2.    Der Kunde verpflichtet sich, die vom Anbieter zum Zwecke des Zugangs erhaltenen Passwörter streng geheim zu halten und den Anbieter unverzüglich zu informieren, sobald er davon Kenntnis erlangt, dass unbefugten Dritten das Passwort bekannt ist.</p>

<p id="6-3">6.3.    Der Kunde ist verpflichtet, dem Anbieter seinen vollständigen Namen und eine ladungsfähige Postanschrift (keine Postfach- oder sonstige anonyme Adresse), EMailadresse und Telefonnummer anzugeben. Falls der Kunde eigene Name-Server oder Name-Server eines Drittanbieters verwendet, hat er darüber hinaus die IP-Adressen des primären und sekundären Name-Servers einschließlich der Namen dieser Server anzugeben. Der Kunde versichert, dass alle dem Anbieter mitgeteilten Daten richtig und vollständig sind. Der Kunde hat bei Änderungen, die Daten unverzüglich über sein Kundenmenü oder durch Mitteilung an den Anbieter per Post, Telefax oder E-Mail zu aktualisieren.</p>

<p id="6-4">6.4.    Der Kunde verpflichtet sich im Falle eines Verstoßes gegen Ziffer 6.3 zur Zahlung einer Vertragsstrafe gem. Ziffer 13.</p>

<p id="6-5">6.5.    Der Kunde verpflichtet sich, den Anbieter unverzüglich und vollständig zu informieren, falls er aus der Verwendung der vertragsgegenständlichen Dienste gerichtlich oder außergerichtlich in Anspruch genommen wird.</p>

<p id="6-6">6.6.    Dem Kunden obliegt es, alle Dateien und Softwareeinstellungen, auf die er zugreifen kann, selbst regelmäßig zu sichern. Die Datensicherung hat jedenfalls vor Vornahme jeder vom Kunden vorgenommenen Änderung zu erfolgen sowie vor Wartungsarbeiten des Anbieters, soweit diese rechtzeitig durch den Anbieter angekündigt wurden. Die vom Kunden erstellten Sicherungskopien sind keinesfalls auf dem Webserver zu speichern.</p>


<h3 id="7">7.      Nutzungseinschränkungen, Einhaltung gesetzlicher Vorschriften, Rechte Dritter</h3>

<p id="7-1">7.1.    Der Kunde hat sicherzustellen, dass die Internet-Präsenzen oder Daten anderer Kunden des Anbieters, die Serverstabilität, Serverperformance oder Serververfügbarkeit nicht entgegen der vertraglich vorausgesetzten Verwendung beeinträchtigt werden. Insbesondere ist es dem Kunden nur mit schriftlicher Genehmigung des Anbieters gestattet:</p>
<ul>
  <li>Banner-Programme (Bannertausch, Ad-Server, usw.) zu betreiben;</li>
  <li>Freespace-Angebote Subdomain-Dienste, Countersysteme, anzubieten;</li>
  <li>ein Chat-Forum zu betreiben, es sei denn, der Tarif des Kunden enthält ein vom Anbieter zur Verfügung gestelltes Chat-System.</li>
</ul>

<p id="7-2">7.2.    Der Kunde ist verpflichtet im Rahmen der gesetzlichen Regeln, insbesondere unter Einhaltung des TMG, vorgeschriebene Angaben auf seiner Website zu machen.</p>

<p id="7-3">7.3.    Die vom Webserver abrufbaren Inhalte, gespeicherte Daten, eingeblendete Banner sowie die, bei der Eintragung in Suchmaschinen verwendeten Schlüsselwörter dürfen nicht gegen gesetzliche Verbote, die guten Sitten oder Rechte Dritter (insbesondere Marken, Namens- und Urheberrechte) verstoßen. Dem Kunden ist es auch nicht gestattet pornographische Inhalte sowie auf Gewinnerzielung gerichteten Leistungen anzubieten oder anbieten zu lassen, die pornographische und/oder erotische Inhalte (z. B. Nacktbilder, Peepshows etc.) zum Gegenstand haben.</p>

<p id="7-4">7.4.    Der Kunde verpflichtet sich im Falle eines Verstoßes gegen die Ziffern 7.1 bis 7.3 zur Zahlung einer Vertragsstrafe gem. Ziffer 13.</p>


<h3 id="8">8.      E-Mail-Empfang und E-Mail-Versand, Verbot und Vertragsstrafe für "Spam"-E-Mails</h3>

<p id="8-1">8.1.    Der Anbieter hat das Recht, die Maximalgröße der zu versendenden E-Mails jeweils auf einen angemessenen Wert zu beschränken. Soweit sich aus der jeweiligen Leistungsbeschreibung nichts anderes ergibt, beträgt dieser Wert 100 MB.</p>

<p id="8-2">8.2.    Der Versand von E-Mails über Systeme bzw. Server des Anbieters sowie der Versand über Domains, die über den Anbieter registriert sind, ist unzulässig, soweit es sich um einen massenhaften Versand von E-Mails an Empfänger ohne deren Einwilligung handelt und/oder es sich um ein Werbe-E-Mail handelt und eine Einwilligung des Empfängers nicht vorliegt obwohl diese erforderlich ist (insgesamt nachfolgend als "Spam" bezeichnet). Der Nachweis einer Einwilligung (vgl. § 7 Abs. 2 UWG) des jeweiligen Empfängers obliegt dem Kunden. Kunden ist auch untersagt mittels über andere Anbieter versandte Spam-E-Mails Inhalte zu bewerben, die unter einer über den Anbieter registrierten Domain abrufbar sind oder die beim Anbieter gehostet werden.</p>

<p id="8-3">8.3.    Dem Kunden ist auch untersagt, über den Webserver mittels Skripten mehr als 100 E-Mails pro Stunde je Webhosting-Paket und/oder sog. "Paidmails" bzw. E-Mails mit denen ein "Referral-System" beworben wird, zu versenden.</p>

<p id="8-4">8.4.    Der Kunde verpflichtet sich im Falle eines Verstoßes gegen Ziffer 8.2 und/oder Ziffer 8.3 zur Zahlung einer Vertragsstrafe gem. Ziffer 13.</p>


<h3 id="9">9.      Entgeltzahlung und Rechnungsstellung, Entgelterhöhung, Zahlungsverzug, Entgelterstattung</h3>

<p id="9-1">9.1.    Die Höhe der vom Kunden an den Anbieter zu bezahlenden Entgelte und der jeweilige Abrechnungszeitraum ergeben sich aus der Leistungsbeschreibung des vom Kunden gewählten Tarifs. Die nutzungsunabhängigen Entgelte werden monatlich im Voraus fällig, die nutzungsabhängigen Entgelte mit Rechnungsstellung.</p>

<p id="9-2">9.2.    Die Rechnungsstellung erfolgt online durch Einstellen der Rechnung als herunterladbare und ausdruckbare Datei in das Kundenmenü ("Online-Rechnung"). Ein Anspruch auf digital signierte Rechnungen (§ 14 Abs. 3 UStG) besteht nicht. Im Falle der Online-Rechnung gilt diese dem Kunden als zugegangen, wenn sie für ihn im Kundenmenü abrufbar und damit in seinen Verfügungsbereich gelangt ist. Dem Anbieter bleibt es unbenommen alternativ zur Online-Rechnung die Rechnungsstellung postalisch vorzunehmen. Ein Anspruch des Kunden auf Übersendung einer Rechnung auf dem Postwege besteht jedoch nur, wenn der Kunde zum Vorsteuerabzug berechtigt ist und er die Rechnung beim Anbieter jeweils anfordert und das hierfür vereinbarte Entgelt (derzeit 1,45 EUR je einzelne Rechnung) entrichtet.</p>

<p id="9-3">9.3.    Der Kunde ermächtigt den Anbieter, die vom Kunden zu erbringenden Zahlungen zu Lasten eines vom Kunden angegebenen Kontos einzuziehen. Der Kunde hat für ausreichende Deckung des Kontos Sorge zu tragen. Ist aufgrund eines vom Kunden zu vertretenden Grundes eine Teilnahme am Lastschriftverfahren nicht möglich oder erfolgt eine vom Kunden zu vertretende Rücklastschrift, ist der Kunde verpflichtet, dem Anbieter die hierfür anfallenden Bankgebühren zu erstatten. Daneben hat der Kunde dem Anbieter die hierfür vereinbarte Bearbeitungsgebühr (derzeit 10,00 EUR je Rücklastschrift) zu bezahlen.</p>

<p id="9-4">9.4.    Befindet sich der Kunde mit einer Zahlung mindestens sieben Tage in Verzug, ist der Anbieter berechtigt, seine Leistung zu verweigern. In der Regel geschieht dies durch die Sperrung des Accounts (Ziffer 12.1). Befindet sich der Kunde mit einer Zahlung mindestens 14 Tage in Verzug, ist der Anbieter berechtigt, das gesamte Vertragsverhältnis mit dem Kunden außerordentlich zu kündigen (Ziffer 5.2).</p>

<p id="9-5">9.5.    Der Anbieter ist berechtigt, die Entgelte angemessen zu erhöhen. In jedem Fall angemessen ist insoweit eine jährliche Erhöhung um höchstens 5%. Die Entgelterhöhung bedarf der Zustimmung des Kunden. Die Zustimmung gilt als erteilt, wenn der Kunde der Erhöhung nicht binnen eines Monats nach Zugang der Änderungsmitteilung widerspricht. Der Anbieter ist verpflichtet, den Kunden mit der Änderungsmitteilung auf die Folgen eines unterlassenen Widerspruchs hinzuweisen. Widerspricht der Kunde der Preiserhöhung, steht dem Anbieter ein Sonderkündigungsrecht zu.</p>

<p id="9-6">9.6.    Vorausbezahlte Entgelte werden dem Kunden erstattet, wenn der Vertrag vor Ablauf des Abrechnungszeitraums endet. Im Falle einer wirksamen außerordentlichen Kündigung (Ziffer 5.2) durch den Anbieter hat dieser Anspruch auf Zahlung des Entgelts für die gesamte vereinbarte Dauer des Vertrages.</p>


<h3 id="10">10.     Leistungsstörungen</h3>

<p id="10-1">10.1.   Für Leistungsstörungen ist der Anbieter nur verantwortlich soweit diese die von ihm nach Ziffer 3.1 zu erbringenden Leistungen betreffen. Insbesondere für die Funktionsfähigkeit der eigentlichen Internet-Präsenz des Kunden, bestehend aus den auf den Webserver aufgespielten Daten (z.B. HTML-Dateien, Flash-Dateien, Skripte etc.), ist der Anbieter nicht verantwortlich.</p>

<p id="10-2">10.2.   Störungen hat der Anbieter im Rahmen der technischen und betrieblichen Möglichkeiten unverzüglich zu beseitigen. Der Kunde ist verpflichtet, dem Anbieter für ihn erkennbare Störungen unverzüglich anzuzeigen ("Störungsmeldung"). Erfolgt die Beseitigung der Störung nicht innerhalb eines angemessenen Zeitraums, hat der Kunde dem Anbieter eine angemessene Nachfrist zu setzen. Wird die Störung innerhalb dieser Nachfrist nicht beseitigt, hat der Kunde Anspruch auf Ersatz des ihm entstandenen Schadens im Rahmen der Ziffer 11.</p>

<p id="10-3">10.3.   Wird die Funktionsfähigkeit des Webservers aufgrund nicht vertragsgemäßer Inhalte oder aufgrund einer über den vertraglich vorausgesetzten Gebrauch hinausgehende Nutzung (Ziffer 7.1) beeinträchtigt, kann der Kunde hinsichtlich hierauf beruhender Störungen keine Rechte geltend machen. Im Falle höherer Gewalt ist der Anbieter von der Leistungspflicht befreit. Hierzu zählen insbesondere rechtmäßige Arbeitskampfmaßnahmen, auch in Drittbetrieben und behördliche Maßnahmen, soweit nicht vom Anbieter verschuldet.</p>


<h3 id="11">11.     Haftung des Anbieters</h3>

<p id="11-1">11.1.   Eine Haftung des Anbieters besteht ausschließlich im Rahmen der Ziffern 11.2 bis 11.6. Die folgenden Haftungsbestimmungen gelten dabei für Ansprüche aus jeglichem Rechtsgrund.</p>

<p id="11-2">11.2.   Der Anbieter haftet dem Kunden für Schäden unbegrenzt, die von ihm oder einem seiner Erfüllungsgehilfen oder gesetzlichen Vertreter vorsätzlich oder grob fahrlässig verursacht werden. Bei Schäden aus der Verletzung des Lebens, des Körpers oder der Gesundheit ist die Haftung auch bei einer einfachen Pflichtverletzung des Anbieters oder eines seiner gesetzlichen Vertreter oder Erfüllungsgehilfen der Höhe nach unbegrenzt. Ebenso der Höhe nach unbegrenzt ist die Haftung für Schäden, die auf schwerwiegendes Organisationsverschulden des Anbieters zurückzuführen sind, sowie für Schäden, die durch das Fehlen einer garantierten Beschaffenheit hervorgerufen werden.</p>

<p id="11-3">11.3.   Soweit nicht Ziffer 11.2 eingreift, haftet der Anbieter bei der Verletzung wesentlicher Vertragspflichten der Höhe nach begrenzt auf den vertragstypisch vorhersehbaren Schaden. Die Haftungshöchstsumme ist darüber hinaus in anderen Fällen, als denen der Ziffer 11.2 begrenzt auf die Höhe des vom Kunden zu entrichteten Jahresentgelts.</p>

<p id="11-4">11.4.   Bei einem vom Anbieter verschuldeten Datenverlust, haftet der Anbieter ausschließlich für die Kosten der Rücksicherung und Wiederherstellung von Daten, die auch bei einer ordnungsgemäß erfolgten Sicherung der Daten verloren gegangen wären. Eine Haftung besteht jedoch nur im Rahmen der Haftungsregelungen dieser AGB.</p>

<p id="11-5">11.5.   Ansprüche des Kunden, die auf der Verletzung des Lebens, des Körpers, der Gesundheit oder der Freiheit beruhen, verjähren ohne Rücksicht auf ihre Entstehung und die Kenntnis oder grob fahrlässige Unkenntnis in fünf Jahren von der Begehung der Handlung, der Pflichtverletzung oder dem sonstigen, den Schaden auslösenden Ereignis an. Andere Ansprüche des Kunden, die sich nicht aus Gewährleistung, arglistiger Täuschung oder einer vorsätzlicher Handlung ergeben, verjähren in sechs Monaten.</p>

<p id="11-6">11.6.   Die Haftung nach dem Produkthaftungsgesetz bleibt von den vorstehenden Haftungsregelungen unberührt.</p>


<h3 id="12">12.     Sperrung, Voraussetzungen und Aufhebung der Sperrung, Kostenerstattung</h3>

<p id="12-1">12.1.   Nimmt der Anbieter eine Sperrung vor, so ist er zur Sperrung sämtlicher vertragsgegenständlichen Dienste und Leistungen berechtigt. Die Wahl der Sperrmaßnahme liegt insoweit im Ermessen des Anbieters. Der Anbieter wird jedoch die berechtigten Belange des Kunden berücksichtigen. Insbesondere wird er im Falle einer Sperrung, die aufgrund der Inhalte auf dem Webserver erfolgt, dem Kunden deren Abänderung bzw. Beseitigung ermöglichen. Ergibt sich der Grund zur Sperrung bereits aus der vom Kunden registrierten Domain selbst, ist der Anbieter berechtigt, die Domain des Kunden in die Pflege des Registrars zu stellen. Durch eine Sperrung wird der Kunde nicht von seiner Verpflichtung entbunden, die vereinbarten Entgelte zu entrichten. Der Anbieter genügt seinen Mitteilungspflichten, wenn er die jeweiligen Mitteilungen per E-Mail an die vom Kunden angegebene E-Mailadresse (Ziffer 6.3) sendet. Für die Sperrung und für die Aufhebung der Sperrung kann der Anbieter jeweils das hierfür vereinbarte Entgelt (derzeit 10,00 EUR) berechnen ("Sperr- und Entsperrgebühr").</p>

<p id="12-2">12.2.   Liegt offensichtlich (=evident) ein Verhalten des Kunden oder ein diesem zurechenbares Verhalten Dritter (vgl. Ziffer 6.1) vor, das gegen geltendes Deutsches Recht oder Rechte Dritter verstößt, kann der Anbieter eine Sperrung (Ziffer 12.1) vornehmen. Der Anbieter setzt den Kunden hierüber in Kenntnis. Der Anbieter kann die Aufhebung der Sperrung davon abhängig machen, dass der Kunde den rechtswidrigen Zustand beseitigt und zum Ausschluss einer Wiederholungsgefahr eine vertragsstrafenbewehrte Unterlassungserklärung gegenüber dem Anbieter abgegeben hat sowie für die Zahlung einer hieraus etwaig sich zukünftig ergebenden Vertragsstrafe Sicherheit geleistet hat. Die Höhe des Vertragsstrafeversprechens orientiert sich dabei an der Bedeutung des Verstoßes, beträgt bei Verstößen gegen gewerbliche Schutzrechte oder Wettbewerbsrecht jedoch in der Regel über 5.000 EUR.</p>

<p id="12-3">12.3.   Hält der Anbieter es für möglich, dass ein Verhalten des Kunden oder ein diesem zurechenbares Verhalten Dritter (vgl. Ziffer 6.1) vorliegt, das gegen geltendes Deutsches Recht oder Rechte Dritter verstößt, ist dies jedoch nicht offensichtlich, setzt der Anbieter den Kunden unter Angabe des Grundes und unter Androhung der Sperrung in Kenntnis und fordert ihn unter Fristsetzung zur Abgabe einer Stellungnahme auf. Nimmt der Anbieter dann dennoch eine Sperrung (Ziffer 12.1) vor, setzt er den Kunden hiervon in Kenntnis. Der Anbieter kann die Aufhebung der Sperrung davon abhängig machen, dass der Kunde die geforderte schriftliche Stellungnahme abgegeben und Sicherheit geleistet hat. Die Höhe der Sicherheit entspricht insoweit der Höhe zu erwartender Kosten des Anbieters für den Fall einer Inanspruchnahme von dritter Seite.</p>

<p id="12-4">12.4.   Soweit der Anbieter von Dritten oder von staatlichen Stellen wegen eines Verhaltens in Anspruch genommen wird, das den Anbieter zur Sperrung berechtigt, verpflichtet sich der Kunde, den Anbieter von allen Ansprüchen freizustellen und diejenigen Kosten zu tragen, die durch die Inanspruchnahme oder Beseitigung des rechtswidrigen Zustandes entstanden sind. Dies umfasst insbesondere auch die erforderlichen Rechtsverteidigungskosten des Anbieters. Die Freistellung wirkt auch - als Vertrag zu Gunsten Dritter - für die jeweilige Domain-Vergabestelle, sowie sonstiger für die Registrierung von Domains eingeschalteter Personen.</p>


<h3 id="13">13.     Vertragsstrafe</h3>

<p>Für jeden Fall einer vom Kunden zu vertretenden Zuwiderhandlung gegen Verpflichtungen nach den Ziffern 2.1 und/oder 3.1und/oder 6.1 der Domain-Registrierungsbedingungen des Anbieters und/oder gegen die Ziffern 4 und/oder 6.3 und/oder 7.1 und/oder 7.2 und/oder 7.3 und/oder 8.2 und/oder 8.3 dieser AGB, kann der Anbieter vom Kunden Zahlung einer Vertragsstrafe von bis zu 5.100 EUR verlangen. Der Kunde kann die Höhe der vom Anbieter im Einzelfall festzusetzenden Vertragsstrafe gerichtlich überprüfen lassen. Soweit der Kunde Unternehmer (§ 14 BGB) ist, ist die Einrede des Fortsetzungszusammenhangs ausgeschlossen. Bei andauernden Rechtsverstößen gilt insoweit jeder Monat als eigenständiger Verstoß. Die Geltendmachung eines weitergehenden Schadens bleibt durch die Vertragsstrafe unberührt.</p>


<h3 id="14">14.     Datenschutz</h3>

<p id="14-1">14.1.   Der Anbieter erhebt, verarbeitet und nutzt personenbezogene Daten des Kunden. Weitere Informationen zur Datenverarbeitung und zum Datenschutz ergeben sich aus der Datenschutzerklärung des Anbieters. Diese ist abrufbar unter: <a href="{{ url("page_privacy") }}">Datenschutzerklärung</a></p>

<p id="14-2">14.2.   Dem Kunden ist bekannt, dass die auf dem Webserver gespeicherten Inhalte aus technischer Sicht vom Anbieter jederzeit eingesehen werden können. Darüber hinaus ist es theoretisch möglich, dass die Daten des Kunden bei der Datenübertragung über das Internet von unbefugten Dritten eingesehen werden.</p>


<h3 id="15">15.     Gerichtstand, anwendbares Recht</h3>

<p id="15-1">15.1.   Gerichtsstand für sämtliche Ansprüche aus den Vertragsbeziehungen zwischen den Vertragsparteien sich ergebenden Streitigkeiten, insbesondere über das Zustandekommen, die Abwicklung oder die Beendigung des Vertrages ist - soweit der Kunde Vollkaufmann, juristische Person des öffentlichen Rechts oder öffentlichrechtliches Sondervermögen ist - {{ master.city }}. Der Anbieter kann den Kunden wahlweise auch an dessen allgemeinem Gerichtsstand verklagen.</p>

<p id="15-2">15.2.   Für die vom Anbieter auf der Grundlage dieser AGB abgeschlossenen Verträge und für die hieraus folgenden Ansprüche, gleich welcher Art, gilt ausschließlich das Recht der Bundesrepublik Deutschland unter Ausschluss der Bestimmungen zum Einheitlichen UN-Kaufrecht über den Kauf beweglicher Sachen (CISG).</p>


<h3 id="16">16.     Aufrechnung, Zurückbehaltung, Schriftform, Volljährigkeit, Salvatorische Klausel</h3>

<p id="16-1">16.1.   Mit Forderungen des Anbieters kann der Kunde nur aufrechnen, soweit diese unwidersprochen oder rechtskräftig festgestellt sind. Die Geltendmachung eines Zurückbehaltungsrechts steht dem Kunden nur wegen Gegenansprüchen zu, die aus dem Vertragsverhältnis mit dem Anbieter resultieren.</p>

<p id="16-2">16.2.   Der Kunde erklärt mit Abgabe seiner Bestellung ausdrücklich, dass er das achtzehnte Lebensjahr vollendet hat, voll geschäftsfähig ist und sein überwiegender Wohnsitz in der Bundesrepublik Deutschland liegt. Sofern der Kunde das achtzehnte Lebensjahr nicht vollendet hat, versichert er mit Aufgabe der Bestellung, dass er zu dieser berechtigt ist. Der Anbieter weist auf die mögliche Strafbarkeit einer Falschangabe hiermit hin.</p>

<p id="16-3">16.3.   Die Vertragsparteien vereinbaren, dass soweit in vertraglichen Regelungen zwischen den Parteien Schriftform vorgesehen ist, diese durch Telefax, nicht jedoch durch E-Mail, gewahrt wird.</p>

<p id="16-4">16.4.   Sollten Bestimmungen dieser AGB und/oder des Vertrages unwirksam sein oder werden, so berührt dies die Wirksamkeit der übrigen Bestimmungen nicht. Die Vertragsparteien verpflichten sich, anstelle einer unwirksamen Bestimmung eine gültige Vereinbarung zu treffen, deren wirtschaftlicher Erfolg dem der unwirksamen so weit wie möglich nahe kommt.</p>

    {{ stand }}
  </div>
</div>


<section class="text-only">
  <h2>Domain-Registrierungsbedingungen von {{ site.name.full }}</h2>

  <div>
    <p>Soweit der Kunde über {{ master.co_name }} ("Anbieter") eine Domain (z.B. ".DE", ".COM") registriert, gelten ergänzend zu den Allgemeinen Geschäftsbedingungen des Anbieters folgende Regelungen:</p>


<h3 id="domain-1">1.      Allgemeines, Rechtsverhältnisse, ergänzende Bedingungen</h3>

<p>1.1.    Die unterschiedlichen Top-Level-Domains werden von einer Vielzahl unterschiedlicher Organisationen bzw. Registraren (nachfolgend einheitlich "Vergabestelle") verwaltet. Für jede der unterschiedlichen TLDs bestehen eigene Bedingungen für die Registrierung und Verwaltung. Ergänzend gelten daher die jeweils für die zu registrierende TLD maßgeblichen Registrierungsbedingungen und Richtlinien (siehe unter: Domainrichtlinien). Soweit diese in Widerspruch zu den vorliegenden Domain-Registrierungsbedingungen oder den AGB des Anbieters stehen, haben die jeweiligen Registrierungsbedingungen und Richtlinien Vorrang vor den Domain-Registrierungsbedingungen.</p>

<p>1.2.    Der Anbieter beauftragt lediglich im Auftrag des Kunden die Registrierung der Domain bei der Vergabestelle.</p>

<p>1.3.    Ist der Kunde Reseller (Nicht-Endkunde) einer Domain, so ist er verpflichtet, dafür Sorge zu tragen, dass für den Endkunden ("Domaininhaber" oder "Registranten") jederzeit klar ist, dass die Registrierung über einen Dritten, den akkreditierten Registrar, erfolgt und dass damit auch vertragliche Beziehungen zwischen dem Endkunden und dem akkreditierten Registrar bestehen. Darüber hinaus hat der Kunde, der als Reseller für Domains tätig ist, seine Kunden zur Einhaltung der jeweiligen Registrierungsbedingungen zu verpflichten und soweit der Kunde des Kunden wiederum Reseller ist, sicherzustellen, dass dieser seine Kunden hierzu ebenfalls verpflichte.</p>


<h3 id="domain-2">2.      Prüfungspflichten des Kunden</h3>

<p>2.1.    Der Kunde überprüft vor der Beantragung einer Domain, dass diese keine Rechte Dritter verletzt und nicht gegen geltendes Recht verstößt. Der Kunde versichert, dass er dieser Verpflichtung nachgekommen ist und dass sich bei dieser Prüfung keine Anhaltspunkte für eine Rechtsverletzung ergeben haben.</p>

<p>2.2.    Der Kunde verpflichtet sich im Falle eines Verstoßes gegen Ziffer 2.1 zur Zahlung einer Vertragsstrafe (Ziffer 13 der AGB des Anbieters).</p>


<h3 id="domain-3">3.      Registrierungsdaten, Mitteilungspflichten</h3>

<p>3.1.    Der Kunde ist insbesondere verpflichtet zur Registrierung einer Domain die richtigen und vollständigen Daten des Domaininhabers ("Registrant"), des administrativen Ansprechpartners ("admin-c" bzw. "Administrative Contact") und des technischen Ansprechpartners ("tech-c" bzw. "Technical Contact") anzugeben.  Unabhängig von den einschlägigen Registrierungsbedingungen umfasst dies jeweils neben dem Namen, eine ladungsfähige Postanschrift (keine Postfach- oder anonyme Adresse) sowie E-Mailadresse und Telefonnummer. Der Kunde hat bei Änderungen die Daten unverzüglich über sein Kundenmenü oder durch Mitteilung an den Anbieter per Post, Telefax oder E-Mail zu aktualisieren.</p>

<p>3.2.    Der Kunde verpflichtet sich im Falle eines Verstoßes gegen Ziffer 3.1 zur Zahlung einer Vertragsstrafe (Ziffer 13 der AGB des Anbieters).</p>

<p>3.3.    Der Kunde ist verpflichtet, dem Anbieter unverzüglich anzuzeigen, wenn er aufgrund einer gerichtlichen Entscheidung die Rechte an einer für ihn registrierten Domain verliert.</p>


<h3 id="domain-4">4.      Ablauf der Registrierung</h3>

<p>4.1.    Der Anbieter wird nach Beauftragung durch den Kunden die Beantragung der gewünschten Domain bei der zuständigen Vergabestelle veranlassen. Der Anbieter ist berechtigt, die Aktivierung einer Domain erst nach Zahlung der für die Registrierung vereinbarten Entgelte vorzunehmen. Der Anbieter hat auf die Vergabe durch die jeweilige Vergabestelle keinen Einfluss. Der Anbieter übernimmt keine Gewähr dafür, dass die vom Kunden beantragte Domain zugeteilt werden und/oder die zugeteilte Domain frei von Rechten Dritter ist oder auf Dauer Bestand hat. Die Auskunft des Anbieters darüber, ob eine bestimmte Domain noch frei ist, erfolgt durch den Anbieter aufgrund Angaben Dritter und bezieht sich nur auf den Zeitpunkt der Auskunftseinholung des Anbieters. Erst mit der Registrierung der Domain für den Kunden und der Eintragung in der Datenbank der Vergabestelle ist die Domain dem Kunden zugeteilt.</p>

<p>4.2.    Der Kunde wird bei der jeweiligen Vergabestelle als Domaininhaber und administrativer Ansprechpartner eingetragen. Der Anbieter ist berechtigt, bei Domains der TLDs ("Endung") .com, .net, .org, .cc, .biz und .info aus administrativen Gründen als E-Mail Adresse des admin-c eine abweichende E-Mail-Adresse einzutragen oder eintragen zu lassen. Die Rechte des Kunden werden hierdurch nicht beeinträchtigt. Der Kunde stimmt dieser Verfahrensweise ausdrücklich zu.</p>

<p>4.3.    Eine Änderung des beantragten Domainnamens nach der Beantragung der Registrierung bei der jeweiligen Vergabestelle ist ausgeschlossen. Möglich ist dann lediglich eine Kündigung der bestehenden und Neubeantragung der gewünschten Domain. Ist eine beantragte Domain bis zur Weiterleitung des Antrags an die Vergabestelle bereits anderweitig vergeben worden, kann der Kunde einen anderen Domainnamen wählen. Das gleiche gilt, wenn bei einem Providerwechsel der bisherige Provider den Providerwechsel ablehnt. Soweit einzelne Domains durch den Kunden oder aufgrund verbindlicher Entscheidungen in Domainstreitigkeiten gekündigt werden, besteht kein Anspruch des Kunden auf Beantragung einer unentgeltlichen Ersatzdomain.</p>

<p>4.4.    Der Anbieter darf unter einer vom Kunden registrierten Domain eine von ihm gestaltete Seite einblenden, solange der Kunde noch keine Inhalte hinterlegt oder die Domain auf andere Inhalte umgeleitet hat.


<h3 id="domain-5">5.      Erklärungen, Kündigung, Erstattung von Entgelten</h3>


<p>5.1.    Alle Erklärungen Domains betreffend, insbesondere Kündigung der Domain, Providerwechsel, Löschung der Domain, bedürfen der Schriftform. Insoweit gelten jedoch ergänzend Ziffern 16.3 und 5.4 der AGB des Anbieters.</p>

<p>5.2.    Bei allen über den Anbieter registrierten Domains kann der Kunde unter Einhaltung dieser Domain-Registrierungsbedingungen und den jeweiligen Bedingungen der Vergabestelle diese kündigen oder zu einem anderen Provider umziehen, sofern dieser die entsprechende Top-Level-Domain (z.B. ".DE") anbietet bzw. den Providerwechsel nach den erforderlichen Gegebenheiten und technischen Anforderungen unterstützt. Soweit nicht ausdrücklich der gesamte Webhosting-Vertrag gekündigt wird, sondern lediglich die Kündigung einer Domain/mehrerer Domains/sämtlicher Domains erfolgt, besteht der Webhosting-Vertrag als solcher bzw. der Vertrag über die übrigen Domains fort, da diese auch unabhängig von der gekündigten Domain weiter genutzt werden können.</p>

<p>5.3.    Kann der Anbieter dem Providerwechsel (KK-Antrag) des neuen Provider des Kunden nicht rechtzeitig stattgeben, weil der Providerwechsel durch den neuen Provider oder den Kunden zu spät veranlasst wurde oder die für die Zustimmung notwendigen Voraussetzungen nicht erfüllt sind, ist der Provider ausdrücklich dazu berechtigt, die gekündigte Domain zum Kündigungstermin bei der jeweiligen Vergabestelle löschen zu lassen ("CLOSE"). Der Anbieter behält sich vor, KK-Anträgen erst statt zu geben, wenn sämtliche unbestrittenen offenen Forderungen des Kunden beglichen sind.</p>

<p>5.4.    Soweit die Registrierung der Domain für die jeweilige Registrierungsdauer auch nach Beendigung des Vertragsverhältnisses mit dem Anbieter fortdauert und damit die Domain weiter nutzbar bleibt, erfolgt weder für eine im Tarif enthaltene Domain noch für zusätzliche Domains eine Erstattung bereits bezahlter Entgelte.</p>


<h3 id="domain-6">6.      "Domain-Reseller"</h3>

<p>6.1.    Soweit eine Domain durch einen Kunden für einen Dritten, insbesondere einen Kunden des Kunden ("Zweitkunde") registriert ist, darf der Kunde Änderungen der Daten ("Whois-Daten") dieser Domain - insbesondere auch die Übertragung der Domain - nur vornehmen, wenn ein schriftlicher Auftrag des Domaininhabers und/oder des administrativen Ansprechpartners der betreffenden Domain vorliegt. Dies gilt sowohl für einen Änderungsauftrag des Kunden den dieser im eigenen Namen vornimmt, als auch für einen Auftrag, den er dem Anbieter in Vertretung des Zweitkunden erteilt.</p>

<p>6.2.    Der Kunde verpflichtet sich im Falle eines Verstoßes gegen Ziffer 6.1 zur Zahlung einer Vertragsstrafe (Ziffer 13 der AGB des Anbieters).</p>

    {{ stand }}


  </div>
</section>
{% endspaceless %}

