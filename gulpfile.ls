require! <[path gulp gulp-if gulp-uglify gulp-filter gulp-bower gulp-bower-files streamqueue gulp-concat gulp-compass gulp-util gulp-changed run-sequence gulp-livescript]>
require! <[gulp-minify-css gulp-rename gulp-nodemon gulp-jshint gulp-jade gulp-karma]>

paths = 
	app: process.argv[5] or './source/app.ls'
	public: \_public
	root: __dirname
	compass: 'source/compass'
	script: path.join __dirname, \_public/scripts
	stylesheet: path.join __dirname, \_public/stylesheets
	js-vendor: \vendor/scripts/*.js #external js files, user imports them directly
	jade-to-html: <[view/jade/to-html/**/*.jade view/jade/layout.jade]>
	vendor: path.join __dirname, '_public/vendor'

process.env[\NODE_ENV] ?= 'production'
is-production = if process.env[\NODE_ENV] is \production then true else false



gulp.task 'http-server' !->
	gulp-nodemon do
		script: paths.app
		ext: 'ls'
		ignore: <[test/spec/*.ls]>
		#ignore: <[./_public/**/*.js ./bower/** *.ls ./test/spec/*.ls]>
	#.on 'change' ->
	#gulp.src paths.app
	#gulp.gulp-jshint
	.on 'restart' ->
		gulp-util.log "server restarted at: #{new Date()}"

gulp.task 'css', !->
	gulp.src './_public/stylesheets/*.css'
		.pipe gulp-minify-css!
		#.pipe gulp-rename {extname: '.min.css'}
		.pipe gulp.dest paths.stylesheet + \/dist/

#install bower
gulp.task 'bower-from-vendor' -> gulp-bower!
#install bower packages to the desired folder and concat them to one js file

#bower changed to destinate to each single folder
gulp.task 'bowers', <[bower-from-vendor]>, ->
	#run-sequence 'bower'
	#css-filter = gulp-filter '**/*.css'
	#css-filter = gulp-filter (.path is /.css$/)
	#js-files = gulp-bower-files!

	gulp-bower-files!
		.pipe gulp.dest paths.vendor
		#.pipe css-filter
		#.pipe gulp-concat 'vendor.css'
		#.pipe gulp.dest paths.stylesheet
		#.pipe css-filter.restore!
		#.pipe gulp-filter (.path is /\.js$/)

	gulp-util.log gulp-util.colors.yellow('done')

	/*streamqueue { +objectMode }
		.done js-files, gulp.src paths.js-vendor
		.pipe gulp-concat 'vendor.js'
		.pipe gulp-if is-production, gulp-uglify! 
		.pipe gulp.dest paths.script*/



gulp.task 'compass', !->
	gulp.src \./source/compass/sass/*.scss 
		.pipe gulp-compass do
			project: path.join __dirname, paths.compass
			sass: \sass
		.on 'error', (err) !->
			gulp-util.log "compass error: #{err}"
		.pipe gulp.dest paths.stylesheet            

/*project: paths.compass
css: \_public/stylesheets
sass: \sass*/
		

gulp.task \compass-watch !->	
	gulp.watch do		
		path.join paths.compass, 'sass/*.scss'
		<[compass]>

gulp.task 'watch-livescript' !->
	gulp.watch <[source/**/*.ls]>, <[build-my-ls]>	
	
gulp.task 'build-my-ls' ->
	gulp-util.log 'building changed livescript file..'
	gulp.src <[./source/**/*.ls]>
	.pipe gulp-livescript {+bare}
	.pipe gulp.dest './'

gulp.task 'convert-jade-to-html' !->
	gulp.watch paths.jade-to-html, !->
		gulp-util.log 'jade-to-html files changed detected'
		gulp.src paths.jade-to-html[0]
			.pipe gulp-changed path.join paths.public, './view/'
			.pipe gulp-jade {}
			.on 'error', (err) !->
				gulp-util.log "compass error: #{err}"
			.pipe gulp.dest path.join paths.public, './view/'



#build
gulp.task \build, <[bowers compass]>, ->
	
#dev task
gulp.task \dev, !->
	run-sequence do		
		\build
		\compass-watch
		\convert-jade-to-html		
		\http-server
		\unit-test

#test
gulp.task 'unit-test', ->	
	#require './source/app'
	gulp.src [
		#* 'test/test-main.js'
		#* '_public/scripts/**/*.js'
		#* '_public/vendor/**/*.js'
		* 'test/spec/undefined.spec.ls'
	]
	.pipe gulp-karma do
		config-file: 'test/karma.conf.js'
		action: 'watch'
	.on 'error', (,) !->
		gulp-util.log it