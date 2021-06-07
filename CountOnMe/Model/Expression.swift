//
//  Expression.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 03/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Expression {
    
    // MARK: - PROPERTIES
    
    private var rawExpression: String
    
    init(of rawExpression: String) {
        self.rawExpression = rawExpression
    }
    
    var elements: [String] {
       return rawExpression.split(separator: " ").map { "\($0)" }
    }
    
    var isCorrect: Bool {
        return isSingleNumber()
            || hasEnoughElement()
            && isWellFormated()
            && lastElementIsNumber()
    }
    
    // MARK: - FUNCTIONS
    
    func isSingleNumber() -> Bool {
        return self.elements.count == 1 && Float(elements[0]) != nil
    }
    
    func hasEnoughElement() -> Bool {
        // Odd number of elements is required
        let elements = self.elements.count
        return elements > 2 && (elements - 3).isEven
    }
    
    func isWellFormated () -> Bool {
        let elements = self.elements
        for index in 0...elements.count - 1 {
            switch index.isEven {
            case true: // Even elements must be numbers
                guard Float(elements[index]) != nil
                else { return false }
            case false: // Odd elements must be operands
                guard Operand.allCases.first(where: { $0.rawValue == elements[index] }) != nil
                else { return false }
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

// MARK: - EXTENSION

extension Int {
    var isEven: Bool {
        return abs(self) % 2 == 0
    }
    var isOdd: Bool {
        return abs(self) % 2 == 1
    }
}
