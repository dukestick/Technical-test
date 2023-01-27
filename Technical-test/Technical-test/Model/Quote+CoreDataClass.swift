//
//  Quote+CoreDataClass.swift
//  Technical-test
//
//  Created by Kostya Yudin on 26.01.2023.
//
//

import Foundation
import CoreData
import UIKit

@objc(Quote)
public class Quote: NSManagedObject {
     var image: UIImage? {
          if self.isLiked {
               return UIImage(named: "favorite")
          } else {
               return UIImage(named: "no-favorite")
          }
     }
     var percentsColor: UIColor? {
          switch self.variationColor {
          case "green": return UIColor(named: "appGreen")
          case "red": return UIColor(named: "appRed")
          default: return UIColor(named: "appRed")
          }
     }
}
