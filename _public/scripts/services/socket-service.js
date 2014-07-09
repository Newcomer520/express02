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

		function chatRoom($rootScope) {
			this.connect = function() {
				
			}
			socket = io.connect(baseUrl);	
			
			//log the error
			socket.on('error', function(err) {
				console.log(err);
			});

			this.isConnected = function() {
				return socket.socket.connected;
			}
			this.socketId = function() {
				if (this.isConnected() == false) {
					return undefined;
				}

				return socket.socket.sessionid;
			}
			this.createRoom = function(roomName, userName) {
				if (!angular.isDefined(socket) || socket.socket.connected != true)
					throw 'The web socket is unavailable.';
				socket.emit('create-room', roomName, userName);
			}
			this.disconnect = function() {
				socket.disconnect();
			}

			this.emit = function(eventName, data) {
				socket.emit(eventName, data);
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