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

    func testGivenRandomExpression_whenGlobalTestIsRun_thenExpressionIsCorrect() {

        var expressionDataSet = String(numberDataSet.randomElement()!)
        for _ in 1...9 {
            expressionDataSet.append(" \(operandDataSet.randomElement()!.rawValue) ")
            expressionDataSet.append("\(numberDataSet.randomElement()!)")
        }

        let expression = Expression(of: expressionDataSet)
        XCTAssertTrue(expression.isCorrect)
    }

}
