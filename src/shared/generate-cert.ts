import selfsigned from 'selfsigned';

export function generateCert() {
    const attrs = [
        { name: 'commonName', value: '*.ap-southeast-1.compute.amazonaws.com' },
        { name: 'countryName', value: 'SG' },
        { shortName: 'ST', value: 'Singapore' },
        { name: 'localityName', value: 'Singapore' },
        { name: 'organizationName', value: 'Irwan Setiawan' },
        { shortName: 'OU', value: 'Google' },
    ];

    const pems = selfsigned.generate(attrs, {
        keySize: 2048,
        algorithm: 'sha256',
        days: 365,
    });

    return pems;
}