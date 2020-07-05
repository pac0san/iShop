//
//  Catalogue.swift
//  iShop
//
//  Created by Chris Filiatrault on 24/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct Catalogue: View {
   
   var thisList: ListOfItems
   var fetchRequest: FetchRequest<Item>
   
   init(passedInList: ListOfItems, filter: String) {
   
      thisList = passedInList
      
      fetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      ], predicate: NSPredicate(format: "origin = %@", thisList))
      
      if filter != "" {
         let originPredicate = NSPredicate(format: "origin = %@", thisList)
         let containsPredicate = NSPredicate(format: "name CONTAINS[c] %@", filter)
         let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, containsPredicate])
         
         fetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
            ], predicate: compoundPredicate)
      }
   }
   
   
   var body: some View {
      VStack {
         
         
         List {
            //ForEach(fetchRequest.wrappedValue, id: \.self) { catalogueItem in
            ForEach(fetchRequest.wrappedValue, id: \.self) { catalogueItem in
               CatalogueRow(thisList: self.thisList, catalogueItem: catalogueItem)
               }
            .onDelete(perform: deleteSwipedCatalogueItem)
               .listRowBackground(Color(.white))
         }
         .background(Color("listBackground"))
         
      }
   }
      
   

   // DELETE (swiped) CATALOGUE ITEM
   func deleteSwipedCatalogueItem(at offsets: IndexSet) {

      guard let appDelegate =
         UIApplication.shared.delegate as? AppDelegate else {
            return
      }

      let managedContext =
         appDelegate.persistentContainer.viewContext

      let allItemsFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")

      let thisListsItemsFetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Item")
      thisListsItemsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      ]
      thisListsItemsFetchRequest.predicate = NSPredicate(format: "origin = %@", thisList)


      do {

         let thisListFetchReturn = try managedContext.fetch(thisListsItemsFetchRequest)
         let items = try managedContext.fetch(allItemsFetchRequest) as! [Item]
         
         for offset in offsets {
            
            // get item to be deleted
            let thisItem = thisListFetchReturn[offset] as! Item
            
            // delete that item and all items with the same name
            for item in items {
               if item.wrappedName == thisItem.wrappedName {
                  managedContext.delete(item)
               }
            }
            
         }

         do {
            try managedContext.save()
            print("Item successfully deleted")
         } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
         }

      } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
      }
   }

   
}
