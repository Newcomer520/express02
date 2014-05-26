define(['io', 'angular'], function(io, angular) {
	var services = angular.module('services', [])
	//,   url = "http://localhost:3000/chat"
	//,   socket = io.connect(url)
	
	services.provider('chatRoom', chatRoomProvider);

	function chatRoomProvider() {

		var baseUrl
		,	socket;
		this.setBaseUrl = function(url) {
			baseUrl = url;			
		}

		this.$get = chatRoomFactory;

		chatRoomFactory.$inject = ['$rootScope'];
		function chatRoomFactory($rootScope) {
			return new chatRoom($rootScope);
		}

		//chatRoomFactory.$inject = ['$rootScope'];
		function chatRoom($rootScope) {
			
			socket = io.connect(baseUrl);


			this.createRoom = function(roomName, userName) {
				if (!angular.isDefined(socket) || socket.socket.connected != true)
					throw 'The web socket is unavailable.';
				socket.emit('create-room', roomName, userName);
			}


			this.on = function(eventName, callback) {
				socket.on(eventName, function() {
					var args = arguments;
					$rootScope.$apply(function() {
						callback.apply(socket, args);
					});					
				});
			}
		}
	}

	return services;
});