//
//  UIViewController+AlertExtension.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 16.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Кастомный алерт для биометрии, когда системный уже отобразился
    func showAuthenticationAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Предоставить приложению доступ к биометрии?",
            message: "Так вы сможете быстрее авторизовываться в нём",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            completion(true)
        })
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel) { _ in
            completion(false)
        })
        present(alert, animated: true)
    }
}
