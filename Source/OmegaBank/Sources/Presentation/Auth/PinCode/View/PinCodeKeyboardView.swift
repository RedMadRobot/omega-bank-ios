//
//  PinCodeKeyboardView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

protocol PinCodeKeyBoardViewDelegate: AnyObject {
    
    func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect digit: String)
    
    func pinCodeKeyboardViewDidSelectLeftButton(_ keyboard: PinCodeKeyboardView)
    
    func pinCodeKeyboardViewDidSelectRightButton(_ keyboard: PinCodeKeyboardView)
    
}

final class PinCodeKeyboardView: View, NibLoadable {
    
    // MARK: - Public Properties
    
    weak var delegate: PinCodeKeyBoardViewDelegate?
    
    // MARK: - IBOutlet
    
    @IBOutlet private var leftButton: UIButton!
    @IBOutlet private var rightButton: UIButton!
    
    // MARK: - Public methods
    
    func setRightButton(image: UIImage?) {
        rightButton.isEnabled = image != nil
        rightButton.setImage(image, for: .normal)
    }
    
    func setLeftButton(name: String?) {
        leftButton.isEnabled = name != nil
        leftButton.setTitle(name, for: .normal)
    }
    
    // MARK: - Init
    
    override func commonInit() {
        super.commonInit()
        isExclusiveTouch = true
    }
    
    // MARK: - IBAction
    
    @IBAction private func digitButtonPressed(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text else { return }
        delegate?.pinCodeKeyboardView(self, didSelect: digit)
    }
    
    @IBAction private func leftButtonPressed() {
        delegate?.pinCodeKeyboardViewDidSelectLeftButton(self)
    }
    
    @IBAction private func rightButtonPressed() {
        delegate?.pinCodeKeyboardViewDidSelectRightButton(self)
    }
}
