define <[ngMock scripts/services/socket-service]>, (mock, socketService) !->
	describe 'socket.io service testing', (,) !->
		var chatRoom
		/*beforeEach !->
			angular.module('testapp', !->)
				.config (chatRoomProvider) !->
					provider := chatRoomProvider
			module socketService.name, 'testapp' 
			inject !-> */
		beforeEach module socketService.name
		
		beforeEach module (chatRoomProvider) !->
			chatRoomProvider.setBaseUrl('http://localhost:3000/chat')

		beforeEach inject (_chatRoom_) !->
			chatRoom := _chatRoom_


		it 'isConnected should be a function', !->
			expect(chatRoom.isConnected).toBeDefined!
		it 'connect to server', !->
			runs !->
			waitsFor do
				-> chatRoom.isConnected()
				"The socket should connect."
				1500
	
