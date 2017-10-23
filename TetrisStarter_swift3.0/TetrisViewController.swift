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
	var clock = Timer()
	var endScore = UIButton(frame: CGRect(x: 10.0, y: UIScreen.main.bounds.midY - 10.0,
	                                     width: UIScreen.main.bounds.width - 20.0, height: 100.0))
	var score: UILabel!
	var scoreCount = 0
	
	func startTimer() -> Timer {
		let timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
		return timer
	}
	
	func updateTimer(_ sender: Timer) {
		if currBlock.isOver() {
			// If the game is over
			if currBlock.center == startCenter {
				print("SHOULD END")
				clock.invalidate()
				for sub in view.subviews {
					sub.layer.opacity = 0.5
				}
				score.removeFromSuperview()
				endScore.isHidden = false
				endScore.isEnabled = true
				endScore.backgroundColor = UIColor.white
				endScore.setTitle(String(scoreCount), for: .normal)
				endScore.setTitleColor(UIColor.darkGray, for: .normal)
				endScore.alpha = 1
				endScore.layer.cornerRadius = 5.0
				endScore.addTarget(self, action: #selector(didTapRestart(_:)), for: .touchUpInside)
				view.addSubview(endScore)
			} else {
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
	}
	
	func didTapRestart(_ button: UIButton) {
		for sub in view.subviews {
			sub.removeFromSuperview()
		}
		inMotion = false
		newGame()
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
		
		newGame()
    }
	
	func newGame() {
		scoreCount = 0
		
		endScore.isHidden = true
		endScore.isEnabled = false
		
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
		let number = Int(arc4random_uniform(8))
		let centerX = Int(UIScreen.main.bounds.size.width) / blockSize * blockSize / 2
		switch (number) {
		case 0: // Send for I
			let grid = ITetrisGrid()
			return TetrisBlockView(color: grid.getColor(), grid: grid, blockSize: blockSize,
			                        startY: grid.startY(), boardCenterX: CGFloat(centerX))
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
		view.addSubview(nextBlock)
	}
	
	func checkRows() {
		var clearedRows = 0
		for row in boardArray.getMinRow() ..< boardArray.numRows() {
			if boardArray.checkRow(row: row) {
				findSubsInRow(row: row)
				clearedRows += 1
			}
		}
		changeScore(lines: clearedRows)
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
	
	// Scoring uses Original Nintendo Scoring System
	func changeScore(lines: Int) {
		switch (lines) {
		case 1:
			scoreCount += 40
		case 2:
			scoreCount += 100
		case 3:
			scoreCount += 300
		case 4:
			scoreCount += 1200
		default:
			scoreCount += 0
		}
		score.text = String(scoreCount)
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
