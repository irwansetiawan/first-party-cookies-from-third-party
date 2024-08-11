import express from 'express';
import path from 'path';

const app = express();

app.use(express.static(path.resolve(__dirname + '/static')));

app.listen(80, () => {
  console.log('[First-Party] Server started');
});
