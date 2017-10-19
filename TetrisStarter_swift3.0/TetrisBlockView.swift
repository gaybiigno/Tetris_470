//
//  TetrisBlock.swift
//  TetrisStarter
//
//  Created by AAK on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisBlockView: UIView {

    let blockColor: UIColor
    var blockModel: TetrisBlockModel
    let blockSize: Int
	let width: Int
	let height: Int
    var animator: UIViewPropertyAnimator!
    var angle = CGFloat(0.0)
    var blockBounds: CGSize
	var boardBounds = CGSize()
	var hasTurned = false
	var hasFinished = false
	var toTravel = CGFloat(0.0)
	var boardArray: TetrisBoardArray!
	var clock = Timer()
	var isPaused = true
	var endRow = 0
	let maxRows = 24
	let maxCols = 13
	
	init(color: UIColor, grid: TetrisBlockModel, blockSize: Int, startY: CGFloat, boardCenterX: CGFloat) {
		hasFinished = false
        blockColor = color
        blockModel = grid
        self.blockSize = blockSize
        width = (blockSize * grid.blocksWide())
        height = (blockSize * grid.blocksHeight())
        blockBounds = CGSize(width: CGFloat(width), height: CGFloat(height))
		toTravel = CGFloat(blockSize * 20)
        var x = boardCenterX
		x -= CGFloat(blockSize) / CGFloat(2.0)
        let frame = CGRect(x: x, y: startY, width: CGFloat(width), height: CGFloat(height))
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubBlocksToView(grid: grid, blockSize: blockSize)
		animator = UIViewPropertyAnimator(duration: 4.0, curve: .linear) { [unowned self] in
			self.center.y += self.toTravel
        }
		animator.addCompletion{_ in
			self.endRow = Int((self.center.y + CGFloat(self.height/2)) / CGFloat(self.blockSize))
			self.endDescent()
			self.hasFinished = true
		}
    }
	
	func isOver() -> Bool {
		return hasFinished
	}
	
	// Initializes timer 0.5
	func startTimer() -> Timer {
		let timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
		isPaused = false
		return timer
	}
	
	func updateTimer(_ sender: Timer) {
		animator.pauseAnimation()
		if !hasFinished {
			let temp_frame = self.layer.presentation()?.frame
			let (row, col) = boardArray.getRowCol(point: CGPoint(x: (temp_frame?.origin.x)!, y: (temp_frame?.maxY)!))
				let bottom = blockModel.getEdge(name: Edges.bottom)
			
				for i in 0 ..< bottom.count {
					if row + 1 < maxRows && col + i < maxCols {
						if (boardArray.hasBlockAt(row: row + 1, column: col + i)) {
							let blockRow = Int(((temp_frame?.maxY)! - (temp_frame?.origin.y)!) / CGFloat(height))
							let blockCol = i
							print("Found block@ \(row + 1), \(col + i); block is \(blockRow), \(blockCol)")
							if (blockModel.hasBlockAt(row: blockRow, column: blockCol)) {
								self.animator.stopAnimation(true)
								self.layer.removeAllAnimations()
								hasFinished = true
								endRow = row + 1
								endDescent()
								return
							}
						}
					}
			}
			if !hasFinished {
				self.animator.startAnimation()
			}
		}
	}
	
	func pauseResume() {
		if isPaused {
			clock = startTimer()
		} else {
			clock.invalidate()
		}
		isPaused = !isPaused
	}

	func getBoardArray(array: TetrisBoardArray) {
		boardArray = array
		boardArray.printArray()
	}
	
	func setBoardBounds(boardSize: CGSize){
		boardBounds = boardSize
	}

    func startDescent() {
        animator.startAnimation()
		clock = startTimer()
        //blockModel.printEdges()
    }
    
    func pauseAnimation() {
        if animator.state == .active {
            animator.pauseAnimation()
			if clock.isValid {
				pauseResume()
			}
        }
    }
    
    func startAnimation() {
        if animator.state == .active {
            animator.startAnimation()
			pauseResume()
        }
    }
	
	func inVerticalBounds(offset: Int) -> Bool {
		if 0.0 > (self.center.y - (blockBounds.height/2)) - CGFloat(offset) ||
			boardBounds.height < (self.center.y + (blockBounds.height/2)) + CGFloat(offset) {
			return false
		}
		return true
	}
	
	// Checks if block would move outside vertical bounds
	func inSidewaysBounds(offset: Int) -> Bool {
		if 0.0 > (self.center.x - (blockBounds.width/2)) + CGFloat(offset) ||
			boardBounds.width < (self.center.x + (blockBounds.width/2)) + CGFloat(offset) {
			return false
		}
		return true
	}
    
	func moveSideWays(offset: Int) {
		if animator.state == .active {
			animator.pauseAnimation()
			if inSidewaysBounds(offset: offset) {
				UIView.animate(withDuration: 0.0, animations: { [unowned self, offset] in
					self.center.x += CGFloat(offset)
					}, completion: { [unowned self] (_) in
						self.animator.startAnimation()
				})
			}
		}
	}
    
    func printEdgeValues(edge: Edges) {
        let bottom = blockModel.edgeAttributes(edge: edge)
        print(bottom.direction)
        print(bottom.edgeOffsets())
    }
	
    func moveRight() {
        moveSideWays(offset: blockSize)
    }
    
    func moveLeft() {
        moveSideWays(offset: -blockSize)
    }
    
	func rotateBlock(rotationAngle: CGFloat) {
		animator.pauseAnimation()
		
		let aPoint = CGPoint(x: 0.0, y: 0.0)
		let aPointInSuperView = superview!.convert(aPoint, from: self)
		
		// Set up a new animation for the purpose of rotating the block.
		angle += rotationAngle
		let rotation = UIViewPropertyAnimator(duration: 0.0, curve: .easeInOut) { [unowned self, angle] in
			self.transform = CGAffineTransform(rotationAngle: angle)
		}
		
		// Once the rotation is complete, we will have to make sure that the block is aligned on the edge
		// of some vertical gridline. The gridlines are blockSize apart and logically divide the board.
		rotation.addCompletion { [unowned self] (_) in
			let aPointTranslated = self.superview!.convert(aPoint, from: self)
			let diffX = Int(abs(aPointInSuperView.x - aPointTranslated.x)) % self.blockSize
			
			UIView.animate(withDuration: 0.0, animations: {
				if self.hasTurned {
					self.center = CGPoint(x: self.center.x - CGFloat(diffX), y: self.center.y)
				} else {
					self.center = CGPoint(x: self.center.x + CGFloat(diffX), y: self.center.y)
				}
				self.hasTurned = !self.hasTurned
			})
			self.animator.startAnimation()
		}
		rotation.startAnimation()
		
	}
    
    func rotateClockWise() {
		print("START CW ROTATE")
        if animator.state != .active {
            return
        }
        animator.pauseAnimation()
        rotateBlock(rotationAngle: CGFloat.pi / 2.0)
        blockModel.didRotateClockwise()
        printEdgeValues(edge: Edges.bottom)
		print("END CW ROTATE")
    }
	
	
	// Adds final placement of block to board's array
	func endDescent() {
		if animator.state == .active {
			animator.pauseAnimation()
			self.animator.stopAnimation(true)
			self.layer.removeAllAnimations()
		}
		
		let temp_frame = self.layer.presentation()?.frame
		let row = endRow - (height / blockSize)
		let col = Int((temp_frame?.origin.x)! / CGFloat(blockSize))
		endRow = 0
		self.center.y = CGFloat(row * blockSize) // - (height / 2))
		
		for i in 0 ..< blockModel.blocksHeight() {
			for j in 0 ..< blockModel.blocksWide() {
				if blockModel.hasBlockAt(row: i, column: j) {
					if !boardArray.hasBlockAt(row: row + i, column: col + j) {
						boardArray.changeValue(row: row + i, column: col + j)
					}
				}
			}
		}
		
	}
	
	// Draws the blocks
    func addSubBlocksToView(grid: TetrisBlockModel, blockSize: Int) {
        var topLeftY = 0
        for row in 0 ..< grid.blocksHeight() {
            var topLeftX = 0
            for column in 0 ..< grid.blocksWide() {
                let bView = UIView(frame: CGRect(x: topLeftX, y: topLeftY, width: blockSize, height: blockSize))
                addSubview(bView)

                if grid.hasBlockAt(row: row, column: column) {
                    bView.backgroundColor = blockColor
					bView.layer.borderWidth = 0.5
					bView.layer.borderColor = (UIColor.white.cgColor)
                } else {
                    bView.backgroundColor = UIColor.clear 
                }
                topLeftX += blockSize
            }
            topLeftY += blockSize
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
