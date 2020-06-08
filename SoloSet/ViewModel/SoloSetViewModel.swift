//
//  SoloSetViewModel.swift
//  SoloSet
//
//  Created by Ulrich Braß on 08.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import Foundation

//
// The VIEWMODEL file: is a portal between views and model.
// - binds VIEW to MODEL
// - processes intent by modifying the model
// - notice and publish changes
// A class is chosen as representation, because it is easily sharable
//

final class SoloSetViewModel : ObservableObject{
    // published properties
    @Published  private(set) var gameModel : Game?  // the game
    
    private let noOfCardsAtStart : Int = 12
    
    // MARK: - Access to model for views (portal)
    // Prepare data from MODEL to be presented to a user. A VIEW MODEL structures data in a way that is convenient for a VIEW to consume.
     var cards : [Card] {
           gameModel?.cards ?? [Card]()
       }
       
       var gameScore : Int {
           gameModel?.gameScore ?? 0
       }
       
       var noOfSetsFound : Int {
           gameModel?.noOfSetsFound ?? 0
       }

    
    // MARK: - User Intents - provide functions, that allow views to access the model
    // Interpret user inputs into actions upon business rules and data.
    func chooseCard(card chosenCard : Card) {
        gameModel!.choose(card: chosenCard)
    }
    
    init(){
        gameModel = Game()
        assert(gameModel!.dealCards(with : noOfCardsAtStart) == noOfCardsAtStart)
    }
} // class
