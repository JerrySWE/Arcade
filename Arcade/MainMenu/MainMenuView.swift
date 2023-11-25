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
                    Color.teal.ignoresSafeArea()
                    
                    Image("arcade-2")
//                        .blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                    
                    VStack {

                        ScrollView {
                            Grid() {
                                GridRow {
                                    NavigationLink {
                                        MineSweeperView()
                                            .navigationBarBackButtonHidden(true)
                                    } label: {
                                        VStack {
                                            GameBlock(blockWidth: $itemWidth, blockHeight: $itemWidth, borderSize: 20.0)
                                                .overlay(
                                                    Image("mine")
                                                        .resizable()
                                                        .frame(width: itemWidth, height: itemWidth)
                                                )
                                            
                                            Text("Minesweeper")
                                                .font(.custom("Silkscreen-Bold", size: 20))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }
                        .onAppear {
                            itemWidth = min(geo.size.width / 5.0, geo.size.height / 5.0)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainMenuView()
}
