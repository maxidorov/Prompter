//
//  TrialEndedViewController.swift
//  Prompter
//
//  Created by Maxim V. Sidorov on 5/7/21.
//  Copyright © 2021 Maxim Sidorov. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import JGProgressHUD

class TrialEndedViewController: UIViewController {
  private struct Constants {
    static let privacyPolicyLink = "https://maxidorov.github.io/Prompter-privacy-policy/"
    static let termsOfUseURL = "https://dimazzziks.github.io/Prompter-terms-of-use/"
  }

  private let selected = "Monthly"
  private let defaults = UserDefaults.standard

  private let progressHud: JGProgressHUD = {
    var hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = Localized.loading()
    return hud
  }()

  private let mainView: UIView = {
    var view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.layer.cornerRadius = 15
    view.layer.shadowOpacity = 0.3
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 5
    return view
  }()

  private let mainLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = Localized.trialHasEnded()
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.textAlignment = .center
    label.backgroundColor = .clear
    label.textColor = .black
    label.font = Brandbook.font(size: 22, weight: .bold)
    label.numberOfLines = 0
    return label
  }()

  private let continueButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = Brandbook.lightGray
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 20, weight: .bold)
    button.setTitleColor(.white, for: .normal)
    button.setTitle(Localized.continue(), for: .normal)
    return button
  }()

  private let restorePurchasesButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    button.setTitleColor(Brandbook.lightGray, for: .normal)
    button.setTitle(Localized.restorePurchases(), for: .normal)
    return button
  }()

  private let termsOfUseButton: UIButton = {
    let button = UIButton(type: .system)
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    button.setTitleColor(Brandbook.lightGray, for: .normal)
    button.setTitle(Localized.termsOfUse(), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let privacyPolicyButton: UIButton = {
    let button = UIButton(type: .system)
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    button.setTitleColor(Brandbook.lightGray, for: .normal)
    button.setTitle(Localized.privacyPolicy(), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor  = .white
    setSubscriptionInfo()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    continueButton.layer.cornerRadius = continueButton.frame.height / 2
  }

  private func setSubscriptionInfo() {
    progressHud.show(in: view)
    SwiftyStoreKit.retrieveProductsInfo([selected]) { result in
      for product in result.retrievedProducts {
        if product.productIdentifier == self.selected {
          self.mainLabel.text = Localized.trialHasEndedWithArgs([
            product.price.stringValue,
            product.priceLocale.currencySymbol!
          ])
        }
      }

      self.progressHud.dismiss()
      self.setView()
    }
  }

  private func setView() {
    view.addSubview(mainView)
    mainView.addSubview(mainLabel)
    mainView.addSubview(continueButton)

    view.addSubview(restorePurchasesButton)
    view.addSubview(termsOfUseButton)
    view.addSubview(privacyPolicyButton)

    let inset: CGFloat = 16

    NSLayoutConstraint.activate([
      mainLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: inset),
      mainLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -inset),
      mainLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: inset),
    ])

    NSLayoutConstraint.activate([
      continueButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: inset),
      continueButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -inset),
      continueButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: inset),
      continueButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -inset)
    ])

    NSLayoutConstraint.activate([
      mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
      mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
      mainView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.4)
    ])

    NSLayoutConstraint.activate([
      restorePurchasesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      restorePurchasesButton.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 8)
    ])

    NSLayoutConstraint.activate([
      privacyPolicyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      privacyPolicyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])

    NSLayoutConstraint.activate([
      termsOfUseButton.bottomAnchor.constraint(equalTo: privacyPolicyButton.topAnchor),
      termsOfUseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])

    let subscribeGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.subscribe)
    )
    continueButton.addGestureRecognizer(subscribeGesture)

    mainView.layer.shadowColor = UIColor.black.cgColor

    let showTermsGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.showTerms)
    )
    termsOfUseButton.addGestureRecognizer(showTermsGesture)

    let restorePurchasesGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.restorePurchasesTapped)
    )
    restorePurchasesButton.addGestureRecognizer(restorePurchasesGesture)

    let showPrivacyPolicyGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.showPrivacyPolicy)
    )
    privacyPolicyButton.addGestureRecognizer(showPrivacyPolicyGesture)
  }

  @objc private func subscribe(sender : UITapGestureRecognizer) {
    progressHud.show(in: view)
    SwiftyStoreKit.purchaseProduct(
      selected,
      quantity: 1,
      atomically: false
    ) { result in
      switch result {
      case .success(let product):
        if product.needsFinishTransaction {
          SwiftyStoreKit.finishTransaction(product.transaction)
        }
        print("Purchase Success: \(product.productId)")
        self.defaults.set(true, forKey: "subscribed")
        self.progressHud.dismiss()
        self.dismiss(animated: true, completion: nil)
      case .error(let error):
        self.progressHud.dismiss()
        switch error.code {
        case .unknown:
          print("Unknown error. Please contact support")
        case .clientInvalid:
          print("Not allowed to make the payment")
        case .paymentCancelled:
          break
        case .paymentInvalid:
          print("The purchase identifier was invalid")
        case .paymentNotAllowed:
          print("The device is not allowed to make the payment")
        case .storeProductNotAvailable:
          print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied:
          print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed:
          print("Could not connect to the network")
        case .cloudServiceRevoked:
          print("User has revoked permission to use this cloud service")
        default:
          print((error as NSError).localizedDescription)
        }
      }
    }
  }

  @objc private func restorePurchasesTapped(sender : UITapGestureRecognizer) {
    progressHud.show(in: view)
    let appleValidator = AppleReceiptValidator(
      service: .production,
      sharedSecret: Brandbook.sharedKey
    )
    SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
      switch result {
      case .success(let receipt):
        let productIds =  Set(Brandbook.subscriptions)
        let purchaseResult = SwiftyStoreKit.verifySubscriptions(
          productIds: productIds,
          inReceipt: receipt
        )
        switch purchaseResult {
        case .purchased(let expiryDate, let items):
          print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
          self.defaults.set(true, forKey: "subscribe")
          self.progressHud.dismiss()
          self.dismiss(animated: true, completion: nil)
        case .expired(let expiryDate, let items):
          print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
          self.defaults.set(false, forKey: "subscribe")
          self.progressHud.dismiss()
        case .notPurchased:
          print("The user has never purchased \(productIds)")
          self.defaults.set(false, forKey: "subscribe")
          self.progressHud.dismiss()
        }
      case .error(let error):
        print("Receipt verification failed: \(error)")
        self.defaults.set(false, forKey: "subscribe")
        self.progressHud.dismiss()
      }
    }
  }

  @objc private func showPrivacyPolicy(sender : UITapGestureRecognizer) {
    let url = URL(string: Constants.privacyPolicyLink)
    UIApplication.shared.open(url!)
  }

  @objc private func showTerms(sender : UITapGestureRecognizer) {
    let url = URL(string: Constants.termsOfUseURL)
    UIApplication.shared.open(url!)
  }
}
