//
//  MineSweeperView.swift
//  RetroGameCollection
//
//  Created by Jerry Wang on 11/17/23.
//

import AudioToolbox
import SwiftUI

struct MineSweeperView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = MineSweeperViewModel()
    @State private var didHold = false
    
    private let buttonHapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.minebody.ignoresSafeArea()
                
                VStack (spacing: 0) {
                    HStack {
                        Button {
                            buttonHapticFeedback.impactOccurred()
                            dismiss()
                        } label: {
                            Image("left-arrow")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("\(viewModel.getTime())")
                            .font(.custom("Silkscreen-Regular", size: 64))
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button {
                            buttonHapticFeedback.impactOccurred()
                            viewModel.resetGame()
                        } label: {
                            Image("reload")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                    
                    ForEach(0 ..< viewModel.rowNum, id: \.self) { row in
                        HStack (spacing: 0) {
                            ForEach(0 ..< viewModel.colNum, id: \.self) { col in
                                let block = viewModel.mineField[row][col]
                                
                                if block.isRevealed {
                                    Rectangle()
                                        .frame(width: viewModel.blockSize, height: viewModel.blockSize)
                                        .foregroundColor(.minebody)
                                        .overlay(
                                            Text("\(block.neighborMineCount)")
                                                .font(.custom("Silkscreen-Regular", size: 16))
                                                .opacity(block.neighborMineCount == 0 ? 0 : 1)
                                        )
                                        .overlay(
                                            Image("mine")
                                                .resizable()
                                                .opacity(viewModel.mineField[row][col].isMine ? 1 : 0)
                                        )
                                } else {
                                    Button {
                                        if !didHold {
                                            viewModel.exploreBlock(row: row, col: col)
                                        }
                                        
                                        didHold = false
                                        buttonHapticFeedback.impactOccurred()
                                    } label: {
                                        GameBlock(blockWidth: $viewModel.blockSize, blockHeight: $viewModel.blockSize, borderSize: 10.0)
                                            .overlay(
                                                Image("red-flag")
                                                    .resizable()
                                                    .frame(width: viewModel.blockSize / 2, height: viewModel.blockSize / 2)
                                                    .opacity(block.isFlagged ? 1 : 0)
                                            )
                                    }
                                    .simultaneousGesture(
                                        LongPressGesture(minimumDuration: 0.1).onEnded { _ in
                                            buttonHapticFeedback.impactOccurred()
                                            didHold = true
                                            
                                            viewModel.toggleFieldBlockFlag(row: row, col: col)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                
                Text("You win!")
                    .font(.custom("Silkscreen-Regular", size: 32))
                    .foregroundColor(.orange)
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .opacity(viewModel.gameState == .won ? 1 : 0)
            }
            .onAppear {
                viewModel.setBlockSize(screenSize: geo.size)
            }
            .onReceive(timer) { _ in
                viewModel.timePassed()
            }
            .onChange(of: viewModel.gameState) {
                if viewModel.gameState == .lost {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//                    explosionFeedback.impactOccurred(intensity: .infinity)
                }
            }
        }
    }
}

#Preview {
    MineSweeperView()
}
