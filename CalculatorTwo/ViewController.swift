//
//  ViewController.swift
//  CalculatorTwo
//
//  Created by Dmitriy on 22/09/2016.
//  Copyright © 2016 Dmitriy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    private var userIsInTheMiddleOfTyping: Bool = false
    let decimalSeparator = "."

    
    private var displayValue: Double? {
        get {
            if let text = display.text,
                let value = formatter.number(from: text)?.doubleValue {
                    return value
            }
            
            return nil
        }
        set {
            if let value = newValue {
                display.text = String(value)
                history.text = brain.description + (brain.isPartialResult ? " ..." : " =")
            } else {
                display.text = " "
                history.text = " "
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) {return}
            if (digit != decimalSeparator) && ((display.text == "0") || (display.text == "-0")) {
                display.text = digit
                return
            }
            if (digit != decimalSeparator) || (textCurrentlyInDisplay.range(of: decimalSeparator) == nil) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue!)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
           brain.performOperand(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        
        history.text = brain.description
        if history.text == " " {return}
        if brain.isPartialResult {
            history.text! += "..."
        } else {
            history.text! += "+"
        }
    }   

}

