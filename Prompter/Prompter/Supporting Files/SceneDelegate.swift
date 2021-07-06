//
//  SceneDelegate.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData
import SwiftyStoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var firstTime = true
  let defaults = UserDefaults.standard

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DataModel")
    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("ERROR: Unable to load persistent stores: \(error)")
      }
    }
    return container
  }()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    //проверка подписки в фоне

    SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
      for purchase in purchases {
        switch purchase.transaction.transactionState {
        case .purchased, .restored:
          if purchase.needsFinishTransaction {
            // Deliver content from server, then:
            SwiftyStoreKit.finishTransaction(purchase.transaction)
          }
        // Unlock content
        case .failed, .purchasing, .deferred:
          break // do nothing
        @unknown default:
          break
        }
      }
    }

    firstTime = !defaults.bool(forKey: "launched")
    if (firstTime) {
      let time = Int(Date().timeIntervalSinceReferenceDate)
      defaults.set(true, forKey: "launched")
      defaults.set(time, forKey: "startTrialTime")
    }
    restorePurchases()

    guard let mainScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: mainScene)
    let textsViewController = TextsViewController()
    textsViewController.context = persistentContainer.viewContext
    textsViewController.backgroundContext = persistentContainer.newBackgroundContext()
    window?.rootViewController = BaseNavigationViewController(rootViewController: textsViewController)
    window?.overrideUserInterfaceStyle = .light
    window?.makeKeyAndVisible()

  }
}

