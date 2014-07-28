var allTestFiles = [];
var TEST_REGEXP = /(spec|test)\.js$/i;

var pathToModule = function(path) {
  return path;
  //.replace(/^\/base\//, '')
  //.replace(/\.js$/, '/\.js$/');
};

Object.keys(window.__karma__.files).forEach(function(file) {
  if (TEST_REGEXP.test(file)) {
    // Normalize paths to RequireJS module names.
    allTestFiles.push(pathToModule(file));
  }
});

require.config({
  // Karma serves files under /base, which is the basePath from your config file
  baseUrl: '/base/_public',
  paths: {
    'ngMock': '../bower_components/angular-mocks/angular-mocks',
    'jquery': 'vendor/jquery/dist/jquery',
    'angular': 'vendor/angular/angular',
    'ngRoute': 'vendor/angular-route/angular-route',
    'ngUIRouter': 'vendor/angular-ui-router/release/angular-ui-router',
    'bootstrap': 'vendor/bootstrap/dist/js/bootstrap',
    'ng-bootstrap': 'vendor/angular-bootstrap/ui-bootstrap-tpls',
    'ng-cookies': 'vendor/angular-cookies/angular-cookies',
    'underscore': 'vendor/underscore/underscore',   
    'app': 'scripts/app',   
    'ng-lun-lib': 'scripts/ng-lun-lib',
    'io': 'vendor/socket.io-client/dist/socket.io',   
    'namespace': 'scripts/namespace'
  },
  shim: {
    'ngMock': {
      deps: ['angular'],
      exports: 'ngMock'
    },
    'bootstrap': {
      deps: ['jquery']
    },
    'angular': {
      exports: 'angular'
    },
    'ngRoute': {
      exports: 'ngRoute',
      deps: ['angular']
    },
    'ngUIRouter': {
      exports: 'ngUIRouter',
      deps: ['angular']
    },
    'ng-lun-lib': {
      exports: 'ng-lun-lib',
      deps: ['angular']
    },
    'ng-bootstrap': {
      deps: ['angular']
    },
    'ng-cookies': {
      deps: ['angular']
    }
  },

  // dynamically load all test files
  deps: allTestFiles,

  // we have to kickoff jasmine, as it is asynchronous
  callback: window.__karma__.start
});
