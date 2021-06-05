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
    
   var countOnMe = CountOnMe()
    
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
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 5
    }
    
    // MARK: - @IBACTION : NUMBER
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        let numberText = sender.title(for: .normal)
        countOnMe.expressionAddNumber(numberText)
    }
    
    // MARK: - @IBACTION : OPERAND
    
    @IBAction func tappedOperandAddition(_ sender: UIButton) {
        countOnMe.expressionAddOperand(Operand.addition)
    }
    
    @IBAction func tappedOperandSubstraction(_ sender: UIButton) {
        countOnMe.expressionAddOperand(Operand.substraction)
    }
    
    @IBAction func tappedOperandMultiplication(_ sender: Any) {
        countOnMe.expressionAddOperand(Operand.multiplication)
    }
    
    @IBAction func tappedOperandDivision(_ sender: Any) {
        countOnMe.expressionAddOperand(Operand.division)
    }
    
    // MARK: - @IBACTION : ELSE

    @IBAction func tappedResetButton(_ sender: Any) {
        countOnMe.reset()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        countOnMe.expressionGetResult()
    }
}

extension ViewController: DisplayDelegate {
    func displaySetInput(_ input: String) {
        UIinput.text = input
    }
    
    func displaySetOutput(_ output: String) {
        UIoutput.text = output
    }
    
    func displayShowError(_ error: String) {
        let alertVC = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
