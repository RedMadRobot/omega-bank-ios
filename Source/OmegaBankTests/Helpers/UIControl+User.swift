//
//  UIControl+User.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/1/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

extension UIControl {

    /// Пользователь нажал на элемент.
    func userTap() {
        guard isEnabled else { return }
        sendActions(for: .touchUpInside)
    }
}

extension UITextField {

    /// Пользовательский ввод текста.
    ///
    /// - Parameter string: Новая сторка для `UITextField`.
    func userInput(_ string: String) {
        guard isEnabled else { return }
        sendActions(for: .editingDidBegin)
        text = string
        
        sendActions(for: .editingChanged)
        sendActions(for: .editingDidEnd)
        sendActions(for: .editingDidEndOnExit)
    }
}

extension UIBarButtonItem {
    func userTap() {
        _ = target!.perform(action!)
    }
}
