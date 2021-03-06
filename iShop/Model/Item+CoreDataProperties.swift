//
//  Item+CoreDataProperties.swift
//  iShop
//
//  Created by Chris Filiatrault on 31/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//

import SwiftUI
import Foundation
import CoreData


extension Item {
   
   @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
      return NSFetchRequest<Item>(entityName: "Item")
   }
   
   @NSManaged public var addedToAList: Bool // Toggles Green plus in catalogue
   @NSManaged public var dateAdded: Date?
   @NSManaged public var markedOff: Bool // Toggles tick image in a list
   @NSManaged public var name: String?
   @NSManaged public var quantity: Int32
   @NSManaged public var id: UUID?
   @NSManaged public var origin: ListOfItems?
   @NSManaged public var categoryOrigin: Category?
   @NSManaged public var position: Int32
   @NSManaged public var categoryOriginName: String?
   @NSManaged public var timesPurchased: Int64
   @NSManaged public var price: Double
   @NSManaged public var itemDescription: String?
   
   
   
   // Added these properties to Item, so the String value from name can be easily accessed.
   public var wrappedName: String {
      name ?? ""
   }
   
   public var wrappedDate: Date {
      dateAdded ?? Date()
   }

   
   public var wrappedOriginName: String {
      origin?.name ?? ""
   }
   
   public var wrappedID: UUID {
      id ?? UUID()
   }
   
   public var wrappedCategoryOriginName: String {
      categoryOrigin?.wrappedName ?? ""
   }
   
   public var wrappedItemDescription: String {
      itemDescription ?? ""
   }
   
}

