
module.exports = (my-app) ->	
	my-app.get '/', (req, res, next) !->
		res.render 'ejs/index.ejs'

	my-app.get '/jade', (req, res, next) !->
		res.render 'jade/index.jade'