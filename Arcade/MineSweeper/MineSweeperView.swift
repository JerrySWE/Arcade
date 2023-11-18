//
//  MineSweeperView.swift
//  RetroGameCollection
//
//  Created by Jerry Wang on 11/17/23.
//

import SwiftUI

struct MineSweeperView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = MineSweeperViewModel()
    @State private var didHold = false
    
    private let flagActionFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        GeometryReader { geo in
            ZStack (alignment: .topLeading) {
                Color.gray.ignoresSafeArea()
                
                
                
                VStack (alignment: .leading, spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrowshape.backward.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding([.leading], 5)
                            .foregroundColor(.black)
                    }
                    
                    Text("Mine Left")
                        .font(.custom("Silkscreen-Regular", size: 46))
                        .padding(20)
                    
                    ForEach(0 ..< viewModel.rowNum, id: \.self) { row in
                        HStack (spacing: 0) {
                            ForEach(0 ..< viewModel.colNum, id: \.self) { col in
                                let block = viewModel.mineField[row][col]
                                
                                Button {
                                    if !didHold {
                                        
                                    }
                                    
                                    didHold = false
                                } label: {
                                    GameBlock(blockSize: $viewModel.blockSize, borderSize: 10.0)
                                        .overlay(
                                            Image(systemName: "flag.fill")
                                                .foregroundColor(.red)
                                                .opacity(block.isFlagged ? 1 : 0)
                                        )
                                }
                                .simultaneousGesture(
                                    LongPressGesture().onEnded { _ in
                                        flagActionFeedback.impactOccurred()
                                        didHold = true
                                        
                                        viewModel.toggleFieldBlockFlag(row: row, col: col)
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.setBlockSize(screenSize: geo.size)
            }
        }
    }
}

#Preview {
    MineSweeperView()
}
