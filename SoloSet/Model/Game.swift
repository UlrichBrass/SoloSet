//
//  Game.swift
//  SoloSet
//
//  Created by Ulrich Braß on 08.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation

//
// Model Module
//
// Set (stylized as SET) is a real-time card game designed by Marsha Falco
// in 1974 and published by Set Enterprises in 1991.
//
struct Game {
    
// Properties:
    // The hidden card deck
    private(set) var cardDeck = [Card]()
    // The open cards
    private(set) var cards = [Card]()
    
    // Scoring
    private(set) var gameScore : Int
    private(set) var noOfSetsFound : Int
    struct Constants {
        static let scoreSet : Int = 3
        static let scoreMismatch : Int = -4
        static let scoreDeselection : Int = -1
        static let scoreFined : Int = -8
    }
    // Find all cards chosen by the user
    private var chosenCards : [Card]? {
        // Find chosen cards (if any)
        get {
            // filter uses a closure that takes an element of the sequence as its argument and returns a Boolean value
            // indicating whether the element should be included in the returned array.
            let chosenCardIndices = cards.indices.filter {cards[$0].isChosen}
            // map each index to the corresponding array element:
            return chosenCardIndices.count > 0 ? chosenCardIndices.map { cards[$0] } : nil
        }
    }
    // Find all cards in a set
    var setCards : [Card]? {
        // Find set cards (if any)
        get {
            // filter uses a closure that takes an element of the sequence as its argument and returns a Boolean value
            // indicating whether the element should be included in the returned array.
            let chosenCardIndices = cards.indices.filter {cards[$0].isPartOfSet}
            // map each index to the corresponding array element:
            return chosenCardIndices.count > 0 ? chosenCardIndices.map { cards[$0] } : nil
        }
    }
    // Find all mismatched cards
    private var misMatchedCards : [Card]? {
        // Find mismatched cards (if any)
        get {
            // filter uses a closure that takes an element of the sequence as its argument and returns a Boolean value
            // indicating whether the element should be included in the returned array.
            let chosenCardIndices = cards.indices.filter {cards[$0].isMisMatch}
            // map each index to the corresponding array element:
            return chosenCardIndices.count > 0 ? chosenCardIndices.map { cards[$0] } : nil
        }
    }
//
// Methods
    // find a new set if any exists
    mutating func cheat () -> String?{
        var cheatText = "Kein SET 🙁"
        // If any card chosen, no cheating
        if chosenCards != nil || misMatchedCards != nil  || setCards != nil{
            return nil
        }
        for p in cards.combinationsWithoutRepetition(taking : 3) {
            let permutation = p
            if !permutation.setIsRemoved && permutation.areASet {
                permutation.markAsSet(in : &cards)
                noOfSetsFound += 1
                gameScore += Constants.scoreFined
                cheatText = "😎😎😎"
                break
            }
        }
        return cheatText
    } // end cheat
    
    // Remove noOfCards from card Deck (if available), and append to open cards
    // Return the number of cards added
    mutating func dealCards(with noOfCards : Int) -> Int{
        
        // if there is a matching set, then replace the set ...
        if let setFoundBefore = setCards {
            // but only if the noOfCards is three (+3)
            if setFoundBefore.count == noOfCards {
                // we want to remove the set now ...
                setFoundBefore.unMark(in : &cards)
                // and replace with new cards, if any, or clear
                replaceCards (for : setFoundBefore)
            }
            return 0
        }
        //otherwise just append cards, if any available
        if cardDeck.count >= noOfCards
        {
            for _ in 1...noOfCards {
                if let card = cardDeck.popLast() {
                    cards.append(card)
                } else {
                    break
                }
            }
            return noOfCards
        }
        return 0
    }// end dealCards
    
    // Similar functionality as dealCards, however existing cards will be replaced
    mutating func replaceCards (for set: [Card]) {
        let noOfCardsToBeReplaced = set.count
        // Replace cards with new cards from from deck, as long as available
        if cardDeck.count >= noOfCardsToBeReplaced {
            for i in 0..<noOfCardsToBeReplaced {
                if let card = cardDeck.popLast() {
                    cards[cards.firstIndex(matching: set[i])!] = card
                } else {
                    break
                }
            }
        } else {
            // not enough cards in deck, make set invisible instead
            set.remove(in : &cards)
        }
    } // end replace cards
    
