//
//  OvalLayout.swift
//  SoloSet
//
//  Created by Ulrich Braß on 05.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// The Shape protocol will be used here for custom drawing of the OVAL symbol
//
// A Shape is a view, however the Shape protocol (by extension) implements View’s body var for us.
// But it introduces its own func that we are required to implement ...
// That func will create and return a Path that draws anything we want. Path has many functions to support drawing
//

struct OvalLayout : Shape {
    
    func path(in rect : CGRect) -> Path { // rect is the space offered for drawing
        
        let radius = rect.height/2
        let leftArcCenter = CGPoint (x: rect.minX + radius, y: rect.midY)
        let leftArcStart = CGPoint (x: leftArcCenter.x, y: rect.maxY)
        let rightArcCenter = CGPoint (x: rect.maxX - radius, y: rect.midY)
        let rightArcStart = CGPoint (x: rightArcCenter.x, y: rect.minY)
        
        
        var p = Path()
        
        // draw Oval
            // draw left arc and upper connection line
            p.addArc(center: leftArcCenter, radius: radius, startAngle: Angle.radians( Double.pi / 2),
                     endAngle: Angle.radians( 3 * Double.pi / 2), clockwise: false)
            p.addLine(to: rightArcStart) // starts from arc startpoint
            // draw right arc and lower connection line
            p.addArc(center: rightArcCenter, radius: radius, startAngle: Angle.radians(3 * Double.pi / 2),
                     endAngle: Angle.radians(Double.pi/2), clockwise: false)
            p.addLine(to: leftArcStart) // starts from arc startpoint
            //
        //
        
        return p // return a Path
    }
}
