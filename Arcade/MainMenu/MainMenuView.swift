//
//  MainMenuView.swift
//  Arcade
//
//  Created by Jerry Wang on 11/18/23.
//

import SwiftUI

struct MainMenuView: View {
    @State private var itemWidth = 100.0
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    Color.gray.ignoresSafeArea()
                    
                    ScrollView {
                        Grid() {
                            GridRow {
                                NavigationLink {
                                    MineSweeperView()
                                        .navigationBarBackButtonHidden(true)
                                } label: {
                                    VStack {
//                                        Rectangle()
//                                            .cornerRadius(10.0)
//                                            .foregroundColor(.indigo)
//                                            .frame(width: itemWidth, height: itemWidth)
//
                                        GameBlock(blockSize: $itemWidth, borderSize: 20.0)
                                            .overlay(
                                                Image("mine")
                                                    .resizable()
                                                    .frame(width: itemWidth * (2/3), height: itemWidth * (2/3))
                                            )
                                        
                                        Text("Minesweeper")
                                            .font(.custom("Silkscreen-Regular", size: 20))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        itemWidth = min(geo.size.width / 3.0, geo.size.height / 3.0)
                    }
                }
            }
        }
    }
}

#Preview {
    MainMenuView()
}
