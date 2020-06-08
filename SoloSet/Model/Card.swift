//
//  Card.swift
//  SoloSet
//
//  Created by Ulrich Braß on 08.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation


// The cards vary in four features across three possibilities for each kind of feature:
// - number of shapes (one, two, or three),
// - shape (diamond, squiggle, oval),
// - shading (solid, striped, or open),
// - and color (red, green, or purple).
// Each possible combination of features (e.g. a card with
// [three] [striped] [green] [diamonds]) appears as a card precisely once in the deck.

// data structure for cards
struct Card : Identifiable{
    
    // make Card a struct holding  the value of an entity with stable identity.
    // We cannot make Card to implement Equatable, because then CardView will not update views as long as id remains the same!!!
    
    // The following properties are set with init, and cannot change
    var id : UUID
    var cardFeatureNumber : Constants.numberFeature
    var cardFeatureShape : Constants.shapeFeature
    var cardFeatureShading : Constants.shadingFeature
    var cardFeatureColor : Constants.colorFeature
    
    struct Constants {
        
        static let noOfCardsInDeck : Int = 81
        static let noOfCardsAtStart : Int = 12
        static let noOfCardsInGame : Int = 24
        static let noOfFeaturesPerCard : Int = 4
        static let noOfPossibilitiesPerFeature : Int = 3
       
        
        enum numberFeature : Int, CaseIterable {
            case one = 1
            case two = 2
            case three = 3
            var value : Int {
                return self.rawValue
            }
           
        }
        enum shapeFeature : CaseIterable {
            case diamond
            case squiggle
            case oval
            
        }
        enum shadingFeature : CaseIterable{
            case solid
            case striped
            case open
           
        }
        enum colorFeature : CaseIterable{
            case  red
            case  green
            case  purple
           
        }
    }

    // The following properties define the state of a card and will change over time
    var isPartOfSet : Bool
    var isChosen : Bool
    var isMisMatch : Bool
    var isRemoved : Bool
    //

    init (number : Constants.numberFeature, shape : Constants.shapeFeature,
                shading :  Constants.shadingFeature,  color : Constants.colorFeature) {
        // self create identifier
        self.id = UUID()
        self.isPartOfSet = false
        self.isChosen = false
        self.isMisMatch = false
        self.isRemoved = false
        self.cardFeatureNumber = number
        self.cardFeatureShape = shape
        self.cardFeatureShading = shading
        self.cardFeatureColor = color
    }
    
} //  Card
