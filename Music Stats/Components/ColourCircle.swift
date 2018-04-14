//
//  ColourCircle.swift
//  Music Stats
//
//  Created by Zac Garby on 14/04/2018.
//  Copyright © 2018 Zac Garby. All rights reserved.
//

import UIKit

@IBDesignable class ColourCircle: UIView {
    var fill: UIColor = .blue {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(
            arcCenter: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width * 0.35,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true)
        
        fill.setFill()
        path.fill()
    }
}
