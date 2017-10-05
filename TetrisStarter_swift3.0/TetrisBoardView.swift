//
//  TetrisBoard.swift
//  TetrisStarter
//
//  Created by AAK on 9/30/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisBoardView: UIView {

    let gapBetweenCenters: CGFloat
    let markerRadius: CGFloat
    
    init(withFrame frame: CGRect, blockSize: Int, circleRadius: Int) {
        gapBetweenCenters = CGFloat(blockSize)
        markerRadius = CGFloat(circleRadius)
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("in TetrisBoard: rect is \(rect)")
        super.draw(rect)
        let numRows = Int(rect.size.height / CGFloat(gapBetweenCenters))
        let numColumns = Int(rect.size.width / CGFloat(gapBetweenCenters))

        var circles = [UIBezierPath]()
        for row in 0 ... numRows { // was <
            let y = 10 + gapBetweenCenters * CGFloat(row) // lined up w/ 10 +
            for column in 0 ... numColumns { // was <
                let x = gapBetweenCenters * CGFloat(column)
                let center = CGPoint(x: x, y: y)
				let aPointInSuperView = superview!.convert(center, from: self)
				let marker = UIBezierPath(arcCenter: aPointInSuperView, radius: markerRadius,
				                          startAngle: 0.0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)
//                let marker = UIBezierPath(arcCenter: center, radius: markerRadius,
//                                          startAngle: 0.0, endAngle: CGFloat(2.0 * Double.pi), clockwise: false)
                circles.append(marker)
            }
        }
        UIColor.lightGray.setFill()
        for circle in circles {
            circle.fill()
        }
    }


    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}
