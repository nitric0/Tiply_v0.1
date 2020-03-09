//
//  TipCalculatorViewController.swift
//  Tiply_v0.1
//
//  Created by Thomas Dato on 3/6/20.
//  Copyright © 2020 Tommy Dato and Syed Ali. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var billTotalInput: UITextField!
    @IBOutlet weak var billTotalLabel: UILabel!
    @IBOutlet weak var partySizeStepper: UIStepper!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var rbTipLabel: UILabel!
    @IBOutlet weak var standardTipLabel: UILabel!
    @IBOutlet weak var tipperPersonLabel: UILabel!
    @IBOutlet weak var totalperPersonLabel: UILabel!
    @IBOutlet weak var standardTipTextField: UITextField!
    
    @IBOutlet var ratingSliders: [UISlider]!
    
    var tipModifier : Float = 100.0
    var billTotal : Double = 0.0
    var billTotalText : String = "$0.00"
    var tipTotal : Double = 0.0
    var numPeople : Int = 1
    var roundTip : Bool = false
    var tipPerPerson : Double = 0.0
    var totalPerPerson : Double = 0.0
    var selectedTip : String = "20%"
    
    let tipList : [String] = ["10%", "15%", "18%", "20%", "22%", "25%"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPickerView()
        dismissPickerView()
        partySizeStepper.minimumValue = 1
        partySizeStepper.maximumValue = 100
        partySizeStepper.wraps = true
        partySizeStepper.value = 1
    }
    @IBAction func updateTotalButtonPressed(_ sender: UIButton) {
        
        if let textIn = billTotalInput.text {
            var title = ""
            var message = ""
            
            if (textIn.isEmpty) {
                
                title = "Empty Field"
                message = "Please Enter Bill Amount"
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                if let bT = Double(textIn) {
                    // Double version
                    billTotal = bT
                    // string version
                    billTotalText = convertDoubleToCurrency(amount: bT)
                    billTotalLabel.text = billTotalText
                    // reset the textfield text upon entering value
                    billTotalInput.text = ""
                    billTotalInput.resignFirstResponder()
                } else {
                    title = "Non Numerical Quantity"
                    message = "Please Enter Quantity as Numerical Value"

                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {action in
                        // reset the textfield
                        self.billTotalInput.text = ""
                        
                    }))

                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    func calculateTipModifier()
    {
        var sliderTotals : Float = 0.0
        for slider in ratingSliders {
            sliderTotals += (slider.value/1.5)
        }
        sliderTotals *= 10

        tipModifier = 100 + sliderTotals
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        
        if let bText = billTotalLabel.text {
            if (bText.isEmpty || bText == "$0.00")
            {
                let alertController = UIAlertController(title: "Empty Field", message: "Please Enter Bill Amount", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                // calculate rating based tip
                calculateTipModifier()
                let modifier = Double((Double(tipModifier/100) * 20)/100)
                var tip = billTotal * modifier
               
                if (roundTip) {
                    tip = ceil(tip)
                }
                rbTipLabel.text = convertDoubleToCurrency(amount: tip)
               
                // calculate tip person
                tipPerPerson = tip / Double(numPeople)
                tipperPersonLabel.text = convertDoubleToCurrency(amount: tipPerPerson)
                let total = billTotal + tip
               
                // calculate total per person
                totalPerPerson = total / Double(numPeople)
                totalperPersonLabel.text = convertDoubleToCurrency(amount: totalPerPerson)
                
                
                // standard tip label
                let sTip = getStandardTip(selectedTip)
                standardTipLabel.text = convertDoubleToCurrency(amount: sTip)
                
                   
            }
        }
   
    }
    
    
    @IBAction func partySizeStepperPressed(_ sender: UIStepper) {
        partySizeLabel.text = Int(sender.value).description
        numPeople = Int(sender.value)
    }
    
    
    @IBAction func roundtipSwitchToggle(_ sender: UISwitch) {
        sender.setOn(sender.isOn, animated: true)
        roundTip = sender.isOn
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
    @IBAction func editEnded(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func backgroundTouched(_ sender: UIControl) {
        billTotalInput.resignFirstResponder()
    }
    
    
    //-------------PICKER------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //number of session
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTip = tipList[row]
        standardTipTextField.text = selectedTip
    }
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           standardTipTextField.inputView = pickerView
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       standardTipTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    
    func getStandardTip(_ percentage : String) -> Double {
        var result : Double = 0.0
        var temp = percentage
        if let i = percentage.firstIndex(of: "%") {
            temp.remove(at: i)
        }
        if let d : Double = Double(temp)
        {
            
            let percent = d / 100
            result = billTotal * percent
        }
        return result
    }
    //-------------END PICKER------------
    
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        sender.value = roundf(sender.value)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
