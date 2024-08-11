import path from 'path';
import fs from 'fs';
import { NextFunction, Request, Response } from 'express';
import dotenv from 'dotenv';

dotenv.config({ path: path.resolve(path.join(__dirname, '.env')) });

export default function staticMiddleware(req: Request, res: Response, next: NextFunction): void {
    const fileName = req.path === '/' ? 'index.html' : req.path;
    const filePath = path.resolve(path.join(__dirname, 'static', fileName));
    if (fs.existsSync(filePath)) {
      console.log('Serving Static file:', filePath);
      const fileContent = fs.readFileSync(filePath);
      res.contentType(getContentType(fileName));
      res.send(replaceContent(fileContent.toString()));
      res.end();
    } else {
      next();
    }
}

function getContentType(url: string): string {
    if (url.endsWith('.html')) {
      return 'text/html';
    } else if (url.endsWith('.css')) {
      return 'text/css';
    } else if (url.endsWith('.js')) {
      return 'text/javascript';
    } else {
      return 'text/plain';
    }
}

function replaceContent(content: string): string {
    return content
            .replace(/{{FIRST_PARTY_PUBLIC_DNS}}/g, process.env.FIRST_PARTY_PUBLIC_DNS as string)
            .replace(/{{THIRD_PARTY_PUBLIC_DNS}}/g, process.env.THIRD_PARTY_PUBLIC_DNS as string);
}
