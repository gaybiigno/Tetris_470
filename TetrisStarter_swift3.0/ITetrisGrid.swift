//
//  ITetrisGrid.swift
//  TetrisStarter_swift3.0
//
//  Created by Gaybriella Igno on 10/3/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

class ITetrisGrid: TetrisBlockModel {

	private var color = UIColor.init(red: 0, green: 0.5, blue: 0.5, alpha: 0.9)
	
	let igrid = [
		[true, true, true, true],
		[false, false, false, false]
	]
	
	init() {
		super.init(tetrisGrid: igrid)
	}
	
	func getColor() -> UIColor {
		return self.color
	}
	
	func startY() -> CGFloat {
		return CGFloat(0)
		//return CGFloat(0 - (30) + 1)
	}
	
}
