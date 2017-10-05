//
//  BlockEdgeAttributes.swift
//  TetrisStarter
//
//  Created by AAK on 9/29/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

enum Edges: Int {
    case top = 0,
    bottom = 1,
    left = 2,
    right = 3
}

struct GridWrapper {  // a wrapper around a 2D array so that we can talk about the 
                      // the number of columns by use of numColumns() instead of
                      // grid[0].count
    let grid: [[Bool]]
    
    init(_ grid: [[Bool]]) {
        self.grid = grid
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
    
}

// Given a grid that represents a Tetris block, this class creates
// an instance of TetrisBlockEdge for each of its four sides.

class GridEdgeAttributes: NSObject {
    private var edges = [TetrisBlockEdge]()
    private var hasCalculatedEdgeValues = false
    private let grid: GridWrapper
    private let edgeNames: [Edges] = [.top, .right, .bottom, .left]
    let numberOfEdges: Int
    
    init(grid: [[Bool]]) {
        self.grid = GridWrapper(grid)
		print("Number of columns \(self.grid.numColumns()), rows \(self.grid.numRows())")
        numberOfEdges = edgeNames.count
        super.init()
        for edgeName in edgeNames {
            let edge = edgeValues(edge: edgeName)
            edges.append(TetrisBlockEdge(edgeOffsets: edge, edge: edgeName))
        }
     }
    
    func edgeAttributes(edgeIndex: Int) -> TetrisBlockEdge? {
        if edgeIndex < 0 || edgeIndex >= numberOfEdges {
            return nil
        }
        return edges[edgeIndex]
    }
    
    func edgeAttributes(edgeName: Edges) -> TetrisBlockEdge? {
        for edge in edges {
            if edge.edgeName == edgeName {
                return edge
            }
        }
        return nil
    }
    
    func edgeValues(edge: Edges) -> [Int] {
        switch edge {
        case .top:
            return calcuateTopEdgeIndentationValues(grid: grid)
        case .bottom:
            return calcuateBottomEdgeIndentationValues(grid: grid)
        case .left:
            return calcuateLeftEdgeIndentationValues(grid: grid)
        case .right:
            return calcuateRightEdgeIndentationValues(grid: grid)
        }
    }
}

private extension GridEdgeAttributes {
    func calcuateTopEdgeIndentationValues(grid: GridWrapper) -> [Int] {
		
        var edgeValues = [Int]()
        for column in 0 ..< grid.numColumns() {
            var firstVisibleBlockIdx = 0
            while firstVisibleBlockIdx < grid.numRows() && !grid.hasBlockAt(row: firstVisibleBlockIdx, column: column) {
                firstVisibleBlockIdx += 1
            }
            edgeValues.append(firstVisibleBlockIdx)
        }
        return edgeValues
    }
    
    func calcuateBottomEdgeIndentationValues(grid: GridWrapper) -> [Int] {
        var edgeValues = [Int]()
        
        for column in 0 ..< grid.numColumns() {
            var firstVisibleBlockIdx = grid.numRows() - 1 // first from the bottom
            while firstVisibleBlockIdx >= 0 && !grid.hasBlockAt(row: firstVisibleBlockIdx, column: column) {
                firstVisibleBlockIdx -= 1
            }
            edgeValues.append(grid.numRows() - firstVisibleBlockIdx - 1)
        }
        return edgeValues
    }
    
    func calcuateLeftEdgeIndentationValues(grid: GridWrapper) -> [Int] {
        var edgeValues = [Int]()

        for row in 0 ..< grid.numRows() {
            var firstVisibleBlockIdx = 0 // first from the bottom
            while firstVisibleBlockIdx < grid.numColumns() && !grid.hasBlockAt(row: row, column: firstVisibleBlockIdx) {
                firstVisibleBlockIdx += 1
            }
            edgeValues.append(firstVisibleBlockIdx)
        }
        return edgeValues
    }
    
    func calcuateRightEdgeIndentationValues(grid: GridWrapper) -> [Int] {
        var edgeValues = [Int]()

        for row in 0 ..< grid.numRows() {
            var firstVisibleBlockIdx = grid.numColumns() - 1 // first from the bottom
            while firstVisibleBlockIdx >= 0 && !grid.hasBlockAt(row: row, column: firstVisibleBlockIdx) {
                firstVisibleBlockIdx -= 1
            }
            edgeValues.append(grid.numColumns() - firstVisibleBlockIdx - 1)

        }
        return edgeValues
    }
}

