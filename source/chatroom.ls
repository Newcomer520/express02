require! <[http gulp-util]>
#socket-io = require 'socket.io'
#var io, chat
_ = require 'underscore'
app = global.app-setting.app-engine

rooms = []

msg-type =
	server: 'server'
	normal: 'normal'
	room-list: 'room-list'
	error: 'error'
	received-msg: 'server-callback'
	client-msg: 'client-message'
	room-created: 'room-created'

module.exports = !->


	#io := socket-io.listen global.app-setting.app-server, {log: false}
	io = global.app-setting.app-io
	chat = io.of '/chat'

	#create and then join this room
	
	chat.on 'connection', (err, socket, session) !->
		#session id		
		ssid = socket.handshake.cookies.ssid
		#send the current room list		
		socket.emit msg-type.room-list, {'msg': rooms}

		socket.on 'create-room', (room-name, user-name) !->
			try
				room-id = create-room socket, room-name, user-name
			catch e
				socket.emit msg-type.error, e
				return

			socket.user = {name: user-name, sessionId: ssid}
			
			join-room socket.room, socket			

			chat.emit msg-type.room-list, { 'msg': rooms}
						
			
			socket.emit msg-type.server,  {'msg': "You have joined the chat room #room-name(#room-id)"}
			socket.broadcast.to room-id .emit msg-type.server, {'msg': "User: #user-name has joined this room!"}
			
			socket.on msg-type.client-msg, (data)!->				
				if !data or !data.sender or !data.msg then return
				chat.in room-id .emit 'message', {'type': msg-type.normal, msg: data.msg, sender: data.sender}

			socket.emit msg-type.room-created, {'msg': "Room '#{socket.room.name}' was created."}

		socket.on 'join-room', (room-id, who) !->
			try
				if room = _.find(rooms, (room) -> room.id == room-id) != undefined
					then 
						socket.user = who

						/*socket.room = room-id
						socket.user-name = user-name
						socket.join room-id*/
						join-room room, socket
						socket.emit msg-type.server, {'msg': "You have joined the chat room #{room.id}"}
					else 
						socket.emit msg-type.error, {'msg': "the room #room-id not existed"}
			catch e
				socket.emit msg-type.error, {'msg': e}
				gulp-util.log e

		socket.on 'disconnect', !->
			leave-room socket


	console.log 'socket-io initialized succefully.'


function create-room(socket, name, user-name)
	do
		room-id = uid!
	while _.find rooms, (room) -> room.id == room-id

	if rooms.length >= 2 #then return {msg: 'the maximum number of rooms has been reached.', err-code: 2}
		throw 'the maximum number of rooms has been reached.'

	room = 
		id: room-id
		name: name
		users: []
	#specify the corresponding room
	socket.room = room
	rooms.push do
		room
	return room-id

function join-room(room, socket)
	#check if the user existed
	#if _.contains(room.users, who) == true then 
	user = _.find(room.users, (user) -> user.sessionId == socket.user.sessionId) 
	if user != undefined then
		#force to refresh the current user to this socket
		user = socket.user
		socket.emit msg-type.server, "You've already been in this room #{room.name}"
		return

	#user not yet joined the room
	socket.join room.id
	socket.room = room	
	room.users.push user
	

!function leave-room(socket)
	if typeof socket.room == 'undefined'
		return
	room = socket.room
	#console.log socket.room
	room.users = _.without(room.users, _.findWhere(room.users, {id: socket.id}))
	
	if room.users.length == 0 then
		rooms := _.without(rooms, room)
		#console.log "rooms.length: #{rooms.length}"
	console.log "#{socket.id} disconnected"
	

function uid
	ret = 'xxxx'
	ret = ret.replace /[x]/g, (c) ->
		r = Math.random! * 16 .|. 0
		v = if c == 'x' then r else r .&. 0x3 .|. 0x8
		v.toString(16)
	return ret

