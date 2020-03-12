//
//  ItemizationViewController.swift
//  Tiply_v0.1
//
//  Created by Syed Ali on 3/4/20.
//  Copyright © 2020 Syed Ali and Tommy Dato. All rights reserved.
//

import UIKit

class ItemizationViewController: UIViewController {
    
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var runningTotalLabel: UILabel!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemCost: UITextField!
    @IBOutlet weak var personNameForItem: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPersonTextField: UITextField!
    @IBOutlet weak var personTextField: UITextField!
    

    
    var cell: UITableViewCell = UITableViewCell()
    var concatString: String? = ""
    var globalStr: String? = ""
    var globalIndexPath = IndexPath()
    var itemList: [String] = []
    var startItem: Bool = true
    var runningTotal : Double = 0.0
    var runningTotalText : String = "$0.00"
    var selectedPerson: String?
    let chosenFont = "Roboto"
    var personList: [String] = []
    {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //Swiping gesture for tab bar controller
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        //cell.detailTextLabel?.text = ""
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Swipe Gesture Test
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
    
    
    //MARK: - IBActions
    @IBAction func addPerson(_ sender: UIButton) {
        if addPersonTextField.text! != "" {
            personList.append(addPersonTextField.text!)
            addPersonTextField.text = ""
        } else {
            let alertController = UIAlertController(title: "Empty Field", message: "Please enter person name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                return
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        startItem = false
    }
    
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        for tf in textFields {
            tf.text = ""
        }
    }
    
    @IBAction func touchedBackground(_ sender: UIControl) {
        
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        var pText = ""
        var costText = ""
        var iText = ""
        
        if let personText = personTextField.text {
            pText = personText
        }
        
        if let itemCostText = itemCost.text {
            costText = itemCostText
        }
        
        if let iName = itemName.text {
            iText = iName
        }
        
        
        if (pText.isEmpty) {
            // if they did not select a person to assign the item to
            let alertController = UIAlertController(title: "Empty Field", message: "Please choose a person", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else if (costText.isEmpty) {
            // if they did not enter a price for the item
            let alertController = UIAlertController(title: "Empty Field", message: "Please enter item cost", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if (iText.isEmpty) {
            // Maybe take this one out
            let alertController = UIAlertController(title: "Empty Field", message: "Please enter item name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            if let itemInput = Double(costText)
            {
                runningTotal += itemInput
                runningTotalText = convertDoubleToCurrency(amount: runningTotal)
                runningTotalLabel.text = runningTotalText
            }
            
            if startItem == false {
                
                itemList.reserveCapacity(personList.count)
                for _ in 0...personList.count {
                    itemList.append("")
                }
                
            }
            startItem = true
            globalStr = addItems()
            
            concatString = "\(concatString!) \(globalStr!)"
            
            for i in 0...personList.count {
                if(personNameForItem.text! == personList[i])
                {
                    //tableView.beginUpdates()
                    //print(globalIndexPath.section)
                    //itemList[i] = concatString!
                    let indexPath = IndexPath(row: i, section: globalIndexPath.section)
                    cell = tableView.cellForRow(at: indexPath)!
                    print(cell.textLabel?.text! ?? "")
                    cell.detailTextLabel?.font = UIFont(name: chosenFont, size: 14)
                    cell.detailTextLabel?.text = itemList[i]
                    //tableView.reloadData()
                    //tableView.endUpdates()
                    break
                }
            }
            //print(globalIndexPath.count)
            //print(cell.textLabel!.text!)
            //print(globalIndexPath.item)
            //print(globalIndexPath.section)
            
            //cell = tableView.dequeueReusableCell(withIdentifier: "person", for: globalIndexPath)
            //cell.detailTextLabel?.text = concatString
            // clear the text fields when the method ends
            clearTextFields()
        }
    }
    //MARK: - Functions
    func clearTextFields() {
        
        for textField in textFields {
            textField.text = ""
        }
    }
    
    func addItems() -> String? {
        
        for i in 0...personList.count {
            if personList[i] == personNameForItem.text! {
                let str = itemName.text! + " $"  + itemCost.text! + ", "
                itemList[i] = itemList[i] + str
                break
            }
        }
        return itemName.text! + " "  + itemCost.text! + ","
        
    }
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: input)?.doubleValue
        
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    
    
}

//MARK: - ItemizationViewController extension
extension ItemizationViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UITableView for ItemizationViewController
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print(indexPath.row)
        let person = personList[indexPath.row]
        globalIndexPath = indexPath
        cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        cell.detailTextLabel?.numberOfLines = 3; // set the numberOfLines
        cell.textLabel?.font = UIFont(name: chosenFont, size: 18)
        cell.detailTextLabel?.lineBreakMode = .byTruncatingTail;
        // Configure the cell...
        
        cell.textLabel?.text = person
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        //tableView.reloadData()
        return cell
    }
    
    
    //MARK: - UIPicker for ItemizationViewController
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return personList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if !personList.isEmpty
        {
            personTextField.text = personList[0]
        }
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
}
