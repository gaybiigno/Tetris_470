//
//  TTetrisGrid.swift
//  TetrisStarter_swift3.0
//
//  Created by Gaybriella Igno on 10/2/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

class TTetrisGrid: TetrisBlockModel {
	
	private var color = UIColor.init(red: 0.5, green: 0, blue: 0.6, alpha: 0.9)

	let tgrid = [
		[true, true, true],
		[false, true, false]
	]
	
	init() {
		super.init(tetrisGrid: tgrid)
	}
	
	func getColor() -> UIColor {
		return self.color
	}
	
}
