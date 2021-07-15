//
//  LoginBackground.swift
//  OmegaBankSwiftUI
//
//  Created by Anna Kocheshkova on 12.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import SwiftUI
import UIKit

enum FillColor {
    case color(_ color: Color)
    case gradient(color1: Color, color2: Color)
}

struct LoginBackground: View {
    
    static let viewsCount = 3
    var palettes: [FillColor] {
        return [
            .color(Color(.curve1)),
            .color(Color(.curve2)),
            .gradient(color1: Color(.bar1), color2: Color(.bar2))
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<LoginBackground.viewsCount) { i in
                let translation = -(geometry.size.width / 2 * CGFloat(i))
                CurvedView(
                    translationTransform:
                        CGAffineTransform(translationX: translation, y: 0),
                    color: palettes[i])
            }
        }
    }
}

struct LoginBackground_Previews: PreviewProvider {
    static var previews: some View {
        LoginBackground()
    }
}
