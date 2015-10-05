<template class="domainsearch-template-loading" hidden="hidden">
  <li class="domainsearch-result domainsearch-result-loading domainsearch-loading" data-domain="{{ domain.name }}" {{ domaindata }}>
    <label class="domainsearch-price" tabindex="0">
      <h3 property="name">{{ domain.name }}</h3>
      <p>
        wird abgefragt...
      </p>
    </label>
  </li>
</template>

