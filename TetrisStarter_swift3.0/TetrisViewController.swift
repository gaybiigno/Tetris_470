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
    var currBlock: TetrisBlockView!
	var nextBlock: TetrisBlockView!
	var startCenter: CGPoint!
	var boardArray: TetrisBoardArray!
    var inMotion = false
    var paused = false
	var clock = Timer()
	var score: UILabel!
	var scoreCount = 0
	
	func startTimer() -> Timer {
		let timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
		return timer
	}
	
	func updateTimer(_ sender: Timer) {
		if currBlock.isOver() {
			nextBlock.removeFromSuperview()
			nextBlock.center = startCenter
			currBlock = nextBlock
			nextBlock = startGrid()
			view.addSubview(currBlock)
			displayNextBlock()
			currBlock.setBoardBounds(boardSize: UIScreen.main.bounds.size)
			currBlock.getBoardArray(array: boardArray)
			checkRows()
			currBlock.startDescent()
			clock = startTimer()
		}
	}
    
    @IBAction func didTapTheView(_ sender: UITapGestureRecognizer) {
        if !inMotion  {
            inMotion = true
            currBlock.startDescent()
			clock = startTimer()
            return
		} 
        let location = sender.location(in: tetrisBoard)
        print(location)
		currBlock.rotateClockWise()
     }
    
    @IBAction func didSwipeView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            currBlock.moveLeft()
        } else {
            currBlock.moveRight()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tetrisBoard = TetrisBoardView(withFrame: UIScreen.main.bounds, blockSize: blockSize, circleRadius: 1 )
		tetrisBoard.tag = -1
        view.addSubview(tetrisBoard)
		
		currBlock = startGrid()
		nextBlock = startGrid()
		view.addSubview(currBlock)
		displayNextBlock()
		
		let textView = UITextView(frame: CGRect(x: CGFloat(20.0), y: CGFloat(630.0),
		                                        width: 20.0, height: 80.0))
		textView.text = "next"
		textView.isEditable = false
		textView.isSelectable = false
		textView.font = UIFont(name: (textView.font?.fontName)!, size: 14.0)
		textView.tag = -2
		view.addSubview(textView)
		
		score = UILabel(frame: CGRect(x: CGFloat(300.0), y: CGFloat(630.0),
		                                  width: 20.0, height: 80.0))
		score.text = String(scoreCount)
		score.isUserInteractionEnabled = false
		score.font = UIFont(name: (score.font?.fontName)!, size: 14.0)
		score.tag = -3
		view.addSubview(score)
		
		// Setting board bounds to entire screen
		currBlock.setBoardBounds(boardSize: UIScreen.main.bounds.size)
		print("Board bounds: \(UIScreen.main.bounds.size)")
		
		let numRows = 21 //Int(UIScreen.main.bounds.size.height / CGFloat(blockSize))
		let numColumns = Int(UIScreen.main.bounds.size.width / CGFloat(blockSize))
		
		boardArray = TetrisBoardArray(numRows: numRows, numCols: numColumns)
		currBlock.getBoardArray(array: boardArray)
    }
	
	func startGrid() -> TetrisBlockView! {
		let number = Int(arc4random_uniform(7)) + 1
		let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
		switch (number) {
//		case 0: // Send for I
//			let grid = ITetrisGrid()
//			let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
//			block = TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
//			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 1: // Send for J
			let grid  = JTetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 2: // Send for L
			let grid = LTetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 3: // Send for O
			let grid = OTetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 4: // Send for S
			let grid = STetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 5: // Send for T
			let grid = TTetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		case 6: // Send for Z
			let grid = ZTetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		default: // Send for J
			let grid = JTetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
		}
	}
	
	func displayNextBlock() {
		startCenter = nextBlock.center
		nextBlock.center = CGPoint(x: CGFloat(135), y: CGFloat(670.0)) // was 668
		print("Next is centered at \(nextBlock.center)")
		view.addSubview(nextBlock)
	}
	
	func checkRows() {
		for row in boardArray.getMinRow() ..< boardArray.numRows() {
			if boardArray.checkRow(row: row) {
				findSubsInRow(row: row)
			}
		}
	}
	
	func findSubsInRow(row: Int) {
		for sub in view.subviews {
			if sub.tag < 0 {
				continue
			}
			let viewFrame = sub.frame
			let minRow = Int(viewFrame.minY / CGFloat(blockSize))
			let maxRow = Int((viewFrame.minY + viewFrame.height) / CGFloat(blockSize))
			for r in minRow ... maxRow {
				if r == row {
					let resub = sub as! TetrisBlockView
					resub.removeRowFromView(row: row - minRow)
				}
			}
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
