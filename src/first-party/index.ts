import express from 'express';
import staticMiddleware from '../shared/static.middleware';
import dotenv from 'dotenv';
import path from 'path';
import https from 'https';
import http from 'http';
import { generateCert } from '../shared/generate-cert';

dotenv.config({ path: path.resolve(path.join(__dirname, '.env')) });

const app = express();

http.createServer((req, res) => {
  res.writeHead(301, { "Location": "https://" + req.headers['host'] + req.url });
  res.end();
}).listen(80);

const cert = generateCert();

https.createServer({
  key: cert.private,
  cert: cert.cert,
}, app).listen(443, function(){
  console.log("[First-Party] Server listening on port 443");
});

app.use(staticMiddleware); // handle static files

