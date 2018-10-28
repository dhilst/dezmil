if (navigator.serviceWorker) {
  console.log('Registering serviceworker');
  navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
    .then(async function(reg) {
      console.log('[Companion]', 'Service worker registered!', reg.update());
      try {
        const update = await reg.update();
        console.log('service worker updated')
      } catch (error) {
        console.erro('service worker update error', error);
      }
    }).catch(function(error) {
      console.error('Service worker registration error', error);
    });
} else {
  console.log('FUCK! navigator.serviceWorker is', navigator.serviceWorker);
}
