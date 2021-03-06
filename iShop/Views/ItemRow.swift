//
//  ItemCategoryRow.swift
//  iShop
//
//  Created by Chris Filiatrault on 9/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ItemRow: View {
   
   @Environment(\.editMode)  var editMode
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @Environment(\.managedObjectContext) var context
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   var thisList: ListOfItems
   var thisItem: Item
   @State var showItemDetails: Bool = false
   @State var markedOff: Bool
   @State var position: Int32
   
   var body: some View {
      
      HStack {
         
         
         Button(action: {
            if self.thisItem.markedOff == false {
               withAnimation {
               markOffItemInList(thisItem: self.thisItem, thisList: self.thisList)
               }
            }
            else if self.thisItem.markedOff == true {
               withAnimation {
               restoreItemInList(thisItem: self.thisItem, thisList: self.thisList)
               }
            }
            GlobalVariableClass().refreshingID = UUID()
            hapticFeedback()
         }) {
            HStack {
               
               // Checkbox & name
               Image(systemName: thisItem.markedOff == true ? "checkmark.circle.fill" : "circle")
                  .imageScale(.large)
                  .foregroundColor(thisItem.markedOff == true ? Color("markedOffBlue") : .black)
               
               Text(thisItem.quantity > 1 ?
                  "\(self.thisItem.quantity) x \(thisItem.wrappedName)" :
                  "\(thisItem.wrappedName)")
                  .foregroundColor(thisItem.markedOff == true ? .white : .black)
                  .multilineTextAlignment(.leading)
               
               
               Spacer()
               
               Divider()
               
               // Item details button
               Button(action: {
                  self.showItemDetails.toggle()
                  withAnimation {
                     self.editMode?.wrappedValue = .inactive
                  }
               }) {
                  if !globalVariables.userIsOnMac {
                     Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                        .foregroundColor(thisItem.markedOff == true ? .white : .black)
                        .padding(7)
                  } else {
                     Text("✏️")
                  }
               }
               
            }
         }
      }
      .id(globalVariables.refreshingID)
      .listRowBackground(thisItem.markedOff == true ? Color("standardDarkBlue") : Color(.white))
         
      .sheet(isPresented: self.$showItemDetails) {
         VStack {
            if self.thisItem.categoryOrigin != nil {
               ItemDetails(thisItem: self.thisItem,
                           showItemDetails: self.$showItemDetails,
                           itemName: self.thisItem.wrappedName,
                           oldItemCategory: self.thisItem.categoryOrigin!,
                           newItemCategory: self.thisItem.categoryOrigin!,
                           thisItemQuantity: self.thisItem.quantity,
                           oldList: self.thisItem.origin!,
                           newList: self.thisItem.origin!,
                           categoryName: self.thisItem.categoryOrigin!.wrappedName,
                           thisList: self.thisList)
                  .environment(\.managedObjectContext, self.context)
                  .environmentObject(self.globalVariables)
            } else {
               errorMessage(debuggingErrorMessage: "origin and/or categoryOrigin not found when passing thisItem into ItemDetails()")
            }
         }
         
      }
      
   }
}



