let params = new URL(document.location.toString()).searchParams;
let utm_source = params.get("utm_source");

console.log('Referer =', document.referrer);
console.log('utm_source =', utm_source);
