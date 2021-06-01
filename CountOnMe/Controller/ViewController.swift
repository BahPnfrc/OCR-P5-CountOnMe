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
    
    @IBOutlet weak var display: UIStackView!
    @IBOutlet weak var input: UITextView!
    @IBOutlet weak var output: UILabel!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    
    // MARK: - PROPERTY
    
    var result: String? = nil {
        didSet {
            if let any = result {
                output.isHidden = false
                output.text = any
            } else {
                output.isHidden = true
                output.text = ""
            }
            
        }
    }
    
    var elements: [String] {
        return input.text.split(separator: " ").map { "\($0)" }
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
        return output.text?.contains("=") ?? false
    }
    
    // MARK: - CYCLE
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paint(display as Any)
        for button in numberButtons { paint(button) }
        for button in operationButtons { paint(button)}
    }
    
    func paint(_ anyItem: Any) {
        guard let view = anyItem as? UIView else { return }
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
    }
    
    
    // MARK: - @IBActions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            input.text = ""
        }
        
        input.text.append(numberText)
    }
    
    private func tappedShowError() {
        let alertVC = UIAlertController(title: "Erreur", message: "Un opérateur est déja présent", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            input.text.append(" \(EnumOperand.isAddition.rawValue) ")
        } else { tappedShowError() }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            input.text.append(" \(EnumOperand.isSoustraction.rawValue) ")
        } else { tappedShowError() }
    }
    
    
    @IBAction func tappedMultiplicationButton(_ sender: Any) {
        if canAddOperator {
            input.text.append(" \(EnumOperand.isMultiplication.rawValue) ")
        } else { tappedShowError() }
    }
    
    @IBAction func tappedDivisionButton(_ sender: Any) {
        if canAddOperator {
            input.text.append(" \(EnumOperand.isDivision.rawValue) ")
        } else { tappedShowError() }
    }
    
    @IBAction func tappedResetButton(_ sender: Any) {
        input.text = ""
        result = nil
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
            case EnumOperand.isAddition.rawValue : result = left + right
            case EnumOperand.isSoustraction.rawValue: result = left - right
            case EnumOperand.isMultiplication.rawValue: result = left * right
            case EnumOperand.isDivision.rawValue: result = left / right
            default: fatalError("Opérateur inconnu !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        result = " = \(operationsToReduce.first!)"
    }

}

