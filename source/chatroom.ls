require! <[http]>
socket-io = require 'socket.io'
var io, chat
_ = require 'underscore'
app = global.app-setting.app-engine

rooms = []



module.exports = !->
	io := socket-io.listen global.app-setting.app-server
	chat = io.of '/chat'

	#create and then join this room
	
	chat.on 'connection', (socket) !->
		socket.on 'create-room', (room-name, user-name) !->
			try
				room-id = create-room room-name
			catch e
				socket.on 'error', e
			socket.room = room-id
			socket.user-name = user-name
			socket.join room-id
			socket.emit 'message', {'msg': "You have joined the chat room #room-name(#room-id)", }
			socket.broadcast.to room-id .emit {'msg': "User: #user-name has joined this room!"}
			socket.on 'message', (data)!->				
				if !data or !data.sender or !data.msg then return
				chat.in room-id .emit 'message', {msg: data.msg, sender: data.sender}

		socket.on 'join-room', (room-id, user-name) !->
			if room = _.find(rooms, (room) -> room.id == room-id) != undefined
				then 
					socket.room = room-id
					socket.user-name = user-name
					socket.join room-id
					socket.emit 'message', {msg: "You have joined the chat room #{room.id}"}
				else 
					socket.emit 'error', {msg: "the room #room-id not existed"}



	console.log 'socket-io initialized succefully.'


function create-room(name)
	do
		room-id = uid!
	while _.find rooms, (room) -> room.id == room-id

	if rooms.length >= 2 #then return {msg: 'the maximum number of rooms has been reached.', err-code: 2}
		throw 'the maximum number of rooms has been reached.'

	rooms.push do
		id: room-id
	return room-id

function uid
	ret = 'xxxx'
	ret = ret.replace /[x]/g, (c) ->
		r = Math.random! * 16 .|. 0
		v = if c == 'x' then r else r .&. 0x3 .|. 0x8
		v.toString(16)
	return ret

