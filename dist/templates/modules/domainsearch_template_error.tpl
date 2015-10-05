<template class="domainsearch-template-error" hidden="hidden">
  <li class="domainsearch-result domainsearch-result-unknown{% if domain.status == "cart" %} product-in-cart{% endif %}" {{ domaindata }}>
    <label class="domainsearch-price" tabindex="0">
      <h3 property="name">{domain.name}</h3>
      <p>
        Fehler bei Abfrage
      </p>
    </label>
  </li>
</template>

