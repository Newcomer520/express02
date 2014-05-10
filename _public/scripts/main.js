require.config({
	baseUrl: '/',
	paths: {
		jquery: 'vendor/jquery/dist/jquery',
		angular: 'vendor/angular/angular',
		bootstrap: 'vendor/bootstrap/dist/js/bootstrap',
		app: 'scripts/app',
		ngCtrls: 'scripts/controllers/angular-controllers',
		ngDrtvs: 'scripts/directives/angular-directives'
	},
	shim: {
		'bootstrap': {
			deps: ['jquery']
		},
		'angular': {
			exports: 'angular'
		}
	}
});


require([
	'angular',
	'app',
	'scripts/controllers/controllers',
	'scripts/directives/directives'
	], 
	function(angular, app, controllers) {
		angular.element(document).ready(function() {
			angular.bootstrap(document.body, ['my-app'])
		});
	}
);