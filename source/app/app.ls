#app = require('express')
require! <[path express morgan body-parser method-override]>

my-app = express!

port = process.env.port or process.env.PORT or 3000

my-app.use express.static path.join __dirname, \_public
my-app.use morgan \dev
my-app.use method-override!
my-app.set 'views', __dirname
my-app.listen port

do
	req, res, next <-! my-app.get \/
	res.render \./source/ejs/index.ejs
	#res.writeHead \Content-Type, content: \text/html
	#res.write 'hello express 4.0'
	#res.end!

  
console.log "Server running at:#{port}"

/*
do
	<-! gulp.task 'http-server' 
	require('./app')
*/