console.log('Read existing cookies:', document.cookie);


// try to set cookies as a third-party
document.cookie = "cookie3p=1; domain=thirdparty.local:3306; SameSite=None; Partitioned;";

// try to set cookies in the first-party domain
document.cookie = "cookie1p=1; domain=firstparty.local:3305; SameSite=None; Partitioned;";
