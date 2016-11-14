//
//  CalculatorBrain.swift
//  CalculatorTwo
//
//  Created by Dmitriy on 26/09/2016.
//  Copyright © 2016 Dmitriy. All rights reserved.
//

import Foundation


enum Optional<T> {
    case None
    case Some(T)
}

class CalculatorBrain
{
    private var accumulator = 0.0
    private var descriptionAccumulator = "0" {
        didSet {
            if pending == nil {
                currentPrecedence = Int.max
            }
        }
    }
    
    private var currentPrecedence = Int.max
    
    func setOperand(operand: Double) {
        accumulator = operand
        descriptionAccumulator = String(format: "%g", accumulator)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "rand": Operation.NullaryOperation(drand48, "rand()"),
        "pi" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }, { "-(" + $0 + ")"}),
        "√" : Operation.UnaryOperation(sqrt, { "√(" + $0 + ")"}),
        "cos" : Operation.UnaryOperation(cos, { "cos(" + $0 + ")"}),
        "sin" : Operation.UnaryOperation(sin, { "sin(" + $0 + ")"}),
        "tan" : Operation.UnaryOperation(tan, { "tan(" + $0 + ")"}),
        "sin-1" : Operation.UnaryOperation(asin, { "sin-1(" + $0 + ")"}),
        "cos-1" : Operation.UnaryOperation(acos, { "cos-1(" + $0 + ")"}),
        "tan-1" : Operation.UnaryOperation(atan, { "tan-1(" + $0 + ")"}),
        "ln" : Operation.UnaryOperation(log, { "ln(" + $0 + ")"}),
        "x-1" : Operation.UnaryOperation({ 1.0/$0 }, { "(" + $0 + ")-1"}),
        "x2" : Operation.UnaryOperation({ $0 * $0 }, { "(" + $0 + ")2"}),
        "xy" : Operation.BinaryOperation(pow, { $1 + "^" + $1 }, 2),
        "×" : Operation.BinaryOperation(*, { $1 + "×" + $1 }, 1),
        "÷" : Operation.BinaryOperation(/, { $1 + "÷" + $1 }, 1),
        "+" : Operation.BinaryOperation(+, { $1 + "+" + $1 }, 0),
        "-" : Operation.BinaryOperation(-, { $1 + "-" + $1 }, 0),
        "=" : Operation.Equals,
        "C" : Operation.C
    ]
    
    private enum Operation {
        case NullaryOperation(() -> Double, String)
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String, Int)
        case Equals
        case C
    }
    
    func performOperand(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .NullaryOperation(let function, let descriptionValue):
                accumulator = function()
                descriptionAccumulator = descriptionValue
            case .Constant( let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .UnaryOperation( let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation( let function, let descriptionFunction, let precedence):
                executePendingBinaryOperation()
                if currentPrecedence < precedence {
                    descriptionAccumulator = "(" + descriptionAccumulator + ")"
                }
                currentPrecedence = precedence
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .C:
                clear()
            }
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
        descriptionAccumulator = " "
        currentPrecedence = Int.max
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            } else {
                return pending!.descriptionFunction(pending!.descriptionOperand, pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
            }
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
}

class CalculatorFormatter: NumberFormatter {
    required init?(coder aDecoder: NSCoder ) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.locale = NSLocale.current
       // self.numberStyle = .NumberStyle
        self.maximumFractionDigits = 6
        self.notANumberSymbol = "Error"
        self.groupingSeparator = " "
    }
}

let formatter = CalculatorFormatter()
 
