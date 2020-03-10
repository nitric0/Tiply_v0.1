//
//  WhoPaysViewController.swift
//  Tiply_v0.1
//
//  Created by Syed Ali on 3/4/20.
//  Copyright © 2020 Syed Ali. All rights reserved.
//

import UIKit

class WhoPaysViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Swiping gesture for tab bar controller
                  let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
                  swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                  self.view.addGestureRecognizer(swipeRight)
                  
                  let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
                  swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                  self.view.addGestureRecognizer(swipeLeft)
         textView.backgroundColor = .darkGray
         textView.textColor = .white
         randomPersonText.textColor = .red
         randomPersonText.textAlignment = .center
         textField.text = "Add a person here"
        // Do any additional setup after loading the view.
    }
    
    //Swipe Gesture Test
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
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if !personList.isEmpty
        {
            self.randomPersons()
        }
        
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    //List of people
    var personList: [String] = []
    @IBAction func addPerson(_ sender: UIButton) {
        
        textView.text = ""
          var message = ""
          if textView != nil{
              //adding text field items into an array
              if textField.hasText {
               personList.append(textField.text!)
              }
          }
          
          var i = 0
          while i < personList.count {
              message += "\(i + 1).  \(personList[i])\n"
              i = i + 1
          }
          
          textView.text = message
          textField.text = ""
    }
    
    @IBOutlet weak var randomPersonText: UITextView!
    
    func randomPersons() {
           //var randomPerson = ""
           for _ in 0...personList.count {
               randomPersonText.text  = personList.randomElement()!
           }
           
           //randomPersonText.text = randomPerson
           
       }
    
}
