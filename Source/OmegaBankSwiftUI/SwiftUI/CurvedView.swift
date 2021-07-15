//
//  SwiftUIView.swift
//  OmegaBankSwiftUI
//
//  Created by Anna Kocheshkova on 12.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import SwiftUI
import CoreGraphics
import UIKit


struct CurvedView: View {
    let translationTransform: CGAffineTransform
    let color: FillColor
    
    func createPath(_ path: inout Path, geometry: GeometryProxy) {
        let delta = CGPoint(x: 0, y: 60)
        path.move(to: CGPoint(x: -(delta.x), y: 0))
        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height - delta.y))
        var d = CGPoint(x: (geometry.size.width / 2) + delta.x, y: geometry.size.height - delta.y)
        path.addCurve(to: d,
                      control1: CGPoint(x: (geometry.size.width * 0.75) + -(delta.x), y: geometry.size.height - 2 * delta.y),
                      control2: d)
        d = CGPoint(x: -(delta.x), y: geometry.size.height - delta.y)
        path.addCurve(to: d,
                      control1: CGPoint(x: (geometry.size.width * 0.25) + -(delta.x), y: geometry.size.height),
                      control2: d)
        path.addLine(to: CGPoint(x: -(delta.x), y: 0))
    }
    
    var body: some View {
        let scaleTransform = CGAffineTransform(scaleX: 2, y: 1)
        GeometryReader { geometry in
            switch color {
            case .color(let c):
                Path { path in createPath(&path, geometry: geometry) }
                    .fill(c)
                    .transformEffect(scaleTransform.concatenating(translationTransform))
            case .gradient(let c1, let c2):
                let gradient = LinearGradient(
                    gradient: Gradient(colors: [c1, c2]),
                    startPoint: UnitPoint(x: 0, y: 0),
                    endPoint: UnitPoint(x: geometry.size.width - geometry.size.width / 2, y: geometry.size.height))
                Path { path in createPath(&path, geometry: geometry) }
                    .fill(gradient)
                    .transformEffect(scaleTransform.concatenating(translationTransform))
            }
        }
    }
}

struct CurvedView_Previews: PreviewProvider {
    static var previews: some View {
        CurvedView(translationTransform: CGAffineTransform(scaleX: 2, y: 1), color: .color(.accentColor))
    }
}
