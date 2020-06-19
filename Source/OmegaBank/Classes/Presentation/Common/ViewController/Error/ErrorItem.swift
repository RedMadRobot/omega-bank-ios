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
    let actionTitle: String?

    init(title: String,
         subtitle: String? = nil,
         action: String? = nil) {
        
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = action
    }
        
}

extension ErrorItem {
    
    // MARK: - Public Properties
    
    static let empty = ErrorItem(
        title: NSLocalizedString("NoData", comment: ""))

    static let emptyPartners = ErrorItem(
        title: NSLocalizedString("NoPartners", comment: ""))
    
    // MARK: - Public Methods
    
    static func error(_ error: Error) -> ErrorItem {
        let urlErrorCodes: [URLError.Code] = [.notConnectedToInternet, .networkConnectionLost]
        
        guard
            let error = error as? URLError,
            urlErrorCodes.contains(error.code)

        else { return commonError() }
                
        return urlError()
    }
    
    // MARK: - Private Methods
    
    private static func urlError() -> ErrorItem {
        ErrorItem(
            title: NSLocalizedString("NoInternetConnection", comment: ""),
            action: NSLocalizedString("Repeat", comment: "")
        )
    }
    
    private static func commonError() -> ErrorItem {
        ErrorItem(
            title: NSLocalizedString("FailedToLoadData", comment: ""),
            subtitle: NSLocalizedString("ServerIsUnreachable", comment: ""),
            action: NSLocalizedString("Repeat", comment: "")
        )
    }

}
