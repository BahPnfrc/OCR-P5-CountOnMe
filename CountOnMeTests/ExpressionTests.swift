//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Pierre-Alexandre on 04/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class ExpressionTests: XCTestCase {
    
    var randomNumber: Int {
        return Int.random(in: 1...9)
    }
    
    func testGivenAnyNumberFrom0To100_whenThisNumberIsDividedByTwo_thenItIsEvenOrOdd() {

        var testIsPassed: Bool = true
        for number in 0...100 {
            if number.isMultiple(of: 2) {
                guard number.isEven && (number - 1).isOdd && (number + 1).isOdd
                else { testIsPassed = false ; break }
            } else {
                guard number.isOdd && (number - 1).isEven && (number + 1).isEven
                else { testIsPassed = false ; break }
            }
        }
        
        XCTAssertTrue(testIsPassed)
    }
    
    func testGivenAnExpression_when() {
        
        let numberDataSet: [Int] = Array(-99...99)
        let operandDataSet: [Operand] = Operand.allCases
        var expressionDataSet = String(numberDataSet.randomElement()!)
        
        for _ in 1...9 {
            expressionDataSet.append(" \(operandDataSet.randomElement()!.rawValue) ")
            expressionDataSet.append("\(numberDataSet.randomElement()!)")
        }
        
        let expression = Expression(expressionDataSet)
        XCTAssertTrue(expression.isCorrect)

    }
    
}
