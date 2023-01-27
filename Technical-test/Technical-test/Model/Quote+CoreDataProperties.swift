//
//  Quote+CoreDataProperties.swift
//  Technical-test
//
//  Created by Kostya Yudin on 26.01.2023.
//
//

import Foundation
import CoreData


extension Quote {
     
     @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
          return NSFetchRequest<Quote>(entityName: "Quote")
     }
     
     @NSManaged public var name: String?
     @NSManaged public var last: String?
     @NSManaged public var currency: String?
     @NSManaged public var readableLastChangePercent: String?
     @NSManaged public var variationColor: String?
     @NSManaged public var symbol: String?
     @NSManaged public var isLiked: Bool
     
}

extension Quote : Identifiable {
     
}
