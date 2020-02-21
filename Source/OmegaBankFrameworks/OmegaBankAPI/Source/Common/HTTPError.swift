//
//  HTTPError.swift
//  OmegaBankAPI
//
//  Created by Alexander Ignatev on 15/03/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

struct HTTPError: Error {
    let statusCode: Int
    let url: URL?

    var localizedDescription: String {
        HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
}

// MARK: - CustomNSError

extension HTTPError: CustomNSError {
    static var errorDomain = "OmegaBankAPI.HTTPErrorDomain"

    public var errorCode: Int { statusCode }

    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: localizedDescription]
        userInfo[NSURLErrorKey] = url
        return userInfo
    }
}
