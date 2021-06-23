//
//  Color.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 25.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Text Colors
    
    static var textPrimary: UIColor { UIColor(named: #function)! }
    static var textSupplementary: UIColor { UIColor(named: #function)! }
    
    // MARK: - Bar Colors
    
    static var bar: UIColor { UIColor(named: #function)! }
    static var bar1: UIColor { UIColor(named: #function)! }
    static var bar2: UIColor { UIColor(named: #function)! }
    
    // MARK: - Curve Colors
    
    static var curve1: UIColor { UIColor(named: #function)! }
    static var curve2: UIColor { UIColor(named: #function)! }
    static var ph1: UIColor { UIColor(named: #function)! }
    static var ph2: UIColor { UIColor(named: #function)! }
    static var ph3: UIColor { UIColor(named: #function)! }
    
    // MARK: - View Colors
    static var cellBorder: UIColor { UIColor(named: #function)! }
    
    // MARK: - Background Colors
    
    static var backgroundPrimaryPressed: UIColor { UIColor(named: #function)! }
    static var scrollViewBackground: UIColor { UIColor(named: #function)! }
    static var defaultBackground: UIColor { UIColor(named: #function)! }
    
    // MARK: - Palette
    
    static var palette: [UIColor] = [.bar2, .bar1, .ph2]
    
    // MARK: - Gradient Methods
    
    static func makeGradient(from firstColor: UIColor, to secondColor: UIColor, on bounds: CGRect) -> UIColor {
        guard let image = CAGradientLayer.makeGradientFrom(firstColor: firstColor, to: secondColor, on: bounds)
            else { return .bar }
        
        return UIColor(patternImage: image)
        
    }

}