    mutating func choose(card : Card){
        let index = cards.firstIndex(matching: card)!
        let currentCard = cards[index]
        
        // toggle chosen status
        if currentCard.isChosen {
            // negative score for deselection
            cards[index].isChosen = false
            gameScore += Constants.scoreDeselection
        } else {
            // chosing a card in a set oder mismatched triple again has no effect
            if !(currentCard.isPartOfSet || currentCard.isMisMatch) {
                cards[index].isChosen = true
            }
        }
        
        // if nothing chosen we are done
        if cards[index].isChosen {
            // TO DO: make sure that card array value is changed , not a copy
            // Something is chosen, this could be a set
            if  let candidates = chosenCards{
                //check for a SET: three have to be chosen
                if candidates.areATriplet {
                    // Now we can have a SET or a mismatch
                    if candidates.areASet {
                        // it was a set!!
                        candidates.markAsSet(in : &cards)
                        // Here we need to score for a set!!
                        gameScore += Constants.scoreSet
                        noOfSetsFound += 1
                    } else {
                        // Now we mark it as a mismatch
                        candidates.markAsMisMatch(in : &cards)
                        // Here we need to score for a mismatch!!
                        gameScore += Constants.scoreMismatch
                    }
                
                    // It is not a triplet, if it is exactly one card, we want to check, if we still have a set marked,
                    // or a mismatch from before
                 }   else if candidates.containOnlyOneCard{
                        if let setFoundBefore = setCards{
                            // we want to remove the set now ...
                            setFoundBefore.unMark(in : &cards)
                            // and replace with new cards, if any, or clear
                            replaceCards (for : setFoundBefore)
                        } else if let misMatchedFoundBefore = misMatchedCards{
                            // we want to reset the mismatched cards (if any) now
                            misMatchedFoundBefore.unMark(in : &cards)
                        }
                    }
                } // else set empty
            } // else no card chosen
    }// end func choose card
    
    // Create card deck and shuffle
    init() {
        // The deck consists of 3x3x3x3=81 unique cards.
        gameScore = 0
        noOfSetsFound = 0
        for number in Card.Constants.numberFeature.allCases {
            for shape in Card.Constants.shapeFeature.allCases {
                    for shading in Card.Constants.shadingFeature.allCases {
                        for color in Card.Constants.colorFeature.allCases {
                            cardDeck += [
                                Card(number: number, shape: shape, shading: shading, color: color)
                            ]
                        }
                }
            }
        }
        cardDeck.shuffle()
    } // init
    
} // end class Game

// Extend collection to deliver handy access to card combinations
private extension Array where Element == Card   {
    // We have three cards chosen
    var areATriplet : Bool {
        get {
            return count == 3
        }
    }
    // Exactly one chosen
    var containOnlyOneCard : Bool {
        get {
            return count == 1
        }
    }
    // check if set was removed before
    var setIsRemoved : Bool {
        get{
            var removed = false
            for card in self {
                 removed = removed || card.isRemoved
             }
            return removed
        }
     }
    
