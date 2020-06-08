//
//  StripingExtension.swift
//  SoloSet
//
//  Created by Ulrich Braß on 07.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// This shape delivers a striping pattern in the size of a shape, it is applied to,
struct StripedLayout : Shape {

    func path(in bounds : CGRect) -> Path { // rect is the space offered for drawing
        var stripes = Path()
        let noOfStripes = 8
        let dx = (bounds.maxX - bounds.minX) / CGFloat(noOfStripes)
        
        // striping starting in the middle to make it symmetric
        for i in 0...noOfStripes/2 {
            var xIncr = CGFloat(i) * dx
            stripes.move(to: CGPoint(x: bounds.midX + xIncr, y: bounds.minY ))
            stripes.addLine(to: CGPoint(x: bounds.midX + xIncr, y: bounds.maxY ))
            xIncr = -xIncr
            stripes.move(to: CGPoint(x: bounds.midX + xIncr, y: bounds.minY ))
            stripes.addLine(to: CGPoint(x: bounds.midX + xIncr, y: bounds.maxY ))
        }
        
        return stripes
    }

} // Shape

