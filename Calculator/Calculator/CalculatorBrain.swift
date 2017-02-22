//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Joe on 12/12/2016.
//  Copyright © 2016 Joe. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private enum OperationType {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double,Double)->Double)
        case Equals
    }
    
    private let operations = [
        "π": OperationType.Constant(M_PI),
        "√": OperationType.UnaryOperation(sqrt),
        "+": OperationType.BinaryOperation({$0 + $1}),
        "×": OperationType.BinaryOperation({$0 * $1}),
        "÷": OperationType.BinaryOperation({$0 / $1}),
        "−": OperationType.BinaryOperation({$0 - $1}),
        "=": OperationType.Equals
    ]
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double,Double)->Double
        var fistOperand: Double
    }
    
    private var pending: PendingBinaryOperationInfo?

    private func excuteBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.fistOperand, accumulator)
            pending = nil
        }
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let constantValue):
                pending = nil
                accumulator = constantValue
            case .UnaryOperation(let function):
                pending = nil
                accumulator = function(accumulator)
            case .BinaryOperation(let function): //先把操作数1和运算符存到pending里
                excuteBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, fistOperand: accumulator)
            case .Equals:
                excuteBinaryOperation()
            }
        }

    }
    

}












