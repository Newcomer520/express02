require! <[path gulp gulp-if gulp-uglify gulp-filter gulp-bower gulp-bower-files streamqueue gulp-concat gulp-compass gulp-util gulp-changed run-sequence gulp-livescript]>
require! <[gulp-minify-css gulp-rename]>

paths = 
	pub: \public
	root: __dirname
	compass: path.join __dirname, \source/compass
	script: path.join __dirname, \_public/scripts
	stylesheet: path.join __dirname, \_public/stylesheets
	js-vendor: \vendor/scripts/*.js #external js files, user imports them directly

gulp.task 'test' ->
	file-watched = process.argv[5] || 'gulp.ls'

process.env[\NODE_ENV] ?= 'production'
is-production = if process.env[\NODE_ENV] is \production then true else false

gulp.task 'http-server' ->
	require('./app.js')

gulp.task 'css', !->
	gulp-util.log 'fuck u'
	gulp.src './_public/stylesheets/*.css'
		.pipe gulp-minify-css!
		#.pipe gulp-rename {extname: '.min.css'}
		.pipe gulp.dest paths.stylesheet + \/dist/

#install bower
gulp.task 'bower-from-vendor' -> gulp-bower!
#install bower packages to the desired folder and concat them to one js file


gulp.task 'bowers', <[bower-from-vendor]>, ->
	#run-sequence 'bower'
	css-filter = gulp-filter '**/*.css'
	#css-filter = gulp-filter (.path is /.css$/)
	js-files = gulp-bower-files!
		#.pipe gulp-filter (.path is /\.css$/)
		.pipe css-filter
		.pipe gulp-concat 'main.css'
		.pipe gulp.dest paths.stylesheet
		.pipe css-filter.restore!
		.pipe gulp-filter (.path is /\.js$/)
		
	#gulp.src ['./_public/stylesheets/*.css']
		#.pipe gulp-minify-css!
	#	.pipe gulp.dest paths.stylesheet


	gulp-util.log gulp-util.colors.yellow('done')

	streamqueue { +objectMode }
		.done js-files, gulp.src paths.js-vendor
		.pipe gulp-concat 'main.js'
		.pipe gulp-if is-production, gulp-uglify! 
		.pipe gulp.dest paths.script



gulp.task 'compass', !->
	gulp-util.log paths.compass
	gulp.src \./source/compass/sass/*.scss 
		.pipe gulp-compass do
			project: paths.compass
			css: \_public/stylesheets
			sass: \sass
		.pipe gulp.dest paths.stylesheet            

/*project: paths.compass
css: \_public/stylesheets
sass: \sass*/
		

gulp.task \compass-watch ->
	gulp.watch do
		path.join paths.compass, \sass/*.scss 
		<[compass]>
		
#build
gulp.task \build, <[bowers compass]>, ->
	gulp-util.log 'building.'
	gulp.src <[./source/app/**/*.ls]>
	.pipe gulp-livescript {+bare}
	.pipe gulp.dest './'



#dev task
gulp.task \dev ->
	run-sequence do
		\build, 
		\compass-watch,
		\http-server


/*
gulp.task 'js:vendor' <[bower]> ->
  bower = gulp-bower-files!
    .pipe gulp-filter (.path is /\.js$/)

  s = streamqueue { +objectMode }
    .done bower, gulp.src paths.js-vendor
    .pipe gulp-concat 'vendor.js'
    .pipe gulp-if production, gulp-uglify!
    .pipe gulp.dest "#{paths.pub}/js"
    .pipe livereload!
*/


/* reference
bower-styl = gulp-bower-files!
    .pipe gulp-filter (.path is /\.styl$/)
    .pipe gulp-stylus use: <[nib]>
bower = gulp-bower-files!
    .pipe gulp-filter (.path is /\.css$/)*/
