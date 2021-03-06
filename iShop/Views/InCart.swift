//
//  InBasket.swift
//  iShop
//
//  Created by Chris Filiatrault on 17/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct InCart: View {
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @EnvironmentObject var globalVariables: GlobalVariableClass
   
   var thisList: ListOfItems
   var category: Category
   var items: FetchRequest<Item>
   @State var restoreItems: Bool = false
   init(listFromHomePage: ListOfItems, categoryFromItemList: Category) {
      
      thisList = listFromHomePage
      category = categoryFromItemList
      
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let inListPredicate = NSPredicate(format: "addedToAList == true")
      let markedOffPredicate = NSPredicate(format: "markedOff == true")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, markedOffPredicate])
      
      items = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
      ], predicate: compoundPredicate)
      
   }
   
   var body: some View {
      
         Group {
            if items.wrappedValue.count > 0 {
               
               Text(category.wrappedName)
                  .font(.headline)
                  .listRowBackground(Color("listBackground"))
                  .offset(y: 7)
               
               
               HStack {
               Spacer()
                  Text("Clear")
                     .bold()
                     .modifier(InCartButton())
                     .onTapGesture {
                        withAnimation {
                        for item in self.items.wrappedValue {
                           removeItemFromList(thisItem: item, listOrigin: self.thisList)
                        }
                           hapticFeedback()
                        }
                     }
                  
                  Text("Restore")
                  .bold()
                  .padding(.horizontal, 2)
                  .modifier(InCartButton())
                  .onTapGesture {
                     withAnimation {
                     for item in self.items.wrappedValue {
                        restoreItemInList(thisItem: item, thisList: self.thisList)
                        hapticFeedback()
                     }
                     }
                  }
               Spacer()
               }.padding(.horizontal, 10)
               .listRowBackground(Color("standardDarkBlue"))
               
               ForEach(items.wrappedValue) { item in
                  ItemRow(thisList: self.thisList, thisItem: item, markedOff: item.markedOff, position: item.position)
                     .listRowBackground(Color("standardDarkBlue"))
               }.onDelete(perform: removeSwipedItem)
               
            }
         }
      
   }
   
   // REMOVE (swiped) ITEM
   func removeSwipedItem(at offsets: IndexSet) {
      
      guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
            return
      }
      
      let managedContext =
         appDelegate.persistentContainer.viewContext

      for offset in offsets {
         let thisItem = items.wrappedValue[offset]
         
         thisItem.addedToAList = false
         thisItem.markedOff = false
         thisItem.quantity = 1
         thisItem.position = 0
         thisItem.timesPurchased += 1
      }
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not delete. \(error), \(error.userInfo)")
      }
   } // End of function
   
}