    // all have the same number or have three different numbers.
    var haveSameNumberOrThreeDifferentNumbers : Bool {
        get {
            let number0 = self[0].cardFeatureNumber
            let sameNumber = (number0 == self[1].cardFeatureNumber) && (number0 == self[2].cardFeatureNumber)
            let threeDifferentNumbers = (number0 != self[1].cardFeatureNumber) && (number0 != self[2].cardFeatureNumber) &&
                                        (self[1].cardFeatureNumber != self[2].cardFeatureNumber)
            return sameNumber || threeDifferentNumbers
            }
    }
    // all have the same shape or have three different shapes.
    var haveSameShapeOrThreeDifferentShapes : Bool {
        get {
            let shape0 = self[0].cardFeatureShape
            let sameShape = (shape0 == self[1].cardFeatureShape) && (shape0 == self[2].cardFeatureShape)
            let threeDifferentShapes = (shape0 != self[1].cardFeatureShape) && (shape0 != self[2].cardFeatureShape) &&
                                        (self[1].cardFeatureShape != self[2].cardFeatureShape)
            return sameShape || threeDifferentShapes
            }
    }
    // all have the same shading or have three different shadings.
    var haveSameShadingOrThreeDifferentShadings : Bool {
        get {
            let shading0 = self[0].cardFeatureShading
            let sameShading = (shading0 == self[1].cardFeatureShading) && (shading0 == self[2].cardFeatureShading)
            let threeDifferentShadings = (shading0 != self[1].cardFeatureShading) && (shading0 != self[2].cardFeatureShading) &&
                                        (self[1].cardFeatureShading != self[2].cardFeatureShading)
            return sameShading || threeDifferentShadings
            }
    }
    // all have the same color or have three different colors.
    var haveSameColorOrThreeDifferentColors : Bool {
        get {
            let color0 = self[0].cardFeatureColor
            let sameColor = (color0 == self[1].cardFeatureColor) && (color0 == self[2].cardFeatureColor)
            let threeDifferentColors = (color0 != self[1].cardFeatureColor) && (color0 != self[2].cardFeatureColor) &&
                                        (self[1].cardFeatureColor != self[2].cardFeatureColor)
            return sameColor || threeDifferentColors
            }
    }
    // Rule for a SET:
    // For each one of the four features — color, number, shape, and shading — the three cards must display that feature as
    // a) either all the same, or
    // b) all different.
    var areASet : Bool {
        get {
            
            // A set consists of three cards satisfying all of these conditions:
            return
                //They all have the same number or have three different numbers.
                (self.haveSameNumberOrThreeDifferentNumbers ?
                //They all have the same shape or have three different shapes.
                    (self.haveSameShapeOrThreeDifferentShapes ?
                    //They all have the same shading or have three different shadings.
                        (self.haveSameShadingOrThreeDifferentShadings ?
                    //They all have the same color or have three different colors.
                            (self.haveSameColorOrThreeDifferentColors ? true : false)
                        :false)
                    :false)
                :false)
        }
    }
    // self is an array of 3 candidate cards
    // mark all 3 cards as belonging to a set in the original cards array passed as inout parameter
    // and remove it from the candidate status
    func markAsSet (in cards : inout [Element]){
        for card in self {
            if let index = cards.firstIndex(matching: card){
                cards[index].isPartOfSet = true
                cards[index].isChosen = false
            }
        }
    }
    // self is an array of 3 candidate cards
    // mark all 3 cards as being mismatched in the original cards array passed as inout parameter
    // and remove it from the candidate status
    func markAsMisMatch (in cards : inout [Element]){
        for card in self {
            if let index = cards.firstIndex(matching: card){
                cards[index].isMisMatch = true
                cards[index].isChosen = false
            }
        }
    }
    // self is an array of 3 candidate cards
    // unmark all 3 cards in the original cards array passed as inout parameter
    func unMark(in cards : inout [Element]){
        for card in self {
            if let index = cards.firstIndex(matching: card){
                cards[index].isMisMatch = false
                cards[index].isChosen = false
                cards[index].isPartOfSet = false
            }
        }
    }
    // self is an array of candidate cards
    // mark cards as removed from game in the original cards array passed as inout parameter,
    // because no new cards for replacement available
    func remove(in cards : inout [Element]) {
        for card in self {
            if let index = cards.firstIndex(matching: card){
                cards[index].isMisMatch = false
                cards[index].isChosen = false
                cards[index].isPartOfSet = false
                cards[index].isRemoved = true
            }
        }
    }
    // Given an array of elements and how many of them we are taking, returns an array with
    // all possible permutations without repetition. Please note that as repetition is not allowed,
    // taking must always be less or equal to `elements.count`.
    // Almost by convention, if `taking` is 0, the function will return [[]] (an array with only one possible permutation
    // - a permutation with no elements). In a different scenario, if `taking` is bigger than `elements.count` the function
    // will return [] (an empty array, so including no permutation at all).
    //
    // - Parameters:
    //   - taking: Picking item count from array.
    // - Returns: Returns permutations of elements without repetition.
    func combinationsWithoutRepetition ( taking: Int) -> [[Element]] {
    
          if taking == 1 {
            return self.map {[$0]}
          }

          var permutations = [[Element]]()
          for (index, element) in self.enumerated() {
            var reducedElements = self
            reducedElements.remove(at: index)
            permutations += reducedElements.combinationsWithoutRepetition(taking: taking - 1).map {[element] + $0}
          }

          return permutations
    }
}
