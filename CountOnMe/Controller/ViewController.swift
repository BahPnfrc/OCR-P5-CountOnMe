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
    
    @IBOutlet weak var UIdisplay: UIStackView!
    @IBOutlet weak var UIinput: UITextView!
    @IBOutlet weak var UIoutput: UILabel!
    @IBOutlet var UInumberButtons: [UIButton]!
    @IBOutlet var UIoperationButtons: [UIButton]!
    
    // MARK: - PROPERTY
    
    var expression: Expression {
        return Expression(of: UIinput.text)
    }
    
    var result: String? = nil {
        didSet {
            if let any = result {
                UIoutput.isHidden = false
                UIoutput.text = any
            } else {
                UIoutput.isHidden = true
                UIoutput.text = ""
            }
        }
    }
    
    var previousResultIsDisplayed: Bool {
        return UIoutput.text?.starts(with: "=") ?? false
    }
    
    // MARK: - CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIinput.isEditable = false
        
        paint(UIdisplay as Any)
        for button in UInumberButtons { paint(button) }
        for button in UIoperationButtons { paint(button)}
    }
    
    func paint(_ anyItem: Any) {
        guard let view = anyItem as? UIView else { return }
        view.layer.borderColor = #colorLiteral(red: 0.1917735636, green: 0.2849107087, blue: 0.4017603099, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
    }
    
    // MARK: - @IBACTION : NUMBER
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        
        if previousResultIsDisplayed {
            reset()
        }
        UIinput.text.append(numberText)
    }
    
    // MARK: - @IBACTION : OPERAND
    @IBAction func tappedOperandAddition(_ sender: UIButton) {
        tappedOperandButton(Operand.addition)
    }
    
    @IBAction func tappedOperandSubstraction(_ sender: UIButton) {
        tappedOperandButton(Operand.substraction)
    }
    
    @IBAction func tappedOperandMultiplication(_ sender: Any) {
        tappedOperandButton(Operand.multiplication)
    }
    
    @IBAction func tappedOperandDivision(_ sender: Any) {
        tappedOperandButton(Operand.division)
    }
    
    func tappedOperandButton(_ operand: Operand) {
        let expression = expression
        if expression.isCorrect {
            UIinput.text.append(" \(operand.rawValue) ")
        } else {
            reportError("L'expression comporte déjà un opérateur")
        }
    }
    
    // MARK: - @IBACTION : ELSE

    @IBAction func tappedResetButton(_ sender: Any) {
        reset()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {

        let expression = expression
        var elements = expression.elements
        
        while elements.count > 1 {
            
            guard expression.isCorrect
            else {
                reportError("L'expression est mal formulée")
                return
            }
            
            var operandIndex: Int
            if let firstMultiplicationIndex = elements.firstIndex(of: Operand.multiplication.rawValue) {
                operandIndex = firstMultiplicationIndex
            } else if let firstDivisionIndex = elements.firstIndex(of: Operand.division.rawValue) {
                operandIndex = firstDivisionIndex
            } else { operandIndex = 1 }
            
            let operand = elements[operandIndex]
            guard let leftItem = Float(elements[operandIndex - 1]),
                  let rightItem = Float(elements[operandIndex + 1])
            else {
                reportError("L'expression est mal formulée")
                return
            }
            
            let operation = Operation(leftItem, operand, rightItem)
            let result = Computer.getResultOf(operation)
            guard let number = result.Result
            else {
                if let error = result.Error {
                    reportError(error.rawValue)
                } else {
                    reportError("Une erreur inconnue est survenue")
                }
                return
            }
            let newValue = [String(number)]
            let oldValues = operandIndex - 1...operandIndex + 1
            elements.replaceSubrange(oldValues, with: newValue)
        }

        result = "= \(elements.first!)"
    }
    
    // MARK: - MISC
    
    private func reportError(_ message: String) {
        let alertVC = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        reset()
    }
    
    private func reset() {
        UIinput.text = ""
        result = nil
    }
    

}

