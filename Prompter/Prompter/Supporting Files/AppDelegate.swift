//
//  AppDelegate.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import YandexMobileMetrica
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var firstTime = true
  let defaults = UserDefaults.standard

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    setupUserDefaults()
    setupYandexMobileMetrica()
    setupSwiftyStoreKit()

    return true
  }

  private func setupUserDefaults() {
    UserDefaults.standard.register(defaults: UserDefaults.applicationDefaults)
  }

  private func setupYandexMobileMetrica() {
    let configuration = YMMYandexMetricaConfiguration.init(apiKey: Keys.yandexMetrica)
    YMMYandexMetrica.activate(with: configuration!)
  }

  private func setupSwiftyStoreKit() {
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
    if firstTime {
      let time = Int(Date().timeIntervalSinceReferenceDate)
      defaults.set(true, forKey: "launched")
      defaults.set(time, forKey: "startTrialTime")
    }
    restorePurchases()
  }
}
