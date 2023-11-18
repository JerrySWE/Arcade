//
//  MineSweeperView.swift
//  RetroGameCollection
//
//  Created by Jerry Wang on 11/17/23.
//

import SwiftUI

struct TopLeftTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        return path
    }
}

struct MineSweeperView: View {
    @StateObject private var viewModel = MineSweeperViewModel()
    
    @State private var didHold = false
    
    private let flagActionFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.gray.ignoresSafeArea()
                
                VStack (spacing: 0) {
                    Text("Mine Left")
                        .font(.custom("Silkscreen-Regular", size: 46))
                        .padding(20)
                    
                    ForEach(0 ..< viewModel.rowNum, id: \.self) { row in
                        HStack (spacing: 0) {
                            ForEach(0 ..< viewModel.colNum, id: \.self) { col in
                                let block = viewModel.mineField[row][col]
                                
                                Button {
                                    if didHold {
                                    } else {
                                        
                                    }
                                    
                                    didHold = false
                                } label: {
                                    Rectangle()
                                        .frame(width: viewModel.blockSize, height: viewModel.blockSize)
                                        .foregroundColor(.gray)
                                        .border(.white)
                                        .overlay(
                                            TopLeftTriangle()
                                                .fill(.white)
                                        )
                                        .overlay(
                                            Rectangle()
                                                .foregroundColor(Color("MineBody"))
                                                .frame(width: viewModel.blockSize - 10, height: viewModel.blockSize - 10)
                                        )
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
