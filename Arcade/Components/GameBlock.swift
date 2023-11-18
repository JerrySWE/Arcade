//
//  GameBlock.swift
//  Arcade
//
//  Created by Jerry Wang on 11/18/23.
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

struct GameBlock: View {
    @Binding var blockSize: Double
    @State var borderSize: Double
    
    var body: some View {
        Rectangle()
            .frame(width: blockSize, height: blockSize)
            .foregroundColor(.gray)
            .border(.white)
            .overlay(
                TopLeftTriangle()
                    .fill(.white)
            )
            .overlay(
                Rectangle()
                    .foregroundColor(Color("MineBody"))
                    .frame(width: blockSize - borderSize, height: blockSize - borderSize)
            )
    }
}

#Preview {
    GameBlock(blockSize: .constant(50.0), borderSize: 10.0)
}
