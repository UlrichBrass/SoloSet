//
//  SquiggleLayout.swift
//  SoloSet
//
//  Created by Ulrich Braß on 06.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// The Shape protocol will be used here for custom drawing of the SQUIGGLE symbol
//
// A Shape is a view, however the Shape protocol (by extension) implements View’s body var for us.
// But it introduces its own func that we are required to implement ...
// That func will create and return a Path that draws anything we want. Path has many functions to support drawing
//

struct SquiggleLayout : Shape {
    
    func path(in rect : CGRect) -> Path { // rect is the space offered for drawing
        
        let leftArcStart = CGPoint (x: rect.minX + rect.height/4, y: rect.maxY)
        let leftArcStop = CGPoint (x: rect.minX + 3 * rect.height/4, y: rect.minY)
        let rightArcStart = CGPoint (x: rect.maxX - rect.height/4, y: rect.minY)
        let rightArcStop = CGPoint (x: rect.maxX - 3 * rect.height/4, y: rect.maxY)
        
        var p = Path()
        
        // draw Squiggle
           // draw left arc
           p.move(to:leftArcStart)
           p.addCurve(to: leftArcStop, control1: CGPoint(x: rect.minX, y: rect.maxY), control2: CGPoint(x: rect.minX, y: rect.minY))

           //draw upper connection curve
           p.addCurve(to: rightArcStart, control1: CGPoint(x: rect.midX + rect.height/4, y: rect.minY), control2: CGPoint(x: rect.midX+rect.height/4, y: rect.midY))
    
           // draw right arc
           p.addCurve(to: rightArcStop, control1: CGPoint(x: rect.maxX, y: rect.minY), control2: CGPoint(x: rect.maxX, y: rect.maxY))

           //draw lower connection curve
           p.addCurve(to: leftArcStart, control1: CGPoint(x: rect.midX-rect.height/2, y: rect.midY), control2: CGPoint(x: rect.midX-rect.height/2, y: rect.maxY))
        //

        return p // return a Path
    }
}
