import express, { Request, Response } from 'express';
import staticMiddleware from '../shared/static.middleware';
import dotenv from 'dotenv';
import path from 'path';
import https from 'https';
import http from 'http';
import fs from 'fs';

dotenv.config({ path: path.resolve(path.join(__dirname, '.env')) });

const app = express();

http.createServer((req, res) => {
  res.writeHead(301, { "Location": "https://" + req.headers['host'] + req.url });
  res.end();
}).listen(80);

https.createServer({
  key: fs.readFileSync(path.resolve(path.join(__dirname, 'key.pem'))),
  cert: fs.readFileSync(path.resolve(path.join(__dirname, 'cert.pem'))),
}, app).listen(443, function(){
  console.log("[Third-Party] Server listening on port 443");
});

app.use(staticMiddleware); // handle static files

app.get('/3p-pixel-1p', (req: Request, res: Response) => {
  res.cookie('3p', '3p-in-1p-domain', { domain: process.env.FIRST_PARTY_PUBLIC_DNS, sameSite: 'none', secure: true });
  res.send();
});

app.get('/3p-pixel', (req: Request, res: Response) => {
  res.cookie('3p', '3p-in-3p-domain', { domain: process.env.THIRD_PARTY_PUBLIC_DNS, sameSite: 'none', secure: true });
  res.send();
});

app.get('/3p-pixel-partitioned', (req: Request, res: Response) => {
  res.cookie('3p', '3p-in-3p-domain-partitioned', { domain: process.env.THIRD_PARTY_PUBLIC_DNS, sameSite: 'none', secure: true, partitioned: true });
  res.send();
});
