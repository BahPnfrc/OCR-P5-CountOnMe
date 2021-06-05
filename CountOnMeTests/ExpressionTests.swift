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
    
    let numberDataSet: [Int] = Array(-99...99)
    let operandDataSet: [Operand] = Operand.allCases
    
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
    

    
    func testGivenExpressionIsNil_whenCheckedForSingleNumber_thenFalseIsReturned() {
        let dataSet = ""
        let expression = Expression(of: dataSet)
        XCTAssertFalse(expression.isSingleNumber())
    }
    
    func testGivenExpressionIsNotNumber_whenCheckedForSingleNumber_thenFalseIsReturned() {
        let dataSet = "ab"
        let expression = Expression(of: dataSet)
        XCTAssertFalse(expression.isSingleNumber())
    }
    
    func testGivenExpressionIsSingleNumber_whenCheckedForSingleNumber_thenTrueIsReturned() {
        let dataSet = "12"
        let expression = Expression(of: dataSet)
        XCTAssertTrue(expression.isSingleNumber())
    }
    
    func testGivenExpressionIsSeveralNumber_whenCheckedForSingleNumber_thenFalseIsReturned() {
        let dataSet = "12 \(Operand.addition.rawValue) 23"
        let expression = Expression(of: dataSet)
        XCTAssertFalse(expression.isSingleNumber())
    }
    
    func testGivenAnyRandomExpression_whenGlobalTestIsRun_thenExpressionIsCorrect() {
        
        var expressionDataSet = String(numberDataSet.randomElement()!)
        for _ in 1...9 {
            expressionDataSet.append(" \(operandDataSet.randomElement()!.rawValue) ")
            expressionDataSet.append("\(numberDataSet.randomElement()!)")
        }
    
        let expression = Expression(of: expressionDataSet)
        
        XCTAssertTrue(expression.isCorrect)
    }
    
}
