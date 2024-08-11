import express from 'express';
import staticMiddleware from '../shared/static.middleware';

const app = express();

app.use(staticMiddleware); // handle static files

app.listen(80, () => {
  console.log('[First-Party] Server started');
});
