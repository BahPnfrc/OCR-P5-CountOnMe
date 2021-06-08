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

enum ErrorMessage: String, CaseIterable {
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

    // MARK: - EXPRESSION

    func reset() {
        input = ""
        result = nil
    }

    func addNumber(_ number: String?) {
        guard let numberAsString = number else {
            delegate?.didShowError(.generic)
            return
        }
        guard let numberAsInt = Int(numberAsString) else {
            delegate?.didShowError(.numberIsRequired)
            return
        }
        if numberAsInt == 0 {
            guard !input.hasSuffix(" \(Operand.division.rawValue) ") else {
                delegate?.didShowError(.divisionByZero)
                return
            }
        }
        self.input.append(numberAsString)
    }

    func addOperand(_ operand: Operand) {
        let expression = self.inputToExpression
        guard expression.lastElementIsNumber() else {
            delegate?.didShowError(.numberIsRequired)
            return
        }
        self.input.append(" \(operand.rawValue) ")
    }

    func getResult() {
        let expression = self.inputToExpression
        guard expression.lastElementIsNumber()
        else { delegate?.didShowError(.numberIsRequired) ; return }

        var elements = expression.elements
        while elements.count > 1 {

            guard expression.isCorrect
            else { delegate?.didShowError(.whileComputing) ; return }

            // Get an expression and compute for its result
            guard let operation = _returnNextOperation(from: elements)
            else { delegate?.didShowError(.whileComputing) ; return }

            var result: Float
            do {
                try result = _returnResult(of: operation)
            } catch ErrorThrow.divisionByZero(let message) {
                delegate?.didShowError(message)
                return
            } catch {
                delegate?.didShowError(ErrorMessage.generic)
                return
            }

            // Replace current expression with its result
            let newValue = [String(result)]
            guard let oldValues = operation.range
            else { delegate?.didShowError(.whileComputing) ; return }
            elements.replaceSubrange(oldValues, with: newValue)
        }

        guard let result = Float(elements.first!)
        else { delegate?.didShowError(.whileComputing) ; return }
        self.result = result
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
}
