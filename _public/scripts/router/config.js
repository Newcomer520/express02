define(['namespace'], function(namespace) {
	'use strict';
	var router = angular.module('routerModule');
	router.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
		$urlRouterProvider.otherwise('/');
		$stateProvider
			.state('home', {
				url: '/',
				templateUrl: 'view/partial-home.html'
			})
			.state('aboutme', {
				url: '/about',
				templateUrl: ''
			})
			.state('nodejs', {
				url: '/nodejs',
				templateUrl: 'view/partial-nodejs.html'
			})
			.state('nodejs.chatroom', {
				url: '/chatroom',
				templateUrl: 'view/partial-chatroom.html'
			})
			.state('opendata', {
				url: '/opendata',
				templateUrl: ''
			})
	}]);

	return router;
});