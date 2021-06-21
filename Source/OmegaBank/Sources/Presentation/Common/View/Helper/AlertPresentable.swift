//
//  AlertPresentable.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 21.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

protocol AlertPresentable: AnyObject {
    func showAlert(
        title: String?,
        text: String?,
        okTitleAction: String,
        cancelTitleAction: String,
        completion: @escaping (Bool) -> Void)
}

extension AlertPresentable where Self: UIViewController {
    
    func showAlert(
        title: String?,
        text: String?,
        okTitleAction: String,
        cancelTitleAction: String,
        completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: title,
            message: text,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitleAction, style: .default) { _ in
            completion(true)
        })
        alert.addAction(UIAlertAction(title: cancelTitleAction, style: .cancel) { _ in
            completion(false)
        })
        present(alert, animated: true)
    }
    
}
