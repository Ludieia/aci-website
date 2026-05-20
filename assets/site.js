(function () {
  'use strict';

  window.ACICORP_FORMS_CONFIG = window.ACICORP_FORMS_CONFIG || {
    endpoint: 'http://178.156.210.71:3000/agent-task',
    environment: 'test'
  };

  var navHtml = [
    '<a href="/index.html">Home</a>',
    '<a href="/pages/about.html">About</a>',
    '<a href="/pages/programs.html">Programs</a>',
    '<a href="/pages/partner.html">Partner</a>',
    '<a href="/pages/ammi.html">AMMI</a>',
    '<a href="/pages/register.html">Register</a>',
    '<a href="/pages/donate.html">Donate</a>',
    '<a href="/pages/contact.html">Contact</a>'
  ].join('');

  function normalizeNavigation() {
    var navs = document.querySelectorAll('header nav, .site-header nav');
    navs.forEach(function (nav) {
      nav.innerHTML = navHtml;
    });

    var brands = document.querySelectorAll('a.brand, .brand');
    brands.forEach(function (brand) {
      if (brand.tagName && brand.tagName.toLowerCase() === 'a') {
        brand.setAttribute('href', '/index.html');
      }
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', normalizeNavigation);
  } else {
    normalizeNavigation();
  }

  console.log('ACI website loaded - normalized navigation and Ludie IA forms config v111');
})();
