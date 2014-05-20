require.config({
	baseUrl: '/',
	paths: {
		jquery: 'vendor/jquery/dist/jquery',
		angular: 'vendor/angular/angular',
		ngRoute: 'vendor/angular-route/angular-route',
		bootstrap: 'vendor/bootstrap/dist/js/bootstrap',
		app: 'scripts/app',		
		ctrlModule: 'scripts/controllers/ctrl-module',
		ngDrtvs: 'scripts/directives/angular-directives',
		ngUIRouter: 'vendor/angular-ui-router/release/angular-ui-router',
		'ng-lun-lib': 'scripts/ng-lun-lib'
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
		'ng-lun-lib':
		{
			exports: 'ng-lun-lib',
			deps: ['angular']
		}
	}
});


require([
	'angular',
	'bootstrap',
	'app'
	], 
	function(angular, bootstrap, app) {
		angular.element(document).ready(function() {
			angular.bootstrap(document.body, [app.name])
		});
	}
);