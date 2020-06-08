//
//  SetSymbol.swift
//  SoloSet
//
//  Created by Ulrich Braß on 06.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// ViewModifier is a mechanism for making incremental modifications to Views.
// Here we want to give the look and feel of a Set card symbol to some content to which we apply the modifier

struct SetSymbol : ViewModifier {
    
    var size : CGSize
    var color : Color
    
    let elementWidthToCardWidth = CGFloat(3.0 / 4.0)
    let elementHeightToCardHeight = CGFloat(1.3 / 6.0)
    let spacingWidthToCardWidth  = CGFloat( 0.5 / 4.0)
    
    func body(content: Content ) -> some View{
        HStack {
            Spacer(minLength : size.width * spacingWidthToCardWidth)
            
            content
                .frame(width: size.width * elementWidthToCardWidth,
                       height: size.height * elementHeightToCardHeight, alignment: .center)
                .foregroundColor(color)
                
            
            Spacer(minLength : size.width * spacingWidthToCardWidth)
        }
    
    } // body
} // SetSymbol


