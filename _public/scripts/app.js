define([
	'angular', 
	'scripts/controllers/controllers',
	'scripts/directives/directives', 
	'scripts/router/config', 
	'ng-lun-lib'], function(angular, controllers, directives, router, ngLunLib) {
	
	var myApp = angular.module('my-app', [directives.name, router.name, controllers.name, 'ng-lun-lib']);
	
	myApp.config(['chatRoomProvider', function(chatRoomProvider) {
		chatRoomProvider.setBaseUrl('http://localhost:3000/chat');
	}]);
	/*myApp.config(['$locationProvider', function($locationProvider) {
		//$locationProvider.html5Mode(true);
	}]);*/

	return myApp;
});