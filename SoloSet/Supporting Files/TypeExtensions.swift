//
//  TypeExtensions.swift
//  SoloSet
//
//  Created by Ulrich Braß on 08.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// find index of an identifiable item in an array of items
extension Array where Element : Identifiable{
    func firstIndex(matching element: Element) -> Int? {
        return self.firstIndex{$0.id == element.id}
    }
}

// Apply striping pattern to a given shape
extension Shape {
    func stripe( lineWidth: CGFloat) -> some View {
        ZStack {
            self.stroke(lineWidth: lineWidth)
            self.mask(StripedLayout().stroke(lineWidth: lineWidth - 1))
        } //Zstack
    }
}

// provide an easier to use modifier
extension View{
    func setSymbol(size : CGSize, color: Color) -> some View {
        return self.modifier(SetSymbol (size : size, color: color))
    }
}
