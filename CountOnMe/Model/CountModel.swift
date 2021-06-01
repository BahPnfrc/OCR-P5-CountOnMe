//
//  CountOnMe.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 01/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum EnumOperand: String, CaseIterable {
    case isAddition = "+"
    case isSoustraction = "−"
    case isMultiplication = "×"
    case isDivision = "÷"
}

struct Operation {
    var leftItem: Int
    var operand: EnumOperand
    var rightItem: Int
}
