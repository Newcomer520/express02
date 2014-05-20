define(['ctrlModule'], function(ctrlModule){
	ctrlModule.controller('nodejsCtrl', nodejsCtrl);

	nodejsCtrl.$inject = ['$scope'];
	function nodejsCtrl($scope) {
		$scope.testitem = 'hello another way';
	}
});