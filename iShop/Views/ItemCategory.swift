//
//  ItemCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 1/6/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
// 
import SwiftUI
import CoreData

struct ItemCategory: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   var thisList: ListOfItems
   var thisCategory: Category
   var items: FetchRequest<Item>
   var thisCategoryHasItems: Bool {
      var numItems: Int = 0
      for item in thisCategory.itemsInCategoryArray {
         if item.addedToAList == true && thisList.itemArray.contains(item) {
            numItems += 1
         }
      }
      return numItems > 0
   }
   var someItemsAreNotMarkedOff: Bool {
      var numItems: Int = 0
      for item in thisCategory.itemsInCategoryArray {
         if item.addedToAList == true && thisList.itemArray.contains(item) && item.markedOff == false {
            numItems += 1
         }
      }
      return numItems > 0
   }
   
   init(listFromHomePage: ListOfItems, categoryFromItemList: Category) {
      
      
      thisList = listFromHomePage
      thisCategory = categoryFromItemList
      
      let categoryOriginNamePredicate = NSPredicate(format: "categoryOriginName = %@", thisCategory.wrappedName)
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let inListPredicate = NSPredicate(format: "addedToAList == true")
//      let categoryPredicate = NSPredicate(format: "categoryOriginName = %@", thisCategory.wrappedName)
      let markedOffPredicate = NSPredicate(format: "markedOff == false")
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [categoryOriginNamePredicate, originPredicate, inListPredicate, markedOffPredicate])
      
      items = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
      ], predicate: compoundPredicate)
      
   }
   
   var body: some View {
      
      Group {
         if thisCategoryHasItems {
            
            if someItemsAreNotMarkedOff {
               Text(thisCategory.wrappedName)
                  .font(.headline)
                  .listRowBackground(Color("listBackground"))
                  .offset(y: globalVariables.userIsOnMac ? 4 : 7)
            }
            
            ForEach(items.wrappedValue) { item in
               ItemRow(thisList: self.thisList, thisItem: item, markedOff: item.markedOff, position: item.position)
            }
            .onDelete(perform: removeSwipedItem)
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
         
         for item in thisList.itemArray {
            if item.position > thisItem.position {
               item.position -= 1
            }
         }
         thisItem.addedToAList = false
         thisItem.markedOff = false
         thisItem.quantity = 1
         thisItem.position = 0
      }
      do {
         try managedContext.save()
      } catch let error as NSError {
         print("Could not delete. \(error), \(error.userInfo)")
      }
   } // End of function
   
}

