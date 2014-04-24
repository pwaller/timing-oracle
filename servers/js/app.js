var express = require('express');
var app = express();

var target = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz";

app.get('/crack/:token', function(req, res){
  if (req.params.token != target) {
    res.send(401, "Denied");
  }
  res.send('Cracked!');
});

var server = app.listen(3000, function() {
      console.log('Listening on port %d', server.address().port);
});
