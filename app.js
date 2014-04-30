var path, express, morgan, bodyParser, methodOverride, myApp, port;
path = require('path');
express = require('express');
morgan = require('morgan');
bodyParser = require('body-parser');
methodOverride = require('method-override');
myApp = express();
port = process.env.port || process.env.PORT || 3000;
myApp.use(express['static'](path.join(__dirname, '_public')));
myApp.use(morgan('dev'));
myApp.use(methodOverride());
myApp.set('views', __dirname);
myApp.listen(port);
myApp.get('/', function(req, res, next){
  res.render('./source/ejs/index.ejs');
});
console.log("Server running at:" + port);
/*
do
	<-! gulp.task 'http-server' 
	require('./app')
*/