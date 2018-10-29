module.exports = {
  dontCacheBustUrlsMatching: /assets/,
  navigateFallback: '/418',
  navigateFallbackWhitelist: [],
  staticFileGlobs: [
    '/assets/**.css',
    '/assets/**.js',
    '/assets/**.json',
    '/assets/**.JPG',
    '/assets/**.png',
  ],
  runtimeCaching: [{
    urlPattern: /./,
    handler: 'cacheFirst'
  }],
  swFilePath: 'public/service-worker.js'
};
