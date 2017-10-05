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
		[true, true, true],
		[true, false, false]
	]
	
	init() {
		super.init(tetrisGrid: lgrid)
	}
	
	func getColor() -> UIColor {
		return self.color
	}
	
}
