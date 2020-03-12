//
//  ViewController.swift
//  Tiply_v0.1
//
//  Created by Syed Ali on 2/22/20.
//  Copyright © 2020 Syed Ali and Tommy Dato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer)
    {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 4 {
                self.tabBarController?.selectedIndex += 1
                
            }
        }
        else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
                
            }
        }
    }
    
    
}

