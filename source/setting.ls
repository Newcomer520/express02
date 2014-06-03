require! <[path express morgan body-parser method-override]>
require! <[connect-livereload]>
require! <[gulp gulp-livereload gulp-util cookie-parser connect]>
session = require 'express-session'
socket-io = require 'socket.io'
#session-socket = require 'session.socket.io-express4'
session-socket = require './session-socket-c'
var MemoryStore, CookieParser
express-root = __dirname
express-port = process.env.port or process.env.PORT or 3000
livereload-port = 35729

global.app-setting =
	root-path: path.join __dirname, '..'
	app-path: (a-path) -> path.join this.root-path, a-path
	app-engine: express!
	app-server: undefined
	app-io: undefined
	start: !->
		if this.started then
			gulp-util.log 'Server started already.'
			return false
		this.started == true
		this.livereload!
		app-engine-middleware!
		this.app-server = my-app.listen express-port
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
		

#middleware setting io := socket-io.listen global.app-setting.app-server, {log: false}
my-app = app-setting.app-engine
console.log "root path: #{app-setting.root-path}" 

	

#routes..
default-route = require app-setting.app-path 'source/routes/default'
default-route(my-app)

exports.start = !->
	global.app-setting.start! 
	initialize-socket-io!
	
!function app-engine-middleware
	MemoryStore := new connect.middleware.session.MemoryStore!
	my-app.use express.static path.join global.app-setting.root-path, '_public'
	CookieParser := cookie-parser('tsiss')
	my-app.use CookieParser
	my-app.use session do
		key: 'ssid'
		secret: 'keyboard dog'
		store: MemoryStore
	my-app.use morgan 'dev'
	my-app.use method-override!
	my-app.set 'views', path.join global.app-setting.root-path, 'view'

!function initialize-socket-io
	
	io = socket-io.listen global.app-setting.app-server, {log: false}
	sessionSockets = new session-socket(io, MemoryStore, CookieParser, 'ssid')
	global.app-setting.app-io = sessionSockets

