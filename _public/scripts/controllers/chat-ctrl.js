define(['ctrlModule'], function(ctrlModule) {
	//var chatModule = angular.module('chat-module', ['ui.bootstrap']);
	ctrlModule.controller('chat-ctrl', chatCtrl);

	chatCtrl.$inject = ['$scope', 'chatRoom', '$modal', '$cookieStore'];
	function chatCtrl($scope, chatRoom, $modal, $cookieStore) {
		$scope.roomList = [];
		/*chatRoom.roomList().success(function(data) {
			$scope.roomList = data.rooms;
		})*/
		chatRoom.on(function() {
			var args = arguments;
			if (args.length == 1) {
				var msg = args[0];
				console.log(msg.msgType + ' ' + msg.msg);
			}
				
		});
		$scope.createRoom = function() {
			var modalInstance = 
				$modal.open({
					templateUrl: 'view/template/modal-chat-new-room.html',
					size: 'sm',
					resolve: {},
					controller: createRoomModalCtrl
				});
			modalInstance.result.then(function(info) {
				$cookieStore.put('username', info.userName);
				chatRoom.createRoom(info.roomName, info.userName);
			}, function() {
				console.log('dismiss');
			})['finally'](function() {
				modalInstance = undefined;
			});
		}
		$scope.msgSubmit = function() {
			alert('send msg');
		};
	}

	//ctrlModule.controller('create-room-modal-ctrl', createRoomModalCtrl);
	createRoomModalCtrl.$inject = ['$scope', '$modalInstance', 'randGenerator', '$cookieStore'];
	function createRoomModalCtrl($scope, $modalInstance, randGenerator, $cookieStore) {
		var form = $scope.form = {};
		form.name = randGenerator.randomPick('abcdefghijklmnopqrstuvwxyz0123456789', 5).join('');
		form.username = $cookieStore.get('username');

		$scope.cancel = function () {
			$modalInstance.dismiss('cancel');
		};
		$scope.ok = function() {
			$modalInstance.close({roomName: form.name, userName: form.username});
		};
	}
});