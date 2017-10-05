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
		[true, true, false],
		[true, true, false]
	]
	
	init() {
		super.init(tetrisGrid: ogrid)
	}
	
	func getColor() -> UIColor {
		return self.color
	}
	
}
