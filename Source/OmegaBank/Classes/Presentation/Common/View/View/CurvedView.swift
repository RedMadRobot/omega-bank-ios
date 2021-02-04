//
//  BeautifulView.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/24/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class CurvedView: View {
    
    // MARK: - Initialization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let step: CGFloat = frame.width / 2
        // - step потому что 3 цвета в коллекции
        let bounds = CGRect(
            origin: .zero,
            size: CGSize(width: frame.size.width - step, height: frame.size.height))
        
        let palette: [UIColor] = [
            .curve1,
            .curve2,
            .makeGradient(
                from: .bar1,
                to: .bar2,
                on: bounds)]
        
        for i in 0..<min(palette.count, 3) {
            let color = palette[i]

            let cl = makeCurveLayer(color: color)
            let scaleTransform = CGAffineTransform(scaleX: 2, y: 1)
            let translationTransform = CGAffineTransform(translationX: -(step * CGFloat(i)), y: 0)
            
            cl.setAffineTransform(scaleTransform.concatenating(translationTransform))
         
            // Мы должны вставлять слои по индексам, чтобы не перекрыть subViews.
            layer.insertSublayer(cl, at: UInt32(i))
        }
    }
    
    // MARK: - Private methods

    private func makeCurveLayer(
        color: UIColor,
        delta: CGPoint = CGPoint(x: 0, y: 60)) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = makeBezierPath(delta: delta).cgPath
        shapeLayer.fillColor = color.cgColor

        return shapeLayer
    }

    private func makeBezierPath(delta: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: -(delta.x), y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height - delta.y))
        var d = CGPoint(x: (frame.width / 2) + delta.x, y: frame.height - delta.y)
        path.addCurve(to: d,
                      controlPoint1: CGPoint(x: (frame.width * 0.75) + -(delta.x), y: frame.height - 2 * delta.y),
                      controlPoint2: d)
        d = CGPoint(x: -(delta.x), y: frame.height - delta.y)
        path.addCurve(to: d,
                      controlPoint1: CGPoint(x: (frame.width * 0.25) + -(delta.x), y: frame.height),
                      controlPoint2: d)
        path.addLine(to: CGPoint(x: -(delta.x), y: 0))
        path.close()
        
        return path
    }
}
