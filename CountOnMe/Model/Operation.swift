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
    
    init(_ leftItem: Float, _ operand: String, _ rightItem: Float) {
        guard let operand = Operand.allCases.first(where: { $0.rawValue == operand })
        else { fatalError("Fatal error while parsing for operand") }
        self.leftItem = leftItem
        self.rightItem = rightItem
        self.operand = operand
    }
}
