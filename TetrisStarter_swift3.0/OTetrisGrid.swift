//
//  OTetrisGrid.swift
//  TetrisStarter_swift3.0
//
//  Created by Gaybriella Igno on 10/3/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

class OTetrisGrid: TetrisBlockModel {

	private var color = UIColor.yellow.withAlphaComponent(0.9)
	
	let ogrid = [
		[true, true],
		[true, true]
	]
	
	init() {
		super.init(tetrisGrid: ogrid)
	}
	
	func getColor() -> UIColor {
		return self.color
	}
	
	func startY() -> CGFloat {
		return CGFloat(0)//0 - (30 * 2) + 1)
	}
	
}
