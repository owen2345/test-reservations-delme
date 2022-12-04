document.addEventListener('turbo:before-fetch-request', (e) => {
  const target = e.target as HTMLElement;

  // add request header to identify turbo requests
  e.detail.fetchOptions.headers['turbo-request'] = true;

  // by default render response content as content of the turbo-frame
  // Sample: <turbo-frame turbo-src="any-url" data-auto-update="true" lazy="true" />
  if (target.getAttribute('data-auto-update')) {
    e.detail.fetchOptions.headers['turbo-target'] = target.id;
  }
});
