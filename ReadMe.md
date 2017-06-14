# TicTacToe Socket.IO

**CocoaPods 1.0.0 or later**

Create Podfile and add pod 'Socket.IO-Client-Swift':

```sh
 platform :ios, '9.0'

target 'DemoNodeSocketIO' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Socket.IO-Client-Swift'
  # Pods for DemoNodeSocketIO

end
```

Install pods:

```sh
$ pod install
```

Import the module:

**Swift**
```sh
import SocketIO
```
**Example**

**Server**

create index.js :
```sh

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
  })
})
```

Client Swift: 

```sh
import SocketIO

let socket = SocketIOClient(socketURL: URL(string: "http://192.168.0.175:2016")!, config: [.log(true), .forcePolling(true)])

override func viewDidLoad() {
        super.viewDidLoad()
        socket.connect()
        socket.on("thongbaonhanve", callback: {(data,ack) in
            let arr = data[0]
            let alertController = UIAlertController(title: "", message: arr as! String, preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Play again", style: .default, handler: {(action) -> Void in
                self.count = 0
                
                self.gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
                self.gameIsActive = true
                self.activePlayer = 1
                for i in 1...9 {
                    let button = self.view.viewWithTag(i) as! UIButton
                    button.setImage(nil, for: .normal)
                }
                
            })
            let cancel = UIAlertAction(title: "CANCEL", style: .destructive, handler: {(action) -> Void in
                exit(1)
            })
            alertController.addAction(ok)
            alertController.addAction(cancel)
            self.present(alertController,animated: true, completion: nil)
            
            
        })
}
```

