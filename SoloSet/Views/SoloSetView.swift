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
                    .onTapGesture { // will call closure after recognizing a tap gesture.
                    // Explicit animations are almost always wrapped around calls to ViewModel Intent functions
                        withAnimation(.linear(duration : 0.75)){
                             self.viewModel.chooseCard(card: card) // express intent
                         }
                        //print("Card chosen : " + card.id.uuidString)
                    }//TapGesture
            } // Grid
            HStack {
                Text ("Punkte: " + String(viewModel.gameScore))
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
