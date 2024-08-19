
const setCookie = function(name, value) {
    const domain = '.' + window.location.hostname;
    document.cookie = name + '=' + value + '; domain=' + domain + '; path=/; SameSite=None; Secure';
}

const getCookies = function() {
    console.log('Existing cookies:', document.cookie);
    return document.cookie;
}

setCookie('from-3p-js', 'true');
getCookies();