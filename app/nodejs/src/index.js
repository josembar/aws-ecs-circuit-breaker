const express = require('express');
const bodyParser = require('body-parser');
const port = process.env.PORT || 3000

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use(require('./routes/appRoutes'));

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});