//
//  Font.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 25.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

extension UIFont {
    
    static var body1: UIFont {
        UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    static var body2: UIFont {
        UIFont.systemFont(ofSize: 12.0)
    }
    
    static var caption1: UIFont {
        UIFont.systemFont(ofSize: 17)
    }
    
    static var header1: UIFont {
        UIFont.systemFont(ofSize: 30.0, weight: .bold)
    }

    static var tableSectionHeader: UIFont {
        UIFont.systemFont(ofSize: 15)
    }
    
    static var buttonTitle: UIFont {
        UIFont.systemFont(ofSize: 17.0)
    }
}
