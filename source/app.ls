require! <[./setting.ls]>
global.app-setting.start! 

#chatroom
chat-room = require app-setting.app-path 'source/chatroom.ls'
chat-room!