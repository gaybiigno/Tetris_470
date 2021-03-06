//
//  TetrisBlock.swift
//  TetrisStarter
//
//  Created by Gaybi on 9/26/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

class TetrisBlockView: UIView {

    let blockColor: UIColor
    var blockModel: TetrisBlockModel
    let blockSize: Int
	var width: Int
	var height: Int
    var animator: UIViewPropertyAnimator!
    var angle = CGFloat(0.0)
    var blockBounds: CGSize
	var boardBounds = CGSize()
	var hasTurned = false
	var isUpsideDown = false
	var hasFinished = false
	var toTravel = CGFloat(0.0)
	var endY = CGFloat(0.0)
	var boardArray: TetrisBoardArray!
	var clock = Timer()
	var isPaused = true
	var endRow = 0
	let maxRows = 20
	let maxCols = 13
	var starting_y: CGFloat = 0
	
	init(color: UIColor, grid: TetrisBlockModel, blockSize: Int, startY: CGFloat, boardCenterX: CGFloat) {
		hasTurned = false
		hasFinished = false
        blockColor = color
        self.blockModel = grid
        self.blockSize = blockSize
        self.width = (blockSize * grid.blocksWide())
        self.height = (blockSize * grid.blocksHeight())
        blockBounds = CGSize(width: CGFloat(width), height: CGFloat(height))
		toTravel = CGFloat(blockSize * 19)
        var x = boardCenterX
		x -= CGFloat(blockSize) / CGFloat(2.0)
		starting_y = startY
        let frame = CGRect(x: x, y: startY, width: CGFloat(width), height: CGFloat(height))
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubBlocksToView(grid: grid, blockSize: blockSize)
		self.endRow = Int((self.center.y + self.toTravel + CGFloat(self.height/2)) / CGFloat(self.blockSize))
		animator = UIViewPropertyAnimator(duration: 6.0, curve: .linear) { [unowned self] in
			self.center.y += self.toTravel
			self.endY = self.center.y
        }
		animator.addCompletion{_ in
			if self.clock.isValid {
				self.clock.invalidate()
			}
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
			var (row, col) = boardArray.getRowCol(point: CGPoint(x: (temp_frame?.origin.x)!, y: (temp_frame?.maxY)!))
			if hasTurned, height != width {
				row += (height - width) / blockSize
			}
			
			if row + 1 < boardArray.getMinRow() {
				animator.startAnimation()
				return
			}
			for col_add in 0 ..<  blockModel.blocksWide() {
				if col + col_add < maxCols {
					var blockRow = blockModel.blocksHeight() - 1
					let blockCol = col_add
						 // Check bottom row
						if row + 1 <= maxRows, (boardArray.hasBlockAt(row: row + 1, column: col + col_add)),
							(blockModel.hasBlockAt(row: blockRow, column: blockCol)) {
								clock.invalidate()
								self.animator.stopAnimation(true)
								self.layer.removeAllAnimations()
								hasFinished = true
								endRow = row + 1
								endDescent()
								return
						} else {
							blockRow = blockModel.blocksHeight() - 2
							// Check middle or top row
							if row < maxRows, (boardArray.hasBlockAt(row: row, column: col + col_add)),  blockModel.blocksHeight() - 2 > 0,(blockModel.hasBlockAt(row: blockRow, column: blockCol)) {
									clock.invalidate()
									self.animator.stopAnimation(true)
									self.layer.removeAllAnimations()
									hasFinished = true
									endRow = row + 1
									endDescent()
									return
							} else {
								// Check top row
								blockRow = 0
								if row - 1 < maxRows, (boardArray.hasBlockAt(row: row - 1, column: col + col_add)), (blockModel.hasBlockAt(row: blockRow, column: blockCol)) {
									clock.invalidate()
									self.animator.stopAnimation(true)
									self.layer.removeAllAnimations()
									hasFinished = true
									endRow = row
									endDescent()
									return
								}
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
	
	func inHorizontalBounds(xoffset: Int, yoffset: Int) -> Bool {
		let temp_frame = self.layer.presentation()?.frame
		let (row, col) = boardArray.getRowCol(point: CGPoint(x: (temp_frame?.origin.x)! +  CGFloat(xoffset), y: (temp_frame?.maxY)! + CGFloat(yoffset)))
		
		if !hasTurned, row + 1 != maxRows{
			for i in 0 ..< blockModel.blocksWide(){
				if boardArray.hasBlockAt(row: row + 1, column: col + i) {
					return false
				}
			}
		}
		return true
	}
	
	func canRotate() -> Bool {
		// Check horizontal boundaries
		if 0.0 > (self.center.x - CGFloat((blockModel.blocksHeight() * 30) / 2)) ||
			boardBounds.width < (self.center.x + CGFloat((blockModel.blocksHeight() * 30) / 2)) {
			return false
		}
		// Check vertical boundaries
		let temp_frame = self.layer.presentation()?.frame
		let centerY = (temp_frame?.minY)! + CGFloat(blockModel.blocksHeight() * 30 / 2)
		if 0.0 > (centerY - CGFloat((blockModel.blocksWide() * 30) / 2)) ||
			boardBounds.height < (centerY + CGFloat((blockModel.blocksWide() * 30) / 2)) {
			return false
		}
		return true
	}
	
	// Checks if block would move outside vertical bounds
	func inSidewaysBounds(offset: Int) -> Bool {
		if 0.0 > (self.center.x - CGFloat((blockModel.blocksWide() * 30) / 2)) + CGFloat(offset) ||
			boardBounds.width < (self.center.x + CGFloat((blockModel.blocksWide() * 30) / 2)) + CGFloat(offset) {
			return false
		}
		return true
	}
	
	// Moves tetris blocks right and left
	func moveSideWays(offset: Int) {
		if animator.state == .active {
			animator.pauseAnimation()
			if inSidewaysBounds(offset: offset) { // If movement is valid
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
		let rotation = UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut) { [unowned self, angle] in
			self.transform = CGAffineTransform(rotationAngle: angle)
		}
		
		// Snap to vertical gridline
		rotation.addCompletion { [unowned self] (_) in
			let aPointTranslated = self.superview!.convert(aPoint, from: self)
			let diffX = Int(abs(aPointInSuperView.x - aPointTranslated.x)) % self.blockSize
			UIView.animate(withDuration: 0.1, animations: {
				if self.hasTurned {
					self.center = CGPoint(x: self.center.x - CGFloat(diffX), y: self.center.y)
					self.isUpsideDown = !self.isUpsideDown
				} else {
					self.center = CGPoint(x: self.center.x + CGFloat(diffX), y: self.center.y)
				}
				self.hasTurned = !self.hasTurned
			})
			self.animator.startAnimation()
		}
		rotation.startAnimation()
	}
	
	// Rotates tetris blocks clockwise
    func rotateClockWise() {
        if animator.state != .active {
            return
        }
        animator.pauseAnimation()
		var offset: Int
		if hasTurned {
			offset = (height >  width) ? (width - height) : (height - width)
		} else {
			offset = (height >  width) ? (height - width) : (width - height)
		}
		let sideway = height - width
		if inHorizontalBounds(xoffset: offset, yoffset: offset), inSidewaysBounds(offset: sideway), canRotate() {
			rotateBlock(rotationAngle: CGFloat.pi / 2.0)
			blockModel.didRotateClockwise()
		} else {
			animator.startAnimation()
		}
    }
	
	
	// Adds final placement of tetris blocks to board
	func endDescent() {
		if animator.state == .active {
			animator.pauseAnimation()
			self.animator.stopAnimation(true)
			self.layer.removeAllAnimations()
			if clock.isValid {
				clock.invalidate()
			}
		}
		let temp_frame = self.layer.presentation()?.frame
		var row = endRow - (height / blockSize)
		let col = Int((temp_frame?.origin.x)! / CGFloat(blockSize))
		endRow = 0
		
		if !hasTurned, height == blockSize {
			if row == maxRows - 1, !boardArray.hasBlockBetween(row: 20, firstCol: col, secondCol: col + 3) {
				row += 1
			}
			self.center.y = CGFloat(row * blockSize) - CGFloat(CGFloat(blockSize) * 0.5) - CGFloat(blockSize)
			
			for i in 0 ..< blockModel.blocksHeight() {
				for j in 0 ..< blockModel.blocksWide() {
					if blockModel.hasBlockAt(row: i, column: j), row + i <= maxRows, col + j <= maxCols {
						if boardArray.hasBlockAt(row: row + i, column: col + j) == false {
							boardArray.changeValue(row: row + i, column: col + j)
						}
					}
				}
			}
		} else {
			if hasTurned, blockModel.blocksHeight() % 2 != 0 {
				row -= 1
				let diff = (self.width - self.height) / 2
				self.center.y = CGFloat(row * blockSize) - CGFloat(diff)
				for i in 0 ..< blockModel.blocksHeight() {
					for j in 0 ..< blockModel.blocksWide() {
						if blockModel.hasBlockAt(row: i, column: j), row + i <= maxRows, col + j <= maxCols {
							if boardArray.hasBlockAt(row: row + i, column: col + j) == false {
								boardArray.changeValue(row: row + i, column: col + j)
							}
						}
					}
				}
			} else {
				if height == blockSize {
					row -= 1
					let diff = (self.width - self.height) / 2
					self.center.y = CGFloat(row * blockSize) - CGFloat(diff) - CGFloat(blockSize / 2)
					row -= 2
				} else {
					self.center.y = CGFloat(row * blockSize) - CGFloat(blockSize)
				}
				for i in 0 ..< blockModel.blocksHeight() {
					for j in 0 ..< blockModel.blocksWide() {
						if blockModel.hasBlockAt(row: i, column: j), row + i <= maxRows, col + j <= maxCols {
							if boardArray.hasBlockAt(row: row + i, column: col + j) == false {
								boardArray.changeValue(row: row + i, column: col + j)
							}
						}
					}
				}
			}
		}
	}
	
	// Removes all block in given row
	func removeRowFromView(row: Int) {
		if hasTurned {
			for sub in self.subviews {
				if sub.tag == 1, Int(sub.frame.minX) == (row * blockSize) {
					sub.removeFromSuperview()
				}
			}
		} else {
			if isUpsideDown {
				for sub in self.subviews {
					if sub.tag == 1, Int(sub.frame.maxY) == (row * blockSize) {
						sub.removeFromSuperview()
					}
				}
			} else {
				for sub in self.subviews {
					if sub.tag == 1, Int(sub.frame.minY) == (row * blockSize) {
						sub.removeFromSuperview()
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
					bView.tag = 1 	// Identifier that it is a drawn block!
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
	
	func reset() {
		for sub in subviews {
			sub.removeFromSuperview()
		}
		toTravel = CGFloat(0.0)
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
