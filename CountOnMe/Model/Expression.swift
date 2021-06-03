//
//  Expression.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 03/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Expression {
    
    // MARK: - Properties
    
    private var rawExpression: String
    
    init(_ rawExpression: String) {
        self.rawExpression = rawExpression
    }
    
    var elements: [String] {
       return rawExpression.split(separator: " ").map { "\($0)" }
    }
    
    var expressionIsCorrect: Bool {
        return hasEnoughElement()
            && isWellFormated()
            && lastElementIsNumber()
    }
    
    // MARK: - Checks
    
    func hasEnoughElement() -> Bool {
        // Odd number of elements is required
        let elements = self.elements.count
        return elements > 2 && (elements - 3) % 2 == 0
    }
    
    func isWellFormated () -> Bool {
        let elements = self.elements
        for index in 0...elements.count - 1 {
            switch index % 2 {
            case 0: // Even elements must be numbers
                guard Float(elements[index]) != nil
                else { return false }
            case 1: // Odd elements must be operands
                guard Operand.allCases.first(where: { $0.rawValue == elements[index] }) != nil
                else { return false }
            default: return false
            }
        }
        return true
    }
    
    func lastElementIsOperand() -> Bool {
        for operandAsEnum in Operand.allCases {
            let operandAsString = operandAsEnum.rawValue
            if elements.last == operandAsString { return true }
        }
        return false
    }
    
    func lastElementIsNumber() -> Bool {
        return !lastElementIsOperand()
    }
}
