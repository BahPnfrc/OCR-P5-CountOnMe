//
//  CountOnMe.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 05/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol DisplayDelegate {
    func displaySetInput(_ input: String)
    func displaySetOutput(_ output: String)
    func displayShowError(_ error: String)
}

enum Operand: String, CaseIterable {
    case addition = "+"
    case substraction = "−"
    case multiplication = "×"
    case division = "÷"
}

enum Error: String {
    case generic = "Une erreur est survenue"
    case isInputDataType = ""
    case divisionByZero = "Diviser par 0 est impossible"
}

class CountOnMe {
    
    var delegate: DisplayDelegate?
    
    var input: String? {
        didSet { delegate?.displaySetInput(input ?? "") }
    }
    private func inputAppend(_ text: String) {
        self.input = self.input ?? "" + text
    }
    
    var inputExpression: Expression? {
        guard let input = self.input else { return nil }
        return Expression(of: input)
    }
    var result: Float? {
        didSet {
            guard let result = self.result else { return }
            self.output = "= \(result)"
        }
    }
    var output: String? {
        didSet {
            delegate?.displaySetOutput(output ?? "")
        }
    }
    
    // MARK: - EXPRESSION
    
    func expressionAddNumber(_ number: String?) {
        guard let numberAsString = number else {
            delegate?.displayShowError("BLABLA")
            return
        }
        guard Int(numberAsString) != nil else {
            delegate?.displayShowError("BLABLA")
            return
        }
        inputAppend(numberAsString)
    }
    
    func expressionAddOperand(_ operand: Operand) {
        guard let expression = inputExpression else {
            delegate?.displayShowError("BLABLA")
            return
        }
        guard expression.isCorrect else {
            delegate?.displayShowError("BLABLA")
            return
        }
        self.inputAppend(" \(operand.rawValue) ")
    }
    
    func expressionGetResult() {
        
        guard let expression = inputExpression else {
            delegate?.displayShowError("BLABLA")
            return
        }
        
        var elements = expression.elements
        while elements.count > 1 {
            
            guard expression.isCorrect else {
                delegate?.displayShowError("L'expression est mal formulée")
                return
            }
            
            // Get operand index according to priority
            var operandIndex: Int
            if let firstMultiplicationIndex = elements.firstIndex(of: Operand.multiplication.rawValue) {
                operandIndex = firstMultiplicationIndex
            } else if let firstDivisionIndex = elements.firstIndex(of: Operand.division.rawValue) {
                operandIndex = firstDivisionIndex
            } else { operandIndex = 1 }
            
            // Get left and right item from operand index
            let operand = elements[operandIndex]
            guard let leftItem = Float(elements[operandIndex - 1]),
                  let rightItem = Float(elements[operandIndex + 1])
            else {
                delegate?.displayShowError(Error.generic.rawValue)
                return
            }
            
            // Get an expression and compute for its result
            let operation = Operation(leftItem, operand, rightItem)
            let result = getResultOf(operation)
            guard let number = result.Result
            else {
                if let error = result.Error { delegate?.displayShowError(error.rawValue) }
                else { delegate?.displayShowError(Error.generic.rawValue) }
                return
            }
            
            // Replace current expression with its result
            let newValue = [String(number)]
            let oldValues = operandIndex - 1...operandIndex + 1
            elements.replaceSubrange(oldValues, with: newValue)
        }

        guard let result = Float(elements.first!) else {
            delegate?.displayShowError(Error.generic.rawValue)
            return
        }
        self.result = result
    }
    
    private func getResultOf(_ operation: Operation) -> (Result: Float?, Error: Error?) {
        switch operation.operand {
        case Operand.addition: return (operation.leftItem + operation.rightItem, nil)
        case Operand.substraction: return (operation.leftItem - operation.rightItem, nil)
        case Operand.multiplication: return (operation.leftItem * operation.rightItem, nil)
        case Operand.division:
            guard operation.rightItem != 0 else { return (nil, Error.divisionByZero) }
            return (operation.leftItem / operation.rightItem, nil)
        }
    }
        
    func reset() {
        input = nil
        output = nil
    }

}




