//
//  ErrorItem.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 11.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

struct ErrorItem {
    let title: String
    let subtitle: String?
    let action: String?
    let onAction: (() -> Void)?

    init(title: String,
         subtitle: String? = nil,
         action: String? = nil,
         onAction: (() -> Void)? = nil) {
        
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.onAction = onAction
    }
        
}

extension ErrorItem {
    
    // MARK: - Public Properties
    
    static let empty = ErrorItem(
        title: NSLocalizedString("NoData", comment: ""))

    static let emptyPartners = ErrorItem(
        title: NSLocalizedString("NoPartners", comment: ""))
    
    // MARK: - Public Methods
    
    static func error(
        _ error: Error,
        onAction: (() -> Void)? = nil) -> ErrorItem {
        
        return error is URLError ? urlError(onAction) : commonError(onAction)
    }
    
    // MARK: - Private Methods
    
    private static func urlError(
        _ onAction: (() -> Void)? = nil) -> ErrorItem {
        ErrorItem(
            title: NSLocalizedString("NoInternetConnection", comment: ""),
            action: NSLocalizedString("Repeat", comment: ""),
            onAction: onAction
        )
    }
    
    private static func commonError(
        _ onAction: (() -> Void)? = nil) -> ErrorItem {
        ErrorItem(
            title: NSLocalizedString("FailedToLoadData", comment: ""),
            subtitle: NSLocalizedString("ServerIsUnreachable", comment: ""),
            action: NSLocalizedString("Repeat", comment: ""),
            onAction: onAction
        )
    }

}

protocol ErrorHandler where Self: UIViewController { }

extension ErrorHandler {

    func showError(_ item: ErrorItem) {
        
        let alert = UIAlertController(
            title: item.title, message: item.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: item.action ?? "Ok", style: .default, handler: { _ in
            item.onAction?()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}
