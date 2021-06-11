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

    // MARK: - ODD AND EVEN TEST
    
    func testGivenAllNumbersInRange_whenNumbersAreDividedByTwo_thenTheyAreEvenOrOdd() {

        for number in 0...100 {
            if number.isMultiple(of: 2) {
                guard number.isEven && (number - 1).isOdd && (number + 1).isOdd
                else { XCTFail("Number.isEven test failed") ; return }
            } else {
                guard number.isOdd && (number - 1).isEven && (number + 1).isEven
                else { XCTFail("Number.isOdd test failed") ; return }
            }
        }
        XCTAssertTrue(true)
    }

    // MARK: - SINGLE NUMBER TEST
    
    func testGivenExpressionIsNil_whenCheckedForSingleNumber_thenFalseIsReturned() {
        let dataSet = ""
        let expression = Expression(of: dataSet)
        XCTAssertFalse(expression.isSingleNumber())
    }

    func testGivenExpressionIsNotNumber_whenCheckedForSingleNumber_thenFalseIsReturned() {
        let dataSet = "abc"
        let expression = Expression(of: dataSet)
        XCTAssertFalse(expression.isSingleNumber())
    }

    func testGivenExpressionIsSingleNumber_whenCheckedForSingleNumber_thenTrueIsReturned() {
        let dataSet = "123"
        let expression = Expression(of: dataSet)
        XCTAssertTrue(expression.isSingleNumber())
    }

    func testGivenExpressionIsSeveralNumber_whenCheckedForSingleNumber_thenFalseIsReturned() {
        let dataSet = "123 \(Operand.addition.rawValue) 456"
        let expression = Expression(of: dataSet)
        XCTAssertFalse(expression.isSingleNumber())
    }
    
    // MARK: - GLOBAL TEST
    
    let numberRange: ClosedRange<Int> = 1...999
    var randomNumber: Int { Int.random(in: numberRange) }
    var randomNumberAsString: String { String(randomNumber) }

    let allOperand: [Operand] = Operand.allCases
    var randomOperand: Operand { allOperand.randomElement()! }

    func testGivenRandomExpression_whenGlobalTestIsRun_thenExpressionIsCorrect() {
        
        var expressionDataSet = randomNumberAsString
        for _ in 1...9 {
            expressionDataSet.append(" \(randomOperand.rawValue) ")
            expressionDataSet.append("\(randomNumberAsString)")
        }

        let expression = Expression(of: expressionDataSet)
        XCTAssertTrue(expression.isCorrect)
    }

}
