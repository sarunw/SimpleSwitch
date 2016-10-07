//
//  ViewController.swift
//  SimpleSwitch
//
//  Created by Sarun Wongpatcharapakorn on 10/05/2016.
//  Copyright (c) 2016 Sarun Wongpatcharapakorn. All rights reserved.
//

import UIKit
import SimpleSwitch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ss = SimpleSwitch(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        ss.center = view.center
        var frame = ss.frame
        frame.origin.y -= 160
        ss.frame = frame
        view.addSubview(ss)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    func didTap(sender: AnyObject) {
        print("tap")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapToggleEnable(_ sender: AnyObject) {
        for subview in view.subviews {
            guard let s = subview as? SimpleSwitch else {
                continue
            }
            
            s.isEnabled = !s.isEnabled
        }
    }
}

