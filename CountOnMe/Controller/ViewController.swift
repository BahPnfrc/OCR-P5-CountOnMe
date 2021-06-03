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
    
    var expressionHaveResult: Bool {
        return UIoutput.text?.contains("=") ?? false
    }
    
    // MARK: - CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paint(UIdisplay as Any)
        for button in UInumberButtons { paint(button) }
        for button in UIoperationButtons { paint(button)}
    }
    
    func paint(_ anyItem: Any) {
        guard let view = anyItem as? UIView else { return }
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 5
    }
    
    // MARK: - @IBACTION
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        
        if expressionHaveResult {
            UIinput.text = ""
        }
        UIinput.text.append(numberText)
    }
    
    private func tappedShowError() {
        let alertVC = UIAlertController(title: "Erreur", message: "Un opérateur est déja présent", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        operandButtonWasTapped(Operand.addition)
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        operandButtonWasTapped(Operand.substraction)
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: Any) {
        operandButtonWasTapped(Operand.multiplication)
    }
    
    @IBAction func tappedDivisionButton(_ sender: Any) {
        operandButtonWasTapped(Operand.division)
    }
    
    func getCurrentExpression() -> Expression {
        return Expression(UIinput.text)
    }
    
    func operandButtonWasTapped(_ operand: Operand) {
        let expression = getCurrentExpression()
        if expression.expressionIsCorrect {
            UIinput.text.append(" \(operand.rawValue) ")
        } else { tappedShowError() }
    }
    
    @IBAction func tappedResetButton(_ sender: Any) {
        UIinput.text = ""
        result = nil
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {

        let expression = getCurrentExpression()
        var elements = expression.elements
        
        while elements.count > 1 {
            
            guard expression.expressionIsCorrect
            else { fatalError() }
            
            var operandIndex: Int
            if let multiplicationIndex = elements.firstIndex(of: Operand.multiplication.rawValue) {
                operandIndex = multiplicationIndex
            } else if let divisionIndex = elements.firstIndex(of: Operand.division.rawValue) {
                operandIndex = divisionIndex
            } else { operandIndex = 1 }
            
            let operand = elements[operandIndex]
            guard let leftItem = Float(elements[operandIndex - 1]),
                  let rightItem = Float(elements[operandIndex + 1])
            else { fatalError() }
            
            let operation = Operation(leftItem, operand, rightItem)
            let result = Operating.getResultOf(operation)
            
            if let number = result.Result {
                let newValue = [String(number)]
                let oldValues = operandIndex - 1...operandIndex + 1
                elements.replaceSubrange(oldValues, with: newValue)
            } else if let error = result.Error {
                UIoutput.text = error.rawValue
            } else {
                //
            }
        }
        
        result = " = \(elements.first!)"
    }

}

