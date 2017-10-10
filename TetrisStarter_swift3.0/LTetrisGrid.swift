//
//  LTestrisGrid.swift
//  TetrisStarter_swift3.0
//
//  Created by Gaybriella Igno on 10/2/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

class LTetrisGrid: TetrisBlockModel {
	
	private var color = UIColor.init(red: 0.8, green: 0.3, blue: 0.1, alpha: 0.9)

	let lgrid = [
		[false, false, true],
		[true, true, true]
	]
	
	init() {
		super.init(tetrisGrid: lgrid)
	}
	
	func getColor() -> UIColor {
		return self.color
	}
	
	func startY() -> CGFloat {
		return CGFloat(0)//0 - (30 * 2) + 1)
	}
	
}
