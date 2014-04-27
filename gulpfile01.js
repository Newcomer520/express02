var gulp = require('gulp')
, compass = require('gulp-compass')
, path = require('path')
,paths =
{
	
};

gulp.task('default', ['dev']);
gulp.task('dev', ['build', 'temp']);
gulp.task('build', ['compass']);

gulp.task('compass', function() {

	gulp.src('./source/compass/sass/*.scss')
		.pipe(compass({
			project: path.join(__dirname, 'source/compass'),
			//config_file: './source/compass/config.rb',
			css: '_public/stylesheets',
			sass: 'sass'
		}))
		.pipe(gulp.dest('_public/stylesheets'));
});

var watcher = gulp.watch('source/compass/sass/*.scss',['compass']);

