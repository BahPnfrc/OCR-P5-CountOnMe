//
//  Operation.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 01/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct Operation {
    var leftItem: Float
    var rightItem: Float
    var operand: Operand
    var isDivisionByZero: Bool
    
    var range: ClosedRange<Int>?
    
    init(_ leftItem: Float, _ operand: Operand, _ rightItem: Float) {
        self.leftItem = leftItem
        self.rightItem = rightItem
        self.operand = operand
        self.isDivisionByZero =
            operand == .division
            && rightItem == 0
    }
}
