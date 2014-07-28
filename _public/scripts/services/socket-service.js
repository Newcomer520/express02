define(['io', 'namespace'], function(io) {
	var services = angular.module('serviceModule');
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

		chatRoomFactory.$inject = ['$rootScope', '$q', '$interval'];
		function chatRoomFactory($rootScope, $q, $interval) {
			return new chatRoom($rootScope, $q, $interval);
		}

		function chatRoom($rootScope, $q, $interval) {
			this.connect = function() {
				var deferred = $q.defer()
				,	terminateFn
				,	total = 0;

				socket = io.connect(baseUrl);
				/*
					restricted in 5 seconds to connect to server
				*/
				terminator = $interval(function() {
					console.log(socket.socket.connected);
					total += 500;
					if (socket.socket.connected) {
						deferred.resolve('connected to server.');
						$interval.cancel(terminator);
					}
					if (total >= 5000) {
						deferred.reject('timeout to connect to server.');
						$interval.cancel(terminator);	
					}
					
				}, 500, 10);
				return deferred.promise;
			}			
			
			//log the error
			/*socket.on('error', function(err) {
				console.log(err);
			});*/

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
			this.joinRoom = function(roomId, userName) {
				socket.emit('join-room', roomId, userName);
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
			this.getsocket = function() { return socket; }
		}
	}

	return services;
});