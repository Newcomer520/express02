
module.exports = (my-app) ->	
	my-app.get '/', (req, res, next) !->
		res.render 'jade/layout.jade'

	my-app.get '/nodejs', (req, res, next) !->
		res.render 'jade/nodejs.jade'

	my-app.get '/jade', (req, res, next) !->
		res.render 'jade/index.jade'

	my-app.get '/ejs', (req, res, next) !->
		res.render 'ejs/index.ejs'		
	my-app.get '/about', (req, res, next) !->
		res.writeHead 200, {'Content-Type': 'text/html'}
		res.write 'about me'
		res.end!
	my-app.get '/blog', (req, res, next) !->
		res.writeHead 200, {'Content-Type': 'text/html'}
		res.write 'blog'
		res.end!


#chat room route(/chat) is in chatroom.ls 