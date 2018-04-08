//
//  ViewController.swift
//  NodeJs
//
//  Created by Mac Pro on 3/29/18.
//  Copyright © 2018 Mac Pro. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    
    let socketManager = SocketManager(socketURL: URL.init(string: "http://localhost:2018")!,
                                config: [.log(true), .compress])
    var socket: SocketIOClient?

    @IBOutlet weak var redView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = socketManager.defaultSocket
        socket?.connect()
        socket?.on("data", callback: { (data, ack) in
            print("haha__" + "\(data)")
        })
        socket?.on("viewPointReceive", callback: { (data, ack) in
            if let points = data[0] as? NSArray,
                let x = points[0] as? CGFloat,
                let y = points[1] as? CGFloat {
                self.redView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, x, y, 0)
            }
        })
    }
    
    @IBAction func panRedView(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: redView)
        socket?.emit("viewPoint", with: [[point.x,point.y]])
    }
    
}

