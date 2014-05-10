var path, express, morgan, bodyParser, methodOverride, connectLivereload, gulp, gulpLivereload, gulpUtil, expressRoot, expressPort, livereloadPort, myApp, defaultRoute;
path = require('path');
express = require('express');
morgan = require('morgan');
bodyParser = require('body-parser');
methodOverride = require('method-override');
connectLivereload = require('connect-livereload');
gulp = require('gulp');
gulpLivereload = require('gulp-livereload');
gulpUtil = require('gulp-util');
expressRoot = __dirname;
expressPort = process.env.port || process.env.PORT || 3000;
livereloadPort = 35729;
global.appSetting = {
  rootPath: path.join(__dirname, '..'),
  appPath: function(aPath){
    return path.join(this.rootPath, aPath);
  },
  appEngine: express(),
  start: function(){
    if (this.started) {
      gulpUtil.log('Server started already.');
      return false;
    }
    this.started === true;
    this.livereload();
    appEngineMiddleware();
    myApp.listen(expressPort);
    console.log("Server running at:" + expressPort + "!!");
  },
  livereload: function(){
    var lr, livereloadService;
    if (process.env.NODE_ENV !== 'development') {
      return false;
    }
    gulpUtil.log("environment: development");
    this.appEngine.use(connectLivereload(livereloadPort));
    lr = require('tiny-lr')();
    lr.listen(livereloadPort);
    livereloadService = function(){
      return gulpLivereload(lr);
    };
    gulp.watch(['./source/ejs/*.ejs', './_public/**/*'], function(event){
      gulp.src(event.path).pipe(livereloadService());
    });
  }
};
myApp = appSetting.appEngine;
console.log("root path: " + appSetting.rootPath);
function appEngineMiddleware(){
  myApp.use(express['static'](path.join(global.appSetting.rootPath, '_public')));
  myApp.use(morgan('dev'));
  myApp.use(methodOverride());
  myApp.set('views', path.join(global.appSetting.rootPath, 'view'));
}
defaultRoute = require(appSetting.appPath('source/routes/default'));
defaultRoute(myApp);