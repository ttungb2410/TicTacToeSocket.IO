//
//  ViewController.swift
//  DemoNodeSocketIO
//
//  Created by TTung on 6/11/17.
//  Copyright © 2017 TTung. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    var activePlayer = 1
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    let winningCombination = [[0, 1, 2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    var gameIsActive = true
    var count = 0;
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.0.175:2016")!, config: [.log(true), .forcePolling(true)])
    var senderTmp:UIButton?
    var button:UIButton?
    
    @IBAction func action(_ sender: UIButton) {
        
        if  (gameState[sender.tag-1] == 0 && gameIsActive == true)
        {
            gameState[sender.tag-1] = activePlayer
            senderTmp = sender
            socket.emit("vitri", with: [sender.tag])
             print("      TAGGGGGGGGGGDiiiiiiiiiiiiiiiiiiii:\(sender.tag)")
            if (activePlayer == 1) {
                sender.setImage(UIImage(named: "cross"), for: .normal)
                activePlayer = 2
                socket.emit("nuocdi", with: ["cross"])
                socket.emit("luotchoi", with: [activePlayer])
            } else {
                sender.setImage(UIImage(named: "nought"), for: .normal)
                activePlayer = 1
                socket.emit("nuocdi", with: ["nought"])
                socket.emit("luotchoi", with: [activePlayer])
            }
            
            
        }
        count = count + 1
        for combination in winningCombination {
            
            if (gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]])
            {
                let alertController:UIAlertController!
                gameIsActive = false
                if gameState[combination[0]] == 1 {
                    // Cross has won
                    alertController = UIAlertController(title: "", message: "Cross has won!", preferredStyle: UIAlertControllerStyle.alert)
                    socket.emit("thongbao", with: ["Cross has won!"])
                    
                } else{
                    //nought has won
                    alertController = UIAlertController(title: "", message: "Nought has won!", preferredStyle: UIAlertControllerStyle.alert)
                    socket.emit("thongbao", with: ["Nought has won!"])
                    
                }
                
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
                
                
            }
            
        }
        if (count == 9){
            let alertController = UIAlertController(title: "", message: "Game Draw!", preferredStyle: UIAlertControllerStyle.alert)
            self.socket.emit("thongbao", with: ["Game Draw!"])
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
        }
    }
    
    
    
    
    
    
    
    
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
        socket.on("vitrinhanve", callback: {(data,ack) in
            let arr = data[0]
            self.senderTmp?.tag = arr as! Int
            self.button = self.view.viewWithTag(arr as! Int) as! UIButton?
            
            print("         TAGGGGGGGGGGGGGVeeeeeeeeeee:\(self.senderTmp?.tag)")
            
        })
        socket.on("luotchoinhanve", callback: {(data,ack) in
            
            let arr = data[0]
            self.activePlayer = arr as! Int
            print(self.activePlayer)
        })
        socket.on("nuocdinhanve", callback: {(data,ack) in
            let arr = data[0]
            //            self.senderTmp?.setImage(UIImage(named: arr as! String), for: .normal)
            self.button?.setImage(UIImage(named: arr as! String), for: .normal)
            
        })
       
        
        
    }
    
    
    
    
}


