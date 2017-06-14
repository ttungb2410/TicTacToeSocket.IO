var express = require('express')
var app = express()
var server = require('http').Server(app)
var io = require('socket.io')(server)

server.listen(2016,function () {
	io.on('connection',function(socket){
		console.log('Co nguoi ket noi')
	socket.on('langnghe',function(data){
		console.log(data)
		io.sockets.emit('data',data)
	})

	socket.on('toado',function(data){
		console.log(data)
		io.sockets.emit('todonhanve',data)
	})
	socket.on('nuocdi',function(data){
		console.log("nuocdi")
		console.log(data)
		io.sockets.emit('nuocdinhanve',data)
	})
	socket.on('luotchoi',function(data){
		console.log("luotchoi")
		console.log(data)
		io.sockets.emit('luotchoinhanve',data)
	})
	socket.on('vitri',function(data){
		console.log("vitri")
		console.log(data)
		io.sockets.emit('vitrinhanve',data)
	})
	socket.on('thongbao',function(data){
		console.log("thongbao")
		console.log(data)
		io.sockets.emit('thongbaonhanve',data)
	})
	})
})
