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
		chat.emit msg-type.room-list, {'msg': rooms}
		
		socket.on 'create-room', (room-name, user-name) !->			
			var room
			try
				room = create-room room-name
			catch e
				socket.emit msg-type.error, e
				console.log "created room error: #e"
				return
			
			socket.user = {name: user-name, socketId: socket.id}
			
			join-room room, socket		

			socket.emit msg-type.room-list, { 'msg': rooms}
			socket.broadcast.emit msg-type.room-list, { 'msg': rooms}
			gulp-util.log(rooms)			
			socket.emit msg-type.server,  {'msg': "You have joined the chat room #room-name(#{room.id})"}
			socket.broadcast.to room.id .emit msg-type.server, {'msg': "User: #user-name has joined this room!"}
			
			socket.on msg-type.client-msg, (data)!->				
				if !data or !data.msg then return
				chat.in socket.room.id .emit msg-type.normal, {msg: data.msg, sender: socket.user}

			socket.emit msg-type.room-created, {'msg': "Room '#{socket.room.name}' was created."}

		socket.on 'join-room', (room-id, user-name) !->					
			try
				if (room = _.find(rooms, (room) -> room.id == room-id)) != undefined
					then 
						who = {name: user-name, socketId: socket.id}						
						socket.user = who

						/*socket.room = room-id
						socket.user-name = user-name
						socket.join room-id*/
						if join-room room, socket
							socket.emit msg-type.server, {'msg': "You have joined the chat room #{room.id}"}

					else 
						socket.emit msg-type.error, {'msg': "the room #room-id not existed"}
			catch e
				socket.emit msg-type.error, {'msg': e}
				gulp-util.log e

		socket.on 'disconnect', !->
			leave-room socket
			console.log "socket id: #{socket.id} disconnected"


	console.log 'socket-io initialized succefully.'


function create-room(name)
	do
		room-id = uid!
	while _.find rooms, (room) -> room.id == room-id

	if rooms.length >= 2 #then return {msg: 'the maximum number of rooms has been reached.', err-code: 2}
		throw 'the maximum number of rooms has been reached.'

	room = 
		id: room-id
		name: name
		users: []
	rooms.push do
		room

	return room

!function join-room(room, socket)
	#check if the user existed
	#if _.contains(room.users, who) == true then
	user = _.find(room.users, (user) -> user.socketId == socket.user.socketId) 
	if user != undefined then

		#force to refresh the current user to this socket		
		user = socket.user
		socket.emit msg-type.server, {msg: "You've already been in this room #{room.name}"}
		gulp-util
		return false

	leave-room socket
	#user not yet joined the room
	socket.join room.id
	socket.room = room	
	room.users.push socket.user

	socket.emit 'room-joined', room

	return true

!function leave-room(socket)
	if typeof socket.room == 'undefined'
		return
	room = socket.room
	#console.log socket.room
	room.users = _.without(room.users, _.findWhere(room.users, {socketId: socket.id}))
	
	if _.isUndefined(room.users) || room.users.length == 0 then
		rooms := _.without(rooms, room)

	socket.emit msg-type.server, {msg: "You've left the room(#{room.name})"}
	console.log "#{socket.id} left room: #{socket.room.name}"
	
	socket.room = undefined

function uid
	ret = 'xxxx'
	ret = ret.replace /[x]/g, (c) ->
		r = Math.random! * 16 .|. 0
		v = if c == 'x' then r else r .&. 0x3 .|. 0x8
		v.toString(16)
	return ret

