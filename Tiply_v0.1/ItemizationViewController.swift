//
//  ItemizationViewController.swift
//  Tiply_v0.1
//
//  Created by Syed Ali on 3/4/20.
//  Copyright © 2020 Syed Ali. All rights reserved.
//

import UIKit

class ItemizationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return personList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return personList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPerson = personList[row]
        personTextField.text = selectedPerson
    }
    
    var selectedPerson: String?
    var personList: [String] = []
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           personTextField.inputView = pickerView
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       personTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }


    
    @IBOutlet weak var personTextField: UITextField!
    @IBAction func addPerson(_ sender: UITextField) {
        personList.append(sender.text!)
        sender.text = ""
    }
    

}
