require.config({
	baseUrl: '/',
	paths: {
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
	}
});


require(['app'], 
	function(app) {
		angular.bootstrap(document.body, [app.name]);
	}
);