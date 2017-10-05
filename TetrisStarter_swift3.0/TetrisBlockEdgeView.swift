//
//  TetrisBlockEdgeView.swift
//  TetrisStarter
//
//  Created by AAK on 10/1/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisBlockEdgeView: NSObject {

    let blockEdge: TetrisBlockEdge
    let blockFrame: CGRect
    
    init(blockEdge: TetrisBlockEdge, blockFrame: CGRect) {
        self.blockEdge = blockEdge
        self.blockFrame = blockFrame
        super.init()
     }
    
}
