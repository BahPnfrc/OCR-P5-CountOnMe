//
//  Extension.swift
//  CountOnMe
//
//  Created by Pierre-Alexandre on 14/06/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension Int {
    var isEven: Bool {
        return abs(self) % 2 == 0
    }
    var isOdd: Bool {
        return abs(self) % 2 == 1
    }
}
