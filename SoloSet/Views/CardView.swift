//
//  ContentView.swift
//  SoloSet
//
//  Created by Ulrich Braß on 05.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// A view of a single card
struct CardView: View {
    var card : Card
    private let radius : CGFloat = 10.0
    private let lineWidth : CGFloat = 3.0
    private let frameWidth : CGFloat = 1.0
    private let cardColor = Color.white
    private let frameColor = Color.gray
   
    // mapping of color feature to displayable color
    var colorToUIColor: [Card.Constants.colorFeature : Color]{
          get {
               return [
                     .red : Color.red,
                     .green : Color.green,
                     .purple : Color.purple
                 ]
          }
    }
    
    // The card setup starts here with reading the size of the card ...
    var body: some View {
        // the space for one card
        GeometryReader{ geometry in
            self.body(for : geometry.size, of : self.card)
        } //Geometry Reader
    } // Body
   
    //... and then bulding up frame and content
    private func body (for size : CGSize, of card : Card) -> some View {
        ZStack{
            // The frame
            RoundedRectangle(cornerRadius: radius).fill(cardColor)
            RoundedRectangle(cornerRadius: radius).stroke(lineWidth: frameWidth)
                .foregroundColor(frameColor)
            
            // The symbols on the card
            VStack{
                symbolSpacer(for : size)
                ForEach(0..<card.cardFeatureNumber.value){ _ in
                    self.shape( of : card, with : self.lineWidth)
                        .setSymbol(size : size, color : self.colorToUIColor[card.cardFeatureColor]!)
                     self.symbolSpacer(for : size)
                }
            } // VStack
        }//ZStack
    }
    // build the shape of a symbol, given its shading
    @ViewBuilder
    private func shape  (of card : Card, with lineWidth : CGFloat) -> some View {
        if card.cardFeatureShape == Card.Constants.shapeFeature.diamond {
            if card.cardFeatureShading == Card.Constants.shadingFeature.open {
                DiamondLayout().stroke(lineWidth : lineWidth)
            } else if card.cardFeatureShading == Card.Constants.shadingFeature.solid{
                DiamondLayout().fill()
            } else {
                DiamondLayout().stripe(lineWidth : lineWidth)
            }
        } else if card.cardFeatureShape == Card.Constants.shapeFeature.squiggle{
            if card.cardFeatureShading == Card.Constants.shadingFeature.open {
                SquiggleLayout().stroke(lineWidth : lineWidth)
            } else if card.cardFeatureShading == Card.Constants.shadingFeature.solid{
                SquiggleLayout().fill()
            } else {
                SquiggleLayout().stripe(lineWidth : lineWidth)
            }
        } else if card.cardFeatureShape == Card.Constants.shapeFeature.oval {
            if card.cardFeatureShading == Card.Constants.shadingFeature.open {
                OvalLayout().stroke(lineWidth : lineWidth)
            } else if card.cardFeatureShading == Card.Constants.shadingFeature.solid{
                OvalLayout().fill()
            } else {
                OvalLayout().stripe(lineWidth : lineWidth)
            }
        }
    }
    
        
    // equal vertical spacing between card symbols
    private func symbolSpacer(for size : CGSize) -> some View {
        let spacingHeightToCardHeight = CGFloat( 0.5 / 6.0)
        return Spacer(minLength : size.height * spacingHeightToCardHeight)
    }
} // CardView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card : Card(number : Card.Constants.numberFeature.one,
                             shape : Card.Constants.shapeFeature.diamond,
                             shading : Card.Constants.shadingFeature.solid,
                             color : Card.Constants.colorFeature.red))
            .padding()
            .aspectRatio(2/3, contentMode: .fit)
    }
}
