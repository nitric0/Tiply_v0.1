//
//  ItemizationViewController.swift
//  Tiply_v0.1
//
//  Created by Syed Ali on 3/4/20.
//  Copyright © 2020 Syed Ali. All rights reserved.
//

import UIKit

class ItemizationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //cell.detailTextLabel?.text = ""
        // Do any additional setup after loading the view.
    }
    //-----------TABLE----------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    var cell: UITableViewCell = UITableViewCell()
    var concatString: String? = ""
    var globalStr: String? = ""
    var globalIndexPath = IndexPath()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let person = personList[indexPath.row]
        globalIndexPath = indexPath
        cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        
                       // Configure the cell...
                       
        cell.textLabel?.text = person

        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        //tableView.reloadData()
        return cell
    }
     //-----------END TABLE----------------------
    
    var selectedPerson: String?
    var personList: [String] = []
    {
        didSet {
            tableView.reloadData()
        }
    }

    
    //-------------PICKER------------
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
    //-------------END PICKER------------
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addPersonTextField: UITextField!
    @IBOutlet weak var personTextField: UITextField!
  
    @IBAction func addPerson(_ sender: UIButton) {
        if addPersonTextField.text! != "" {
            personList.append(addPersonTextField.text!)
                addPersonTextField.text = ""
        }
    }
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemCost: UITextField!
    @IBOutlet weak var personNameForItem: UITextField!
    
    @IBAction func addItem(_ sender: UIButton) {
        
        globalStr = addItems()

        concatString = "\(concatString!) \(globalStr!)"

        for i in 0...personList.count {
            if(personNameForItem.text! == personList[i])
            {
                //tableView.beginUpdates()
                //print(globalIndexPath.section)
                let indexPath = IndexPath(row: i, section: globalIndexPath.section)
                cell = tableView.cellForRow(at: indexPath)!
                print(cell.textLabel?.text! ?? "")
                cell.detailTextLabel?.text = concatString
                //tableView.reloadData()
                //tableView.endUpdates()
                break
            }


        }
        print(globalIndexPath.count)
        print(cell.textLabel!.text!)
        print(globalIndexPath.item)
        print(globalIndexPath.section)
      
   
        //cell = tableView.dequeueReusableCell(withIdentifier: "person", for: globalIndexPath)
        //cell.detailTextLabel?.text = concatString
        
        
    }
    
    func addItems() -> String? {
        
        return itemName.text! + " "  + itemCost.text! + ","
    }
    
    
    

    
 
}
