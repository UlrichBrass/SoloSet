//
//  GridView.swift
//  SoloSet
//
//  Created by Ulrich Braß on 08.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// Create a grid view for the cards
struct GridView<Item, ItemView>: View where Item : Identifiable, ItemView : View{
    private var items : [Item]
    private var viewForItems : (Item) -> ItemView
    
   
    // We have that much space, and will find a layout to best fit all our items
    var body: some View {
        GeometryReader{ geometry in
            // Force each card to have a width to height ratio of 2:3
            self.body(for : GridLayout(itemCount : self.items.count, nearAspectRatio : 2.0/3.0, in : geometry.size))
        } // Geometry Reader
    } // body

    //We walk through all the items and create the  view for the item
    private func body(for layout : GridLayout) -> some View {
        ForEach(items) { item in
            self.body(for : item, in : layout)
        }// ForEach
    }
    
    // For a given item apply its view within it's grid frame and position
    private func body(for item : Item, in layout : GridLayout) -> some View {
        let index = items.firstIndex(matching : item)!
        return viewForItems(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position (layout.location(ofItemAt: index))
    }
    
    init ( _ items : [Item], viewForItems : @escaping (Item) -> ItemView){
           self.items = items
           self.viewForItems = viewForItems // function not called in init therefore @escaping
       }

} // GridView

