//
//  JTetrisGrid.swift
//  TetrisStarter
//
//  Created by AAK on 9/27/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class JTetrisGrid: TetrisBlockModel {
	
	private var color = UIColor.init(red: 0, green: 0.2, blue: 0.8, alpha: 0.9)

    let jgrid = [
        [true, false, false],
        [true, true, true]
    ]
    
    init() {
        super.init(tetrisGrid: jgrid)
    }

	func getColor() -> UIColor {
		return self.color
	}
	
	func startY() -> CGFloat {
		return CGFloat(0 - (30) + 1)
		//return CGFloat(0 - (30 * 2) + 1)
	}
	
}
