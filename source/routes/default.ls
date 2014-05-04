
module.exports = (my-app) ->	
	my-app.get '/', (req, res, next) !->
		#res.render 'ejs/index.ejs'
		res.render 'jade/index.jade'

	my-app.get '/jade', (req, res, next) !->
		res.render 'jade/index.jade'

	my-app.get '/ejs', (req, res, next) !->
		res.render 'ejs/index.ejs'		