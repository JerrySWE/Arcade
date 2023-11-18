//
//  TetrisViewModel.swift
//  RetroGameCollection
//
//  The entire tetris board
//
//  Created by Jerry Wang on 11/9/23.
//

import Foundation

extension TetrisView {
    @MainActor class TetrisViewModel: ObservableObject {
        @Published var rowNum = 20
        @Published var colNum = 10
        @Published var tetrisGrid: [[TetrisBlock]]
        
        private let padding = 5.0
        
        struct TetrisBlock: Hashable, Identifiable {
            let id = UUID()
            let row: Int
            let col: Int
            let filled: Bool
        }
        
        init() {
            tetrisGrid = []
            for row in 0 ..< rowNum {
                var currentRow = [TetrisBlock]()
                for col in 0 ..< colNum {
                    currentRow.append(TetrisBlock(row: row, col: col, filled: false))
                }
                tetrisGrid.append(currentRow)
            }
        }
        
        func getBlockWidth(screenWidth: CGFloat) -> CGFloat {
            let colFloat = CGFloat(colNum)
            return (screenWidth - colFloat * padding) / colFloat
        }
    }
}
