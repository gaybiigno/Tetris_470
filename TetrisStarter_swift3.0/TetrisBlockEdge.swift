//
//  TetrisGridEdgeAttributes.swift
//  TetrisStarter
//
//  Created by AAK on 9/30/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

// This class represents the indentations of an edge of Tetris block. 
// The idea is to, as a block is about to be dropped, figure out its distance
// to the bottom of the board, which is a rectilinear surface. To that end, you
// would need to find the minnimu of the distances of the bottom of each of the 
// sub-blocks to the bottom of the board. This class keeps the necessary information
// for that purpose for one of the 4 sides of a given block.



// For example, consider the following Z-Block

// [ [true, true, false],
//   [false, true, true] ]

// The bottom of this block can be represented as:

// 1 0 0

// In addition, let's say the following values represent the 3 bocks at the 
// bottom of the board that line up with these three sub-blocks. 

// 4 2 3

// Now, suppose that each sub-block is 20x20 points and that the y of the bottom is
// at 400 points. Further, assume that the bottom of the block that is about to fall
// is at 100.

// The distance between the sub-blocks and the bottom, from left to right, are:

// 240 260 240

// So, the block can only travel 240 downward.


class TetrisBlockEdge: NSObject {
    
    let edgeName: Edges
    var offsets: [Int]
    var direction = OffsetTraversal.forward
    var reverse = [Int]()
    
    init(edgeOffsets offsets: [Int], edge: Edges) {
        self.offsets = offsets
        edgeName = edge
        super.init()
        for i in 0 ..< offsets.count {
            reverse.append(offsets[offsets.count - i - 1])
        }
    }

    func reverseOffsets() {
        let tmp = offsets
        offsets = reverse
        reverse = tmp
    }
    
    func edgeOffsets() -> [Int] {
        return offsets
    }
    
}
