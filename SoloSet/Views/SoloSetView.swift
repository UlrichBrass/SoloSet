//
//  SoloSet.swift
//  SoloSet
//
//  Created by Ulrich Braß on 08.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

struct SoloSetView: View {
    @EnvironmentObject var viewModel : SoloSetViewModel
    
    var body: some View {
        VStack {
            // GridView A view that arranges its children items in a grid
            GridView(viewModel.cards){ card in     // The 'in' keyword indicates that the definition of the closure’s parameters and return type
                                                   // has finished, and the body of the closure is about to begin
                CardView(card : card)
                    .onTapGesture { // card was chosen
                        withAnimation(.easeInOut(duration: 0.4)){
                            self.viewModel.chooseCard(card: card) // express intent
                        }
                    }//TapGesture: choose a card
                    .gesture(
                        MagnificationGesture()
                            .onEnded { _ in
                                self.viewModel.cheat()
                        }
                    ) // Cheating ...
                    .gesture(
                        DragGesture(minimumDistance: 200)
                            .onEnded { _ in
                                // explicit animation for card redistribution effect
                                withAnimation(.easeInOut(duration: 1.0)){
                                    self.viewModel.newGame()
                                }
                        }
                    ) // start new game
                    .gesture(
                        LongPressGesture(minimumDuration: 0.8)
                            .onEnded { _ in
                                withAnimation(.easeInOut(duration: 1.0)){
                                    self.viewModel.addCards()
                                }
                        }
                    ) // deal three new cards
                    
            } // Grid
            // The .onAppear modifier will excecuted, when the grid first appears
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)){
                                self.viewModel.newGame()
                }
            }//Appear
            HStack {
                Text ("Punkte: " + String(viewModel.gameScore))
                Spacer()
                Text(viewModel.message)
                Spacer()
                Text ("Sets: " + String(viewModel.noOfSetsFound))
            }
            .font(.headline)
        }//VStack
        .padding(5)
        
    }
}

struct SoloSet_Previews: PreviewProvider {
    static var previews: some View {
        SoloSetView().environmentObject(SoloSetViewModel())
    }
}
