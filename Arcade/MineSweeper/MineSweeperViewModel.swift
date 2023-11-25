//
//  MineSweeperViewModel.swift
//
//  
//
//  Created by Jerry Wang on 11/17/23.
//

import Foundation
import SwiftUI

extension MineSweeperView {
    
    struct FieldBlock {
        var isMine = false
        var isRevealed = false
        var isFlagged = false
        var neighborMineCount = 0
    }
    
    enum GameState {
        case notStarted
        case playing
        case lost
        case won
    }
    
    @MainActor class MineSweeperViewModel: ObservableObject {
        @Published private(set) var mineField = [[FieldBlock]]()
        @Published var gameState: GameState = .notStarted
        @Published var rowNum = 17
        @Published var colNum = 10
        @Published var blockSize = 10.0
        @Published var mineCount = 20
        @Published var gameTime = 0
        
        private var mineFlagged = 0
        
        init () {
            resetGame()
        }
        
        /**
         Reset Game to a fresh state
        */
        func resetGame() {
            mineField = []
            
            for _ in 0 ..< rowNum {
                var currentRow = [FieldBlock]()
                
                for _ in 0 ..< colNum {
                    currentRow.append(FieldBlock())
                }
                
                mineField.append(currentRow)
            }
            
            gameState = .notStarted
            gameTime = 0
        }
        
        /**
         Add a mine at the provided location. Update the neighbors' mine count
         - Parameters:
           - row: The row number of where mine should be added
           - col: The column number of where mine should be added
         - Precondition: The game must have not started yet
        */
        private func addMine(row: Int, col: Int) {
            guard gameState == .notStarted else { return }
            
            mineField[row][col].isMine = true
            
            for dRow in -1 ... 1 {
                for dCol in -1 ... 1 {
                    if (dRow != 0 || dCol != 0) {
                        let adjacentRow = row + dRow
                        let adjacentCol = col + dCol
                        
                        if isOnGrid(row: adjacentRow, col: adjacentCol) {
                            mineField[adjacentRow][adjacentCol].neighborMineCount += 1
                        }
                    }
                }
            }
        }
        
        /**
         Add mines to the board at random locations after the player made their first tap to a new game.
         It will not add mines to the vicinity of the first tap so that the first tap will be guaranteed to explore a large area instead of
         just reveal one single block.
         - Parameters:
           - row: The row number of the block that was first tapped
           - col: The column number of the block that was first tapped
         - Precondition: The game must have not started yet
        */
        func addMines(row: Int, col: Int) {
            guard gameState == .notStarted else { return }
            
            var mineAdded = 0
            
            while (mineAdded < mineCount) {
                let mineRow = Int.random(in: 0 ..< rowNum)
                let mineCol = Int.random(in: 0 ..< colNum)
                
                if (abs(mineRow - row) > 1 && abs(mineCol - col) > 1) && !mineField[mineRow][mineCol].isMine {
                    addMine(row: mineRow, col: mineCol)
                    mineAdded += 1
                }
            }
            
            gameState = .playing
            mineFlagged = 0
        }
        
        func timePassed() {
            if gameState == .playing {
                gameTime += 1
            }
        }
        
        func getTime() -> String {
            let gameMinute = gameTime / 60
            let gameSecond = gameTime % 60
            
            var minute = String(gameMinute)
            if gameMinute < 10 {
                minute = "0" + minute
            }
            
            var second = String(gameSecond)
            if gameSecond < 10 {
                second = "0" + second
            }
            
            return minute + ":" + second
        }
        
        func isOnGrid(row: Int, col: Int) -> Bool {
            return row >= 0 && row < rowNum && col >= 0 && col < colNum
        }
        
        func canFloodFill(row: Int, col: Int) -> Bool {
            return isOnGrid(row: row, col: col) && !mineField[row][col].isRevealed
        }
        
        func revealAllMines() {
            for row in 0 ..< rowNum {
                for col in 0 ..< colNum {
                    if mineField[row][col].isMine {
                        mineField[row][col].isRevealed = true
                    }
                }
            }
        }

        func exploreBlock(row: Int, col: Int) {
            guard gameState == .notStarted || gameState == .playing else { return }
            
            if mineField[row][col].isMine {
                gameState = .lost
                revealAllMines()
                return
            }
            
            if gameState == .notStarted {
                addMines(row: row, col: col)
            }
            
            var exploreQueue = [(Int, Int)]()
            
            exploreQueue.append((row, col))
            
            while (!exploreQueue.isEmpty) {
                let (currentRow, currentCol) = exploreQueue.removeFirst()
                
                if !mineField[currentRow][currentCol].isRevealed {
                    mineField[currentRow][currentCol].isRevealed = true
                    
                    if mineField[currentRow][currentCol].neighborMineCount == 0 {
                        for dRow in -1 ... 1 {
                            for dCol in -1 ... 1 {
                                if (dRow != 0 || dCol != 0) {
                                    let adjacentRow = currentRow + dRow
                                    let adjacentCol = currentCol + dCol
                                    
                                    if canFloodFill(row: adjacentRow, col: adjacentCol) {
                                        exploreQueue.append((adjacentRow, adjacentCol))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        func toggleFieldBlockFlag(row: Int, col: Int) {
            guard gameState == .playing else { return }
            
            if mineField[row][col].isMine {
                if mineField[row][col].isFlagged {
                    mineFlagged -= 1
                } else {
                    mineFlagged += 1
                }
            }
            
            mineField[row][col].isFlagged.toggle()
            
            if mineFlagged == mineCount {
                withAnimation {
                    gameState = .won
                }
            }
        }
        
        func setBlockSize(screenSize: CGSize) {
            blockSize = min(screenSize.width / CGFloat(colNum), screenSize.height / CGFloat(rowNum))
        }
    }
}
