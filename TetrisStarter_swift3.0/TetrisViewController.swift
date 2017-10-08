//
//  TetrisViewController.swift
//  TetrisStarter
//
//  Created by AAK on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisViewController: UIViewController {
    
    let blockSize = 30
    var tetrisBoard: TetrisBoardView!
    var block: TetrisBlockView!
	var boardArray: TetrisBoardArray!
    var inMotion = false
    var paused = false
    
    @IBAction func didTapTheView(_ sender: UITapGestureRecognizer) {
        if !inMotion  {
            inMotion = true
            block.startDescent()
            return
        }
        let location = sender.location(in: tetrisBoard)
        print(location)
		block.rotateClockWise()
     }
    
    @IBAction func didSwipeView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            block.moveLeft()
        } else {
            block.moveRight()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tetrisBoard = TetrisBoardView(withFrame: UIScreen.main.bounds, blockSize: blockSize, circleRadius: 1 )
        view.addSubview(tetrisBoard)
		
		startGrid()
		view.addSubview(block)
		print("Center of block before animation: \(block.center)")
        print("Bounds of main screen is \(UIScreen.main.bounds)")
		
		// Setting board bounds to entire screen
		block.setBoardBounds(boardSize: UIScreen.main.bounds.size)
		
		let numRows = Int(UIScreen.main.bounds.size.height / CGFloat(blockSize))
		let numColumns = Int(UIScreen.main.bounds.size.width / CGFloat(blockSize))
		
		boardArray = TetrisBoardArray(numRows: numRows, numCols: numColumns)
		block.getBoardArray(array: boardArray)
    }
	
	func startGrid() {
		let number = Int(arc4random_uniform(8))
		switch (number) {
		case 0: // Send for I
			let grid = ITetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 1: // Send for J
			let grid  = JTetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 2: // Send for L
			let grid = LTetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 3: // Send for O
			let grid = OTetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 4: // Send for S
			let grid = STetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 5: // Send for T
			let grid = TTetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 6: // Send for Z
			let grid = ZTetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		default: // Send for J
			let grid = JTetrisGrid()
			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		}
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
