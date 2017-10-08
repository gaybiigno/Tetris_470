//
//  TetrisBoardArray.swift
//  TetrisStarter_swift3.0
//
//  Created by Gaybriella Igno on 10/8/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

struct ArrayWrapper {  // a wrapper around a 2D array so that we can talk about the
	// the number of columns by use of numColumns() instead of
	// grid[0].count
	
	var grid: [[Bool]]
	
	init(_ grid: [[Bool]]) {
		self.grid = grid
	}
	
	func numColumns() -> Int {
		return grid[0].count
	}
	
	func numRows() -> Int {
		return grid.count
	}
	
	mutating func setBlock(row: Int, column: Int) {
		grid[row][column] = !grid[row][column]
	}
	
	func hasBlockAt(row: Int, column: Int) -> Bool {
		return row < numRows() && column < numColumns() && grid[row][column]
	}
	
	func getRowCol(point: CGPoint) -> (Int, Int) {
		let x = point.x
		let y = point.y
		
		let row = Int((y - 30.0)/30)
		let col = Int(x/30)
		
		return (row, col)
	}
	
}

class TetrisBoardArray: NSObject {
	//private var grid: ArrayWrapper
	var grid: [[Bool]]
	
	init(numRows: Int, numCols: Int) {
		
		var array = [[Bool]]()
		for _ in 0 ..< numRows {
			var currentRow = [Bool]()
			for _ in 0 ..< numCols {
				currentRow.append(false)
			}
			array.append(currentRow)
		}
		self.grid = array //ArrayWrapper(array)
		super.init()
	}
	
	func numColumns() -> Int {
		return grid[0].count
	}
	
	func numRows() -> Int {
		return grid.count
	}
	
	func hasBlockAt(row: Int, column: Int) -> Bool {
		return row < numRows() && column < numColumns() && grid[row][column]
	}
	
	func changeValue(row: Int, column: Int) {
		grid[row][column] = !grid[row][column]
	}
	
	func getRowCol(point: CGPoint) -> (Int, Int) {
		let row = Int((point.y + 30.0)/30)
		let col = Int(point.x/30)
		
		return (row, col)
	}
	
	func printArray() {
		for row in 0 ..< numRows() {
			for col in 0 ..< numColumns() {
				if hasBlockAt(row: row, column: col) {
					print("Has block at: \(row), \(col)")
				}
			}
		}
	}

//	func numRows() -> Int {
//		return grid.numRows()
//	}
//
//	func numCols() -> Int {
//		return grid.numColumns()
//	}
	
	
	
	
	
}
