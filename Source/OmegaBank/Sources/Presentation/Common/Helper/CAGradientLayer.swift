//
//  CAGradientLayer.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    /// Создаем градиентное изображение.
    
    static func makeGradientFrom(firstColor: UIColor, to secondColor: UIColor, on bounds: CGRect) -> UIImage? {
        let gradient = CAGradientLayer()

        gradient.frame = bounds
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let gradientImage = renderer.image { context in
            gradient.render(in: context.cgContext)
        }

        return gradientImage
    }
}
