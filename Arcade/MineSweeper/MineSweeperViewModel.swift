//
//  MineSweeperViewModel.swift
//  RetroGameCollection
//
//  Created by Jerry Wang on 11/17/23.
//

import Foundation

extension MineSweeperView {
    
    struct FieldBlock {
        var isMine = false
        var isRevealed = false
        var isFlagged = false
    }
    
    @MainActor class MineSweeperViewModel: ObservableObject {
        @Published var rowNum = 15
        @Published var colNum = 10
        @Published private(set) var mineField: [[FieldBlock]]
        @Published var blockSize = 10.0
        
        init () {
            mineField = []
            
            for _ in 0 ..< rowNum {
                var currentRow = [FieldBlock]()
                
                for _ in 0 ..< colNum {
                    currentRow.append(FieldBlock())
                }
                
                mineField.append(currentRow)
            }
        }
        
        func initiateGame(row: Int, col: Int) {
            
        }
        
        func toggleFieldBlockFlag(row: Int, col: Int) {
            mineField[row][col].isFlagged.toggle()
        }
        
        func setBlockSize(screenSize: CGSize) {
            blockSize = min(screenSize.width / CGFloat(colNum), screenSize.height / CGFloat(rowNum))
        }
    }
}
