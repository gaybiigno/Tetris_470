//
//  STetrisGrid.swift
//  TetrisStarter_swift3.0
//
//  Created by Gaybriella Igno on 10/2/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

class STetrisGrid: TetrisBlockModel {
	
	private var color = UIColor.init(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.9)

	let sgrid = [
		[false, true, true],
		[true, true, false]
	]
	
	init() {
		super.init(tetrisGrid: sgrid)
	}
	
	func getColor() -> UIColor {
		return self.color
	}
	
	func startY() -> CGFloat {
		return CGFloat(0 - (30 * 2) + 1)
	}
}
