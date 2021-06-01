//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - @IBOUTLET
    
    @IBOutlet weak var display: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    
    // MARK: - PROPERTY
    
    var elements: [String] {
        return display.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var expressionIsCorrect: Bool {
        return !lastElementIsAnOperand()
    }
    
    var canAddOperator: Bool {
        return !lastElementIsAnOperand()
    }
    
    private func lastElementIsAnOperand() -> Bool {
        for operand in EnumOperand.allCases {
            let sign = operand.rawValue
            if self.elements.last == sign { return true }
        }
        return false
    }
    
    var expressionHaveResult: Bool {
        return display.text.firstIndex(of: "=") != nil
    }
    
    // MARK: - CYCLE
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paint(display as Any)
        for button in numberButtons { paint(button) }
        for button in operationButtons { paint(button)}
    }
    
    func paint(_ any: Any) {
        guard let view = any as? UIView else { return }
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
    }
    
    
    // MARK: - @IBActions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            display.text = ""
        }
        
        display.text.append(numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            display.text.append(" \(EnumOperand.isAddition.rawValue) ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            display.text.append(" \(EnumOperand.isSoustraction.rawValue) ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func tappedMultiplicationButton(_ sender: Any) {
        if canAddOperator {
            display.text.append(" \(EnumOperand.isMultiplication.rawValue) ")
        } else {
        }
        
    }
    
    @IBAction func tappedDivisionButton(_ sender: Any) {
        if canAddOperator {
            display.text.append(" \(EnumOperand.isDivision.rawValue) ")
        } else {
        }
    }
    
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        display.text.append(" = \(operationsToReduce.first!)")
    }

}

