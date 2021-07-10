//
//  SubscriptionsFunctions.swift
//  Prompter
//
//  Created by Дмитрий on 24.11.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import Foundation
import SwiftyStoreKit

func restorePurchases() {
  let defaults = UserDefaults.standard
  let appleValidator = AppleReceiptValidator(
    service: .production,
    sharedSecret: Keys.appleReceiptValidatorSharedSecretKey
  )
  SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
    switch result {
    case .success(let receipt):
      let productIds = Set(Brandbook.subscriptions)
      let purchaseResult = SwiftyStoreKit.verifySubscriptions(
        productIds: productIds,
        inReceipt: receipt
      )
      switch purchaseResult {
      case .purchased(let expiryDate, let items):
        print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
        defaults.set(true, forKey: "subscribed")
      case .expired(let expiryDate, let items):
        print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
        defaults.set(false, forKey: "subscribed")
      case .notPurchased:
        print("The user has never purchased \(productIds)")
        defaults.set(false, forKey: "subscribed")
      }
    case .error(let error):
      print("Receipt verification failed: \(error)")
      defaults.set(false, forKey: "subscribed")
    }
  }
}


