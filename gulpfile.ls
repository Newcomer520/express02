require! <[path gulp gulp-if gulp-uglify gulp-filter gulp-bower gulp-bower-files streamqueue gulp-concat]>

paths = 
	pub: \public
	root: __dirname
	compass: path.join __dirname, 'source/compass'
	script: path.join __dirname, \_public/scripts
	js-vendor: 'vendor/scripts/*.js' #external js files, user imports them directly

gulp.task 'test' ->
	file-watched = process.argv[5] || 'gulp.ls'

process.env[\NODE_ENV] ?= 'production'
is-production = if process.env[\NODE_ENV] is \production then true else false

do
	<-! gulp.task 'http-server' 
	require('./app')

#install bower
gulp.task 'bower' !-> gulp-bower!
#install bower packages to the desired folder and concat them to one js file
do
	<-! gulp.task 'js-files', <[bower]>
	js-files = gulp-bower-files!
		.pipe gulp-filter (.path is /\.js$/)

	streamqueue { +objectMode }
		.done js-files, gulp.src paths.js-vendor
		.pipe gulp-concat 'main.js'
		.pipe gulp-if is-production, gulp-uglify! 
		.pipe gulp.dest paths.script

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
