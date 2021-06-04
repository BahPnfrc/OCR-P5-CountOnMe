//
//  Operating.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 03/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum Error: String {
    case divisionByZero = "Impossible de diviser par 0"
}

class Computer {
    static func getResultOf(_ operation: Operation) -> (Result: Float?, Error: Error?) {
        switch operation.operand {
        case Operand.addition: return (operation.leftItem + operation.rightItem, nil)
        case Operand.substraction: return (operation.leftItem - operation.rightItem, nil)
        case Operand.multiplication: return (operation.leftItem * operation.rightItem, nil)
        case Operand.division:
            guard operation.rightItem != 0 else { return (nil, Error.divisionByZero) }
            return (operation.leftItem / operation.rightItem, nil)
        }
        
    }
}
