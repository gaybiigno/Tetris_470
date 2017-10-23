//
//  TetrisGrid.swift
//  TetrisStarter
//
//  Created by AAK on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit


enum OffsetTraversal {
    case forward
    case backward
}

class TetrisBlockModel: NSObject {
	private var grid: [[Bool]]  // Every row is expected to have the same number of columns
    private var blockEdgeAttributes: GridEdgeAttributes!
    private var blockEdges = [TetrisBlockEdge]()
    private let edges: [Edges] = [.bottom, .left, .top, .right]  // Any order will work
    private let bottomEdgeIdx = 0
    private var currentDirection: OffsetTraversal
	private var hasRotated = false

    init(tetrisGrid: [[Bool]]) {
        grid = tetrisGrid
        currentDirection = .forward
        super.init()
        blockEdgeAttributes = GridEdgeAttributes(grid: smallestVisibleGrid()!)
        for edge in edges {
			blockEdges.append( blockEdgeAttributes.edgeAttributes(edgeName: edge)! )
        }
    }
	
    func printEdges() {
        for edge in edges {
            let edgeAttr = edgeAttributes(edge: edge)
            print(edgeAttr.edgeName, edgeAttr.direction)
            print(edgeAttr.edgeOffsets())
        }
    }
	
	func getEdge(name: Edges) -> [Int]{
		return edgeAttributes(edge: name).edgeOffsets()
	}
	
	func getGrid() -> [[Bool]] {
		return grid
	}
	
    func didRotateClockwise() {
        let lastIdx = blockEdges.count - 1
        //printEdges()
		print()
        blockEdges = [blockEdges[lastIdx]] + blockEdges[0 ... lastIdx - 1]
        blockEdges[0].reverseOffsets()
        blockEdges[2].reverseOffsets()
        //printEdges()
		rotateGrid()
    }
	
	func rotateGrid() {
		var temp = [[Bool]](repeatElement([Bool](repeatElement(false, count: numRows())), count: numColumns()))
		for row in 0 ..< numColumns() {
			for cols in 0 ..< numRows() {
				temp[row][cols] = self.grid[numRows() - cols - 1][row]
			}
		}
		self.grid = temp
		self.hasRotated = !self.hasRotated
	}
    
    func edgeAttributes(edge: Edges) -> TetrisBlockEdge {
        var idx = 0
        switch edge {
        case Edges.bottom:
            idx = 0
        case Edges.left:
            idx = 1
        case Edges.top:
            idx = 2
        case Edges.right:
            idx = 3
        }
        blockEdges[idx].direction = currentDirection
        return blockEdges[idx]
    }
    
    func hasBlockAt(row: Int, column: Int) -> Bool {
//		if self.hasRotated {
//			return self.grid[column][row]
//		}
        return self.grid[row][column]
    }
    
    func numRows() -> Int {
        return grid.count
    }
    
    func numColumns() -> Int {
        // pre-condition: every row has the same number of columns.
        return grid[0].count
    }
    
    func blocksWide() -> Int {
        //return numColumns()
		return self.grid[0].count
		//return (smallestVisibleGrid()![0].count < grid[0].count) ? smallestVisibleGrid()![0].count : grid[0].count
    }
    
    func blocksHeight() -> Int {
        //return numRows()
		return self.grid.count
		//return ((smallestVisibleGrid()?.count)! < grid.count) ? (smallestVisibleGrid()?.count)! : grid.count
    }
    
    func smallestVisibleGrid() -> [[Bool]]? {
        return smallestSpanningGrid()
    }
    
}

private extension TetrisBlockModel {
    func rowHasAVisibleBlock(row: Int) -> Bool {
        for column in 0 ..< numColumns() {
            if hasBlockAt(row: row, column: column) {
                return true
            }
        }
        return false
    }
    
    func columnHasAVisibleBlock(column: Int) -> Bool {
        for row in 0 ..< numRows() {
            if hasBlockAt(row: row, column: column) {
                return true
            }
        }
        return false
    }
    
    func smallestSpanningGrid() -> [[Bool]]? {
        // Finds the smallest two dimentional array that contains all
        // squares of the Tetris grid.
		if numRows() == 1 { // IF its itetris grid
			print("Got itetris grid!")
			var visibleBlock = [[Bool]]()
			var currentRow = [Bool]()
			for _ in 0 ..< 4 {
				currentRow.append( true )
			}
			visibleBlock.append(currentRow)
			return visibleBlock
		}
        var firstRow = 0
        while firstRow < numRows() && !rowHasAVisibleBlock(row: firstRow) {
            firstRow += 1
        }
        if firstRow == numRows() {
			 return nil
        }
        var firstColumn = 0
        while firstColumn < numColumns() && !columnHasAVisibleBlock(column: firstColumn) {
            firstColumn += 1
        }
        if firstColumn == numColumns() {
            return nil
        }
        var lastVisibleRow = 0, lastVisibleColumn = 0
        for row in firstRow ..< numRows() {
            var didSeeAVisibleBlock = false
            for column in firstColumn ..< numColumns() {
				if hasBlockAt(row: row, column: column) && column > lastVisibleColumn {
                    lastVisibleColumn = column
                    didSeeAVisibleBlock = true
                }
            }
            if didSeeAVisibleBlock {
                lastVisibleRow = row
            }
        }
		let numVisibleRows = (lastVisibleRow == firstRow + 1) ? lastVisibleRow : (lastVisibleRow - firstRow + 1)
        let numVisibleColumns = lastVisibleColumn - firstColumn + 1
        var visibleBlock = [[Bool]]()
		for row in 0 ... numVisibleRows {
			var currentRow = [Bool]()
			for column in 0 ..< numVisibleColumns {
				currentRow.append( hasBlockAt(row: row + firstRow, column: column + firstColumn) )
			}
			visibleBlock.append(currentRow)
		}
        return visibleBlock
    }
}
