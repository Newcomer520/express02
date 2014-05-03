require! <[path express morgan body-parser method-override]>
require! <[connect-livereload]>
require! <[gulp gulp-livereload gulp-util]>

express-root = __dirname
express-port = process.env.port or process.env.PORT or 3000
livereload-port = 35729

global.app-setting =
	root-path: path.join __dirname, '..'
	app-path: (a-path) -> path.join this.root-path, a-path
	app-engine: express!
	start: !->
		if this.started then
			gulp-util.log 'Server started already.'
			return false
		this.started == true
		this.livereload!
		app-engine-middleware!
		my-app.listen express-port
		console.log "Server running at:#{express-port}!!"

	livereload: !-> 
		#gulp-util.log "environment: #{(process.env.NODE_ENV != 'development' ? 'production': 'development')}" 
		if process.env.NODE_ENV != 'development' then 			
			return false
		gulp-util.log "environment: development"
		this.app-engine.use connect-livereload(livereload-port)
		lr = require('tiny-lr')!
		lr.listen livereload-port	
		
		livereload-service = -> gulp-livereload lr
		gulp.watch <[./source/ejs/*.ejs ./_public/**/*]>, (event)!->
			gulp.src(event.path)
			.pipe livereload-service!
		

#middleware setting
my-app = app-setting.app-engine
console.log "root path: #{app-setting.root-path}" 
!function app-engine-middleware 	
	my-app.use express.static path.join global.app-setting.root-path, '_public'
	my-app.use morgan \dev
	my-app.use method-override!
	my-app.set 'views', path.join global.app-setting.root-path, 'view'

#routes..
default-route = require app-setting.app-path 'source/routes/default'
default-route(my-app)

#res.writeHead \Content-Type, content: \text/html
#res.write 'hello express 4.0'
#res.end!

	
