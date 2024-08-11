import express from 'express';
import staticMiddleware from '../shared/static.middleware';

const app = express();

app.use(staticMiddleware); // handle static files

app.listen(80, () => {
  console.log('[Third-Party] Server started');
});
