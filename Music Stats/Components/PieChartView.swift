//
//  PieChartView.swift
//  Music Stats
//
//  Created by Zac Garby on 14/04/2018.
//  Copyright © 2018 Zac Garby. All rights reserved.
//

import UIKit

@IBDesignable class PieChartView: UIView {
    var data: [(String, Double)] = [("foo", 20), ("bar", 50), ("baz", 30)]
    var paths: [String:(UIBezierPath, UIColor)] = [:]
    var colours: [UIColor] = [.red, .white]
    var selected: String? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width * 0.4
        let anglePerUnit = (Double.pi * 2) / total()
        var startAngle = Double.pi * 0.5
        var colourIndex = 0
        
        for (key, value) in data {
            let angle = value * anglePerUnit
            
            let path = UIBezierPath()
            path.move(to: center)
            
            if key == selected {
                path.addArc(withCenter: center,
                            radius: radius * 1.06,
                            startAngle: CGFloat(startAngle),
                            endAngle: CGFloat(startAngle + angle),
                            clockwise: true)
            } else {
                path.addArc(withCenter: center,
                            radius: radius,
                            startAngle: CGFloat(startAngle),
                            endAngle: CGFloat(startAngle + angle),
                            clockwise: true)
            }
            
            path.move(to: center)
            let colour = colours[colourIndex]
            colour.setFill()
            path.fill()
            
            startAngle += angle
            colourIndex = (colourIndex + 1) % colours.count
        }
    }
    
    func total() -> Double {
        return data.reduce(0.0, { result, pair in return result + pair.1 })
    }
    
    func getPercentage(of key: String) -> Double? {
        if let (_, amount) = data.first(where: { category in return category.0 == key }) {
            return amount / total()
        }
        
        print("couldn't get percentage for \(key): \(data.description)")
        return nil
    }
    
    func generateColours() -> [UIColor] {
        let count = Double(data.count)
        var hue = 0.0
        var colours: [UIColor] = []
        
        for (key, _) in data {
            if key == "\0\0" { // two null characters denotes "other"
                colours.append(UIColor(
                    hue: 0.0,
                    saturation: 0.0,
                    brightness: 0.8,
                    alpha: 1.0))
            } else {
                colours.append(UIColor(
                    hue: CGFloat(hue),
                    saturation: 0.55,
                    brightness: 1.0,
                    alpha: 1.0))
                hue += 1 / count
            }
        }
        
        return colours
    }
    
    func colour(for name: String) -> UIColor? {
        for (index, (key, _)) in data.enumerated() {
            if key == name {
                return colours[index]
            }
        }
        
        return nil
    }
    
    func load(data: [(String, Double)]) {
        self.data = data
        colours = generateColours()
        setNeedsDisplay()
    }
}
