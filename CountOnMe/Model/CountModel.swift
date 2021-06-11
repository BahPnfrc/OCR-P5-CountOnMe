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
    func didShowError(_ error: ErrorMessage)
}

enum Operand: String, CaseIterable {
    case addition = "+"
    case substraction = "−"
    case multiplication = "×"
    case division = "÷"
}

enum ErrorMessage: String {
    case generic = "Une erreur est survenue"
    case whileComputing = "Une erreur intene est survenue"
    case numberIsRequired = "L'expression requière un chiffre"
    case expressionIsIncorrect = "L'expression est mal formatée"
    case divisionByZero = "La division par zéro est impossible"
}

enum ErrorThrow: Error {
    case divisionByZero(message: ErrorMessage = ErrorMessage.divisionByZero)
    case generic(message: ErrorMessage = ErrorMessage.generic)
}

class CountModel {

    var guardPrint: Bool = true // Print to console for debugging purposes
    func guardFailed(in function: String, at line: Int, minoredBy: Int? = 1) {
        if guardPrint { print("⚠️ Guard failed in \"\(function)\" at line \(line - minoredBy!)") }
    }
    
    // MARK: - PROPERTIES
    
    var delegate: DisplayDelegate?

    var input: String = "" {
        didSet { delegate?.didChangeInput(input) }
    }

    var inputToExpression: Expression {
        return Expression(of: input)
    }

    var result: Float? {
        didSet {
            if let result = result {
                delegate?.didChangeOutput("= \(result)")
            } else { delegate?.didChangeOutput("") }
        }
    }

    // MARK: - ADD FUNCTIONS

    func addNumber(_ number: String?) {
        // Ensure an input exists
        guard let numberAsString = number else {
            guardFailed(in: #function, at: #line)
            delegate?.didShowError(.generic)
            return
        } // Ensure this input is a number
        guard let numberAsInt = Int(numberAsString) else {
            guardFailed(in: #function, at: #line)
            delegate?.didShowError(.numberIsRequired)
            return
        } // Address zero division attempt
        if numberAsInt == 0 {
            guard !input.hasSuffix(" \(Operand.division.rawValue) ") else {
                guardFailed(in: #function, at: #line)
                delegate?.didShowError(.divisionByZero)
                return
            }
        } // Input safe data only
        self.input.append(numberAsString)
    }

    func addOperand(_ operand: Operand) {
        let expression = self.inputToExpression
        // Ensure operand comes after a number
        guard expression.lastElementIsNumber() else {
            guardFailed(in: #function, at: #line)
            delegate?.didShowError(.numberIsRequired)
            return
        } // Input safe data only
        self.input.append(" \(operand.rawValue) ")
    }

    // MARK: - COMPUTE FUNCTIONS
    
    func getResult() {
        // Turn current input into an array
        let expression = self.inputToExpression
        guard expression.lastElementIsNumber() else {
            guardFailed(in: #function, at: #line)
            delegate?.didShowError(.numberIsRequired)
            return }

        var elements = expression.elements
        while elements.count > 1 {
        
            guard expression.isCorrect else {
                guardFailed(in: #function, at: #line)
                delegate?.didShowError(.whileComputing)
                return }

            // Get the next operational priority in this array
            guard let operation = _returnNextOperation(from: elements) else {
                guardFailed(in: #function, at: #line)
                delegate?.didShowError(.whileComputing)
                return }
            
            let result: Float // Get the result of this operation
            do { try result = _returnResult(of: operation)
            } catch ErrorThrow.divisionByZero(let message) {
                delegate?.didShowError(message)
                return
            } catch {
                delegate?.didShowError(ErrorMessage.generic)
                return
            }

            // Replace current operation in array with its result
            let newValue = [String(result)]
            guard let oldValues = operation.range else {
                guardFailed(in: #function, at: #line)
                delegate?.didShowError(.whileComputing)
                return
            }
            elements.replaceSubrange(oldValues, with: newValue)
        }

        // Ensure result can be casted into a floating number
        guard let result = Float(elements.first!) else {
            guardFailed(in: #function, at: #line)
            delegate?.didShowError(.whileComputing)
            return
        }
        self.result = result
    }

    private func _returnNextOperation(from elements: [String]) -> Operation? {
        // Get operand index according to priority
        let operandIndex: Int
        let multiplicationIndex: Int? = elements.firstIndex(of: Operand.multiplication.rawValue)
        let divisionIndex: Int? = elements.firstIndex(of: Operand.division.rawValue)
        
        switch (multiplicationIndex, divisionIndex) {
        case (.some(let multiplication), .some(let division)): // Pick first mult. or div.
            operandIndex = multiplication < division ? multiplication : division
        case (.some(let multiplication), .none): // Do default first mult.
            operandIndex = multiplication
        case (.none, .some(let division)): // Do default first div.
            operandIndex = division
        default: // Do first operation
            operandIndex = 1
        }

        // Get left and right item from operand index
        guard let operand = Operand.allCases.first(where: { $0.rawValue == elements[operandIndex] }),
              let leftItem = Float(elements[operandIndex - 1]),
              let rightItem = Float(elements[operandIndex + 1]) else {
            guardFailed(in: #function, at: #line, minoredBy: 3)
            return nil
        }
        let replaceSubrange = operandIndex - 1...operandIndex + 1
        return Operation(leftItem, operand, rightItem, replaceSubrange)
    }

    private func _returnResult(of operation: Operation) throws ->  Float {
        switch operation.operand {
        case Operand.addition:
            return (operation.leftItem + operation.rightItem)
        case Operand.substraction:
            return (operation.leftItem - operation.rightItem)
        case Operand.multiplication:
            return (operation.leftItem * operation.rightItem)
        case Operand.division:
            if operation.rightItem == 0 { throw ErrorThrow.divisionByZero() }
            return (operation.leftItem / operation.rightItem)
        }
    }
    
    // MARK: MISC FUNCTIONS
    
    func reset() {
        input = ""
        result = nil
    }
}
