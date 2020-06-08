//
//  DiamondLayout.swift
//  SoloSet
//
//  Created by Ulrich Braß on 05.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// The Shape protocol will be used here for custom drawing of the DIAMOND symbol
//
// A Shape is a view, however the Shape protocol (by extension) implements View’s body var for us.
// But it introduces its own func that we are required to implement ...
// That func will create and return a Path that draws anything we want. Path has many functions to support drawing
//

struct DiamondLayout : Shape {
    
    func path(in rect : CGRect) -> Path { // rect is the space offered for drawing
        
        let top = CGPoint( x : rect.midX,  y : rect.minY )
        let right = CGPoint(x: rect.minX + rect.width, y: rect.midY )
        let down = CGPoint(x: rect.midX, y: rect.minY + rect.height)
        let left = CGPoint(x: rect.minX , y: rect.midY)
        
        var p = Path()
        
        // draw diamond
            p.move(to: top)
            p.addLine(to : right)
            p.addLine(to: down)
            p.addLine(to: left)
            p.addLine(to: top)
        //
        
        return p// return a Path
    }
}
