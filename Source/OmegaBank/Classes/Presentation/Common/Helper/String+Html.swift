//
//  String+Html.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

extension String {
    
    /// Переводим HTML String в NSAttributedString
    
    func makeHtmlAttributed() throws -> NSMutableAttributedString? {
        let data = Data(self.utf8)
        
        return try NSMutableAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
    }
}
