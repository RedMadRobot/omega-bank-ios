//
//  PinCodeKeyboardView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

protocol PinCodeKeyBoardViewDelegate: AnyObject {
    
    func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect number: String)
    
    func pinCodeKeyboardViewDidSelectLeftButton(_ keyboard: PinCodeKeyboardView)
    
    func pinCodeKeyboardViewDidSelectRightButton(_ keyboard: PinCodeKeyboardView)
    
}

final class PinCodeKeyboardView: UIView, NibLoadable {
    
    // MARK: - Public Properties
    
    var isEnabled: Bool = true {
        didSet {
            isUserInteractionEnabled = isEnabled
        }
    }
    
    weak var delegate: PinCodeKeyBoardViewDelegate?
    
    // MARK: - IBOutlet
    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    // MARK: - Public methods
    
    func setRightButton(image: UIImage?) {
        if image != nil {
            rightButton.isEnabled = true
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = .ph3
        } else {
            rightButton.isEnabled = false
            rightButton.setImage(nil, for: .normal)
        }
    }
    
    func setLeftButton(name: String?) {
        if let name = name {
            leftButton.isEnabled = true
            leftButton.setTitle(name, for: .normal)
        } else {
            leftButton.isEnabled = false
            leftButton.setTitle(nil, for: .normal)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func numberButtonPressed(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        delegate?.pinCodeKeyboardView(self, didSelect: number)
    }
    
    @IBAction private func leftButtonPressed() {
        delegate?.pinCodeKeyboardViewDidSelectLeftButton(self)
    }
    
    @IBAction private func rightButtonPressed() {
        delegate?.pinCodeKeyboardViewDidSelectRightButton(self)
    }
}
