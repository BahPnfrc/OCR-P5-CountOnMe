//
//  CountOnMe.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 05/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol DisplayDelegate {
    func didChangeInput(_ input: String)
    func didChangeOutput(_ output: String)
    func didShowError(_ error: Error)
}

enum Operand: String, CaseIterable {
    case addition = "+"
    case substraction = "−"
    case multiplication = "×"
    case division = "÷"
}

enum Error: String, CaseIterable {
    case undefined = "Une erreur est survenue"
    case whileComputing = "Une erreur intene est survenue"
    case numberIsRequired = "L'expression requière un chiffre"
    case expressionIsIncorrect = "L'expression est mal formatée"
    case divisionIsIncorrect = "La division par zéro est impossible"
}

class CountModel {
    
    var delegate: DisplayDelegate?
    
    private var _input: String = "" {
        didSet { delegate?.didChangeInput(_input) }
    }
    
    private var _inputToExpression: Expression? {
        return Expression(of: _input)
    }
    
    private var _result: Float? {
        didSet {
            if let result = _result {
                delegate?.didChangeOutput("= \(result)")
            } else { delegate?.didChangeOutput("") }
        }
    }
    
    // MARK: - EXPRESSION
    
    func reset() {
        _input = ""
        _result = nil
    }
    
    func addNumber(_ number: String?) {
        // Ensure something is passed
        guard let numberAsString = number
        else { delegate?.didShowError(.undefined) ; return }
        // Ensure it can be casted into a number
        guard let numberAsInt = Int(numberAsString)
        else { delegate?.didShowError(.numberIsRequired) ; return }
        // Ensure it's not a division by zero
        if numberAsInt == 0 {
            guard _input.hasSuffix(Operand.division.rawValue)
            else { delegate?.didShowError(.divisionIsIncorrect) ; return }
        }
        self._input.append(numberAsString)
    }
    
    func addOperand(_ operand: Operand) {
        guard let expression = _inputToExpression else {
            delegate?.didShowError(.undefined)
            return
        }
        guard expression.elements.count > 0 &&
                expression.lastElementIsNumber()
        else {
            delegate?.didShowError(.numberIsRequired)
            return
        }
        guard expression.isWellFormated() else {
            delegate?.didShowError(.expressionIsIncorrect)
            return
        }
        
        
        self._input.append(" \(operand.rawValue) ")
    }
    
    func getResult() {
        
        guard let expression = _inputToExpression
        else { delegate?.didShowError(.undefined) ; return }
        
        guard expression.lastElementIsNumber()
        else { delegate?.didShowError(.numberIsRequired) ; return }
        
        var elements = expression.elements
        while elements.count > 1 {
            
            guard expression.isCorrect
            else { delegate?.didShowError(.whileComputing) ; return }
            
            // Get an expression and compute for its result
            guard let operation = _returnNextOperation(from: elements)
            else { delegate?.didShowError(.whileComputing) ; return }
            
            let result = _returnResult(of: operation)
            guard let number = result.Result
            else {
                if let error = result.Error { delegate?.didShowError(error) }
                else { delegate?.didShowError(.whileComputing) }
                return
            }
            
            // Replace current expression with its result
            let newValue = [String(number)]
            guard let oldValues = operation.range
            else { delegate?.didShowError(.whileComputing) ; return }
            elements.replaceSubrange(oldValues, with: newValue)
        }

        guard let result = Float(elements.first!)
        else { delegate?.didShowError(.whileComputing) ; return }
        self._result = result
    }
    
    private func _returnNextOperation(from elements: [String]) -> Operation? {
        // Get operand index according to priority
        var operandIndex: Int
        if let firstMultiplicationIndex = elements.firstIndex(of: Operand.multiplication.rawValue) {
            operandIndex = firstMultiplicationIndex
        } else if let firstDivisionIndex = elements.firstIndex(of: Operand.division.rawValue) {
            operandIndex = firstDivisionIndex
        } else { operandIndex = 1 }
        
        // Get left and right item from operand index
        guard let operand = Operand.allCases.first(where: { $0.rawValue == elements[operandIndex] }),
              let leftItem = Float(elements[operandIndex - 1]),
              let rightItem = Float(elements[operandIndex + 1])
        else { return nil }
        var operation = Operation(leftItem, operand, rightItem)
        operation.range = operandIndex - 1...operandIndex + 1
        return operation
    }
    
    private func _returnResult(of operation: Operation) -> (Result: Float?, Error: Error?) {
        switch operation.operand {
        case Operand.addition:
            return (operation.leftItem + operation.rightItem, nil)
        case Operand.substraction:
            return (operation.leftItem - operation.rightItem, nil)
        case Operand.multiplication:
            return (operation.leftItem * operation.rightItem, nil)
        case Operand.division:
            guard !operation.isDivisionByZero else { return (nil, Error.divisionIsIncorrect) }
            return (operation.leftItem / operation.rightItem, nil)
        }
    }
}




