define <[ngMock scripts/services/socket-service underscore io]>, (mock, socketService, _, io) !->
	describe 'socket.io service testing', (,) !->
		var chatRoom, spy, $interval, baseUrl
		baseUrl = 'http://localhost:3000/chat'
		rooms = []	
		gotCallback = false			
		msg-to-be-sent = 'jasmine msg here'

		beforeEach module socketService.name		
		beforeEach module (chatRoomProvider) !->
			chatRoomProvider.setBaseUrl(baseUrl)
		beforeEach inject (_chatRoom_, _$interval_) !->
			chatRoom := _chatRoom_
			$interval := _$interval_
		
		#connect to server
		beforeEach !->
			runs !->
				chatRoom.connect!
			waitsFor do
				-> 
					return chatRoom.isConnected!
				'connected to server successfully'
				2500
		
		afterEach !->
			chatRoom.disconnect!


				

			
							

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

		describe 'create room ', (,) !->			
			it 'should create a room', !->
				runs !->									
					chatRoom.on 'server', (data) !->
						console.log 'servermsg: ' + data.msg
					chatRoom.on 'room-list', (data) !->
						console.log "length of rooms:#{data.msg.length}"
						rooms := data.msg
						rooms.every (room) !->
							if room.name == 'jasmine'
								#roomId := room.id
								gotCallback := true
								#console.log "#{creator.socket.sessionid} #{chatRoom.socketId()}"
					chatRoom.createRoom 'jasmine', 'usertest'
					#chatRoom.emit 'create-room', 'jasmine', 'creator'
				waitsFor do
					-> 
						return gotCallback
					'create room successfully' 
					2500		
			

		xdescribe 'join room', (,) !->
			#create room
			var roomId, creator
			#beforeEach module socketService.name		
			
			beforeEach !->
				creator :=  io.connect(baseUrl, {'force new connection': true})

			
			beforeEach !->
				gotCallback = false
				creator.on 'room-list', (data) !->
					rooms := data.msg
					rooms.every (room) !->
						if room.name == 'jasmine'
							roomId := room.id
							gotCallback := true
							#console.log "#{creator.socket.sessionid} #{chatRoom.socketId()}"
				runs !->				
					#chatRoom.createRoom 'jasmine', 'usertest'					

					creator.emit 'create-room', 'jasmine', 'creator'
				waitsFor do
					-> return gotCallback
					'create room successfully' 
					2500

			it 'should be the test of joining room', !->
				var msgReceived, gotCallback

				gotCallback = false
				chatRoom.on 'server', (data) !->
					#console.log 'server call back: '  + data.msg
					msgReceived := data.msg
					gotCallback := data.msg == "You have joined the chat room #{roomId}"
				runs !->
					#console.log chatRoom.join
					chatRoom.joinRoom roomId, 'joiner'
				waitsFor do
					-> return gotCallback
					'joined room'
					2500

				

			

		xdescribe 'client sends message', (,) !->
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
				console.log rooms
				rooms.every (room) !->
					console.log rooms.length
					if room.name == 'jasmine'
						spy.callback()
						gotCallback := true
			runs !->				
				chatRoom.createRoom 'jasmine', 'usertest'					

			waitsFor do
				-> return gotCallback #spy.gotOn  
				'create room successfully' 
				2500




	 
