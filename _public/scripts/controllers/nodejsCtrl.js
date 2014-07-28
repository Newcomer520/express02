define(['namespace'], function(){
	var ctrlModule = angular.module('ctrlModule');
	ctrlModule.controller('nodejsCtrl', nodejsCtrl);

	nodejsCtrl.$inject = ['$scope'];
	function nodejsCtrl($scope) {
		$scope.testitem = 'hello another way';
	}
});