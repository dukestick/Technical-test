//
//  AppDelegate.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
     
     var window: UIWindow?
     
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          
          window = UIWindow(frame: UIScreen.main.bounds)
          let vc:QuotesListViewController = QuotesListViewController()
          let nc:UINavigationController = UINavigationController(rootViewController: vc)
          
          self.window?.rootViewController = nc
          self.window?.makeKeyAndVisible()
          
          return true
     }
     
     var persistentContainer = {
          let container = NSPersistentContainer(name: "Models")
          container.loadPersistentStores { description, error in
               guard error == nil else { fatalError("Can't load persistent store") }
          }
          return container
     }()
     
     func saveContext() {
          let context = persistentContainer.viewContext
          if context.hasChanges {
               do {
                    try context.save()
               } catch {
                    fatalError("Failed to save context")
               }
          }
     }
}


