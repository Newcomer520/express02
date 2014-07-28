define([
	'scripts/controllers/controllers',
	'scripts/directives/directives',
	'scripts/services/services',
	'scripts/router/config', 
	'ng-lun-lib'], function(controllers, directives, services, router, ngLunLib) {
	
	//var myApp = angular.module('my-app', [directives.name, router.name, controllers.name, 'ng-lun-lib']);
	var myApp = angular.module('my-app', [controllers.name, directives.name, services.name, router.name, ngLunLib.name])
	
	myApp.config(['chatRoomProvider', function(chatRoomProvider) {
		chatRoomProvider.setBaseUrl('http://localhost:3000/chat');
	}]);
	/*myApp.config(['$locationProvider', function($locationProvider) {
		//$locationProvider.html5Mode(true);
	}]);*/

	return myApp;
});