define(['ctrlModule'], function(ctrlModule) {
	ctrlModule.controller('chat-ctrl', chatCtrl);

	chatCtrl.$inject = ['$scope'];
	function chatCtrl($scope) {

		$scope.msgSubmit = function() {
			alert('send msg');
		};
	}
});