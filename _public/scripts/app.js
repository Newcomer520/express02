define(['angular', 'scripts/controllers/controllers',
	'scripts/directives/directives', 'scripts/router/config', 'ng-lun-lib'], function(angular, controllers, directives, router, ngLunLib) {
	var myApp = angular.module('my-app', [directives.name, router.name, controllers.name, 'ng-lun-lib']);
	/*myApp.config(['$routeProvider', function($routeProvider) {
		$routeProvider
		.when('/about', {
			controller: 'about-ctrl',
			templateUrl: '/about'
		})
		.when('/blog', {
			//controller: 'about-ctrl',
			templateUrl: '/blog'
		})
		.when('/', {
			controller: 'nav-ctrl',
			templateUrl: '/about'
		});

	}]);
	myApp.controller('about-ctrl', ['$scope', function($scope) {
	}]);*/
	return myApp;
});