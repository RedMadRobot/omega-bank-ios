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
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction], preferredAction: UIAlertAction?)
    
    func showAlert(mapOptions: [String: URL], renderAppleMaps: @escaping VoidClosure)
}

extension AlertPresentable where Self: UIViewController {
    
    /// Alert с двумя кнопками действий
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
        alert.addAction(UIAlertAction(title: cancelTitleAction, style: .default) { _ in
            completion(false)
        })
        present(alert, animated: true)
    }
    
    /// Alert с настраиваемыми кнопками действий
    func showAlert(title: String?, message: String?, actions: [UIAlertAction], preferredAction: UIAlertAction? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alert.addAction)
        alert.preferredAction = preferredAction
        present(alert, animated: true)
    }
    
    /// ActionSheet с предложением открыть маршрут в картах
    /// - Parameters:
    ///   - mapOptions: Словарь, с названием открываемых карт
    ///   - renderAppleMaps: Открытие маршрута в appleMap
    func showAlert(mapOptions: [String: URL], renderAppleMaps: @escaping VoidClosure) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            renderAppleMaps()
        }))
        
        mapOptions.forEach { option in
            alert.addAction(UIAlertAction(title: option.key, style: .default, handler: { _ in
                UIApplication.shared.open(option.value, options: [:], completionHandler: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
}
