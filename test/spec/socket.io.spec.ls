define <[ngMock scripts/services/socket-service underscore]>, (mock, socketService, _) !->
	describe 'socket.io service testing', (,) !->
		var chatRoom, spy
		rooms = []		
		gotCallback = false			
		msg-to-be-sent = 'jasmine msg here'

		beforeEach module socketService.name		
		beforeEach module (chatRoomProvider) !->
			chatRoomProvider.setBaseUrl('http://localhost:3000/chat')
		beforeEach inject (_chatRoom_) !->
			chatRoom := _chatRoom_
		
		#afterEach !->
			#chatRoom.disconnect!

		it 'basic utility check:', !->
			expect(chatRoom.isConnected).toBeDefined!
			expect(chatRoom.on).toBeDefined!
			expect(chatRoom.emit).toBeDefined!
			expect(chatRoom.disconnect).toBeDefined!
		it 'connect to server', !->
			runs !->
			waitsFor do
				-> chatRoom.isConnected()
				"The socket should connect.."
				1500

		xdescribe 'create room ', (done) !->
						
			beforeEach create-room
			afterEach !->
				chatRoom.disconnect!

			it 'room could be created', !->
				expect(spy.callback).toHaveBeenCalled!
			#it 'the name of room should be jasmine', !->
				expect(rooms[0].name).toBe('jasmine')

			

		describe 'client sends message', (,) !->
				got-msg = false
				var msg-data

				beforeEach create-room
				beforeEach !->
					runs !->
						chatRoom.emit 'client-message', {msg: 'hello moto'}						
					
					waitsFor do
						-> got-msg
						'server broadcasted '
						2500
					chatRoom.on 'normal', (data) !->
						console.log data.msg + ' swhy? ' + rooms[0].users.length + ' ' + data.sender.socketId
						msg-data:= data
						got-msg := true								

				it 'should get msg sent by server here', !->

					expect(msg-data).toBeDefined!
					expect(msg-data.msg).toBe 'hello moto'
					

		!function create-room
			spy :=
				callback: !-> this.gotOn = true
			spyOn spy, 'callback'
			chatRoom.on 'room-list', (data) !->
				rooms := data.msg
				if rooms.length == 1 then
					spy.callback()
					gotCallback := true

			runs !->
				chatRoom.createRoom 'jasmine', 'user-test'
			waitsFor do
				-> return gotCallback #spy.gotOn 
				'create room successfully' 
				2500




	 
