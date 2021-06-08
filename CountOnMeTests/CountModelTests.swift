//
//  CountModelTests.swift
//  CountOnMeTests
//
//  Created by Pierre-Alexandre on 07/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountModelTests: XCTestCase {

    var countModel = CountModel()
    var expression: Expression? { countModel.inputToExpression }
    var expressionIsCorrect: Bool { expression?.isCorrect ?? false }
    var expressionIsWellFormated: Bool { expression?.isWellFormated() ?? false }
    var elements: [String]? { expression?.elements }

    let intDataSet: ClosedRange<Int> = 1...999
    var randomNumber: Int { Int.random(in: intDataSet) }
    var randomNumberAsString: String { String(randomNumber) }

    let allOperand: [Operand] = Operand.allCases
    var randomOperand: Operand { allOperand.randomElement()! }

    override func setUp() {
        super.setUp()
        self.countModel = CountModel()
    }

    // MARK: - CHECK ADD NUMBER

    func testGivenAnExpression_whenAddingNilOrTextAsNumber_thenErrorAndCountMustRemain0() {
        countModel.addNumber(nil)
        countModel.addNumber("abcd")
        XCTAssertTrue(elements?.count == 0)
    }

    // MARK: - CHECK ADD OPERAND

    // Empty

    // MARK: - CHECK ADD LEFT ITEM

    func testGivenCountIs0_whenAddingOperand_thenErrorAndCountMustRemain0() {
        guard elements?.count == 0 else { XCTFail("Given check failed") ; return }
        countModel.addOperand(randomOperand)
        XCTAssertTrue(elements?.count == 0 && !expressionIsCorrect)
    }

    func testGivenCountIs0_whenAddingNumber_thenCountMustBe1() {
        guard elements?.count == 0 else { XCTFail("Given check failed") ; return }
        countModel.addNumber(randomNumberAsString)
        XCTAssertTrue(elements?.count == 1 && expressionIsCorrect)
    }

    // MARK: - CHECK ADD OPERAND ITEM

    func testGivenCountIs1_whenAddingOperand_thenCountMustBe2() {
        countModel.addNumber(randomNumberAsString)
        guard elements?.count == 1 else { XCTFail("Given check failed") ; return }
        countModel.addOperand(randomOperand)
        XCTAssertTrue(elements?.count == 2 && expressionIsWellFormated)
    }

    func testGivenCountIs1_whenAddingNumber_thenCountMustRemain1() {
        countModel.addNumber(randomNumberAsString)
        guard elements?.count == 1 else { XCTFail("Given check failed") ; return }
        countModel.addNumber(randomNumberAsString)
        XCTAssertTrue(elements?.count == 1 && expressionIsCorrect)
    }

    // MARK: - CHECK ADD RIGHT ITEM

    func testGivenCountIs2_whenAddingOperand_thenErrorAndCountMustRemain2() {
        countModel.addNumber(randomNumberAsString)
        countModel.addOperand(randomOperand)
        guard elements?.count == 2 else { XCTFail("Given check failed") ; return }
        countModel.addOperand(randomOperand)
        XCTAssertTrue(elements?.count == 2 && expressionIsWellFormated)
    }

    func testGivenCountIs2_whenAddingNumber_thenCountMustBe3() {
        countModel.addNumber(randomNumberAsString)
        countModel.addOperand(Operand.division)
        guard elements?.count == 2 else { XCTFail("Given check failed") ; return }
        countModel.addNumber(randomNumberAsString)
        XCTAssertTrue(elements?.count == 3 && expressionIsCorrect)
    }

    func testGivenCountIs2_whenAddingZeroAfterDivision_thenErrorAndCountMustRemain2() {
        countModel.addNumber(randomNumberAsString)
        countModel.addOperand(Operand.division)
        guard elements?.count == 2 else { XCTFail("Given check failed") ; return }
        countModel.addNumber("0")
        XCTAssertTrue(expression?.elements.count == 2 && expressionIsWellFormated)
    }

    // MARK: - CHECK PRIORITY

    func testGivenAnExpression_whenMultiplicationOcccurs_thenMultiplicationIsComputedFirst() {

        let num1: Int = randomNumber ; let num2: Int = randomNumber
        let num3: Int = randomNumber ; let num4: Int = randomNumber

        countModel.addNumber(String(num1))
        countModel.addOperand(Operand.substraction)
        countModel.addNumber(String(num2))
        countModel.addOperand(Operand.addition)
        countModel.addNumber(String(num3))
        countModel.addOperand(Operand.multiplication)
        countModel.addNumber(String(num4))
        countModel.getResult()

        let multiplicationResult: Float = Float(num3) * Float(num4)
        let localResult: Float = Float(num1 - num2) + multiplicationResult
        guard let modelResult = countModel.result
        else { XCTFail("Multiplication in Model failed") ; return }
        XCTAssertEqual(modelResult, localResult)
    }

    func testGivenAnExpression_whenDivisionOcccurs_thenDivisionsIsComputedFirst() {

        let num1: Int = randomNumber ; let num2: Int = randomNumber
        let num3: Int = randomNumber ; let num4: Int = randomNumber

        countModel.addNumber(String(num1))
        countModel.addOperand(Operand.substraction)
        countModel.addNumber(String(num2))
        countModel.addOperand(Operand.addition)
        countModel.addNumber(String(num3))
        countModel.addOperand(Operand.division)
        countModel.addNumber(String(num4))
        countModel.getResult()

        let divisionResult: Float = Float(num3) / Float(num4)
        let localResult: Float = Float(num1 - num2) + divisionResult
        guard let modelResult = countModel.result
        else { XCTFail("Division in Model failed") ; return }
        XCTAssertEqual(modelResult, localResult)
    }

    // MARK: - CHECK DIVISION BY 0

    func testGivenAnExpression_whenDivisionByZeroIsTried_thenErrorIsThrownAndResultIsNil() {
        let zero: Int = 0
        countModel.addNumber(randomNumberAsString)
        countModel.addOperand(Operand.division)
        countModel.input.append(String(zero))

        countModel.getResult()
        XCTAssertNil(countModel.result)
    }

    func testGivenAnExpression_whenDivisionByNotZeroIsTried_thenErrorIsNotThrownAndResultIsNotNil() {
        let notZero: Int = randomNumber
        countModel.addNumber(randomNumberAsString)
        countModel.addOperand(Operand.division)
        countModel.input.append(String(notZero))

        countModel.getResult()
        XCTAssertNotNil(countModel.result)
    }

    // MARK: - CHECK RESET

    func testGivenAnExpression_whenResetIsUsed_thenErrorIsNotThrownAndResultIsNotNil() {
        countModel.addNumber(randomNumberAsString)
        countModel.addOperand(randomOperand)
        countModel.addNumber(randomNumberAsString)
        countModel.getResult()

        guard !countModel.input.isEmpty && countModel.result != nil
        else { XCTFail("Random operation in Model failed") ; return }

        countModel.reset()
        XCTAssertTrue(countModel.input.isEmpty && countModel.result == nil)
    }
}
