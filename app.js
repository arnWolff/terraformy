const { exec } = require('child_process');
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/cdktf', (req, res) => {
  if (req.query.version) {
    exec('cdktf --version', (error, stdout, stderr) => {
      if (error) {
        res.status(500).send(`Error: ${error.message}`);
        return;
      }
      if (stderr) {
        res.status(500).send(`Error: ${stderr}`);
        return;
      }
      res.send(`Output: ${stdout}`);
    });
  } else {
    res.status(400).send('Invalid query parameter');
  }
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});