//
//  SceneDelegate.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

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
