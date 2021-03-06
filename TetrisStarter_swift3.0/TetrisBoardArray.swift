//
//  TetrisBoardArray.swift
//  TetrisStarter_swift3.0
//
//  Created by Gaybi Igno on 10/8/17.
//  Copyright © 2017 Ali A. Kooshesh. All rights reserved.
//

import UIKit

class TetrisBoardArray: NSObject {
	var grid: [[Bool]]
	var min: Int
	
	init(numRows: Int, numCols: Int) {
		var array = [[Bool]]()
		for _ in 0 ..< numRows {
			var currentRow = [Bool]()
			for _ in 0 ..< numCols {
				currentRow.append(false)
			}
			array.append(currentRow)
		}
		self.grid = array
		self.min = grid.count
		super.init()
		
		//print("ARRAY ROWS: \(grid.count), COLS: \(grid[0].count)")
	}
	
	func numColumns() -> Int {
		return grid[0].count
	}
	
	func numRows() -> Int {
		return grid.count
	}
	
	func hasBlockAt(row: Int, column: Int) -> Bool {
		return row < numRows() && column < numColumns() && self.grid[row][column]
	}
	
	func hasBlockBetween(row: Int, firstCol: Int, secondCol: Int) -> Bool {
		if !(row < numRows() && secondCol < numColumns() && firstCol >= 0){
			return false
		}
		for col in firstCol ... secondCol {
			if hasBlockAt(row: row, column: col) {
				return true
			}
		}
		return false
	}
	
	func changeValue(row: Int, column: Int) {
		self.grid[row][column] = !self.grid[row][column]
		if row < min {
			min = row
		}
	}
	
	func getRowCol(point: CGPoint) -> (Int, Int) {
		let row = Int(round( point.y / 30 ))
		let col = Int( point.x / 30 )
		return (row, col)
	}
	
	func getMinRow() -> Int {
		return min
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
	
	// Returns true if entire row is full
	func checkRow(row: Int) -> Bool {
		//printArray()
		for col in 0 ..< numColumns() {
			if grid[row][col] == false {
				return false
			}
		}
		for col in 0 ..< numColumns() { 
			grid[row][col] = false
		}
		
		// Reset minimum
		if row == min {
			for r in min + 1 ..< numRows() {
				if hasBlockBetween(row: r, firstCol: 0, secondCol: numColumns() - 1) {
					min = r
					break
				}
			}
		}
		return true
	}
}
