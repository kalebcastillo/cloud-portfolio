/**
 * CloudFront Function to rewrite directory requests to index.html
 * This enables SPA routing for Astro static sites
 */
function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // If the request URI ends with a slash, append index.html
  if (uri.endsWith('/')) {
    request.uri += 'index.html';
  }
  
  else if (!uri.includes('.')) {
    request.uri += '/index.html';
  }

  return request;
}
