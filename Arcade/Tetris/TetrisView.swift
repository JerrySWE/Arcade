//
//  TetrisView.swift
//  RetroGameCollection
//
//  Created by Jerry Wang on 11/9/23.
//

import SwiftUI

private enum GameState {
    case playing
    case paused
    case ended
}

struct TetrisView: View {
    @StateObject private var viewModel = TetrisViewModel()
    @State private var currentGameState: GameState = .ended
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.indigo.ignoresSafeArea()
                    
                
                VStack(spacing: 0) {
                    let blockSize = viewModel.getBlockWidth(screenWidth: geo.size.width)
                    
                    ForEach(viewModel.tetrisGrid, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(row) { col in
                                Rectangle()
                                    .frame(width: blockSize, height: blockSize)
                                    .border(.white)
                                    .foregroundColor(.mint)
                            }
                        }
                    }
                }.padding(20)
            }
        }
        .onReceive(timer) { time in
            if currentGameState == .playing {
                print("Hello")
            }
        }
    }
}

struct Block: View {
    @State var blockSize: CGFloat
    
    var body: some View {
        Rectangle()
            .frame(width: blockSize, height: blockSize)
            .border(.white)
            .foregroundColor(.mint)
    }
}

#Preview {
    TetrisView()
}
