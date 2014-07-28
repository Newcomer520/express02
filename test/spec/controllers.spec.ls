define <[ngMock scripts/controllers/controllers io]>, (mock, controllers, io)!->	
	describe 'test chat controller', (,) !->
		var ctrl, $scope, baseUrl, createController, roomId

		beforeEach !->
			baseUrl := 'http://localhost:3000/chat'
			module 'serviceModule'
			module (chatRoomProvider) !->
				chatRoomProvider.setBaseUrl(baseUrl)
			module 'ctrlModule'			
			inject ($rootScope, $controller, _chatRoom_) !->
				$scope := $rootScope.$new!
				#$cookieStore.put('username', 'testtt')
				createController := !->
					ctrl := $controller('chat-ctrl', {$scope: $scope})
			#module chatCtrl.name

		it 'should mock controller and other stuffs up.', !->
			createController!
			expect(ctrl).toBeDefined!

		

		describe 'join room', (,) !->
			create-room!
			destory-room!
			it 'should hava a function of joining room', !->
				createController!
				expect($scope.joinRoom).toBeDefined!
			describe 'with faked cookiestore', (,)!->	
				beforeEach inject ($cookieStore) !->
					$cookieStore.put('username', 'aaa')
					createController!
				it 'should have a user name with existed username in cookie', !->
					expect($scope.userName).toBeDefined!
			describe 'with no cookie', (,)!->
				it 'should have a user name without cookie', !->
					createController! 
					expect($scope.userName).toBeDefined!

		!function create-room
			var creator, rooms, gotCallback
			beforeEach !->
				creator := io.connect(baseUrl, {'force new connection': true})

				creator.on 'room-list', (data) !->
					rooms := data.msg
					rooms.every (room) !->
						if room.name == 'jasmine1'
							roomId = room.id
							gotCallback := true
				runs !->				
					creator.emit 'create-room', 'jasmine1', 'creator'
				waitsFor do
					-> return gotCallback
					'create room successfully' 
					2500
			afterEach !->
				creator.disconnect!
		!function destory-room
			afterEach !->
				roomId := undefined

