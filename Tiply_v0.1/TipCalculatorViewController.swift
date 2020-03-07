//
//  TipCalculatorViewController.swift
//  Tiply_v0.1
//
//  Created by Thomas Dato on 3/6/20.
//  Copyright © 2020 Syed Ali. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController {

    
    @IBOutlet weak var billTotalInput: UITextField!
    @IBOutlet weak var billTotalLabel: UILabel!
    @IBOutlet weak var partySizeStepper: UIStepper!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var rbTipLabel: UILabel!
    @IBOutlet weak var standardTipLabel: UILabel!
    @IBOutlet weak var tipperPersonLabel: UILabel!
    @IBOutlet weak var totalperPersonLabel: UILabel!
    
    var tipModifier : Float = 100.0
    var billTotal : Double = 0.0
    var billTotalText : String = "$0.00"
    var tipTotal : Double = 0.0
    var numPeople : Int = 1
    var roundTip : Bool = false
    var tipPerPerson : Double = 0.0
    var totalPerPerson : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        
        if let bText = billTotalLabel.text {
            if (bText.isEmpty || bText == "$0.00")
            {
                let alertController = UIAlertController(title: "Empty Field", message: "Please Enter Bill Amount", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                // calculate rating based tip
                   let modifier = Double((Double(tipModifier/100) * 20)/100)
                   var tip = billTotal * modifier
                   
                   if (roundTip) {
                       tip.round()
                   }
                   rbTipLabel.text = convertDoubleToCurrency(amount: tip)
                   
                   // calculate tip person
                   tipPerPerson = tip / Double(numPeople)
                   tipperPersonLabel.text = convertDoubleToCurrency(amount: tipPerPerson)
                   let total = billTotal + tip
                   
                   // calculate total per person
                   totalPerPerson = total / Double(numPeople)
                   totalperPersonLabel.text = convertDoubleToCurrency(amount: totalPerPerson)
                   
            }
        }
   
    }
    
    
    @IBAction func partySizeStepperPressed(_ sender: UIStepper) {
        partySizeLabel.text = Int(sender.value).description
        numPeople = Int(sender.value)
    }
    
    @IBAction func friendlinessSliderMoved(_ sender: UISlider) {
        // The slider for friendliness
        tipModifier += ( sender.value * 10)
    }
    
    @IBAction func quicknessSliderMoved(_ sender: UISlider) {
        // The slider for quickness
        tipModifier += ( sender.value * 10)
    }
    
    @IBAction func attentivenessSliderMoved(_ sender: UISlider) {
        // the slider for attentiveness
        tipModifier += ( sender.value * 10)
    }
    
    @IBAction func qualitySliderMoved(_ sender: UISlider) {
        // the slider for quality
        tipModifier += ( sender.value * 10)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
