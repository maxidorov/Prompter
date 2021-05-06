//
//  TrailEndedViewController.swift
//  Prompter
//
//  Created by Дмитрий on 22.11.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import JGProgressHUD

class TrailEndedViewController: UIViewController {
  private struct Constants {
    static let privacyPolicyLink = "https://maxidorov.github.io/Prompter-privacy-policy/"
    static let termsOfUseURL = "https://dimazzziks.github.io/Prompter-terms-of-use/"
  }

  private let selected = "Monthly"
  private let defaults = UserDefaults.standard

  private let hud: JGProgressHUD = {
    var hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = LocalizedStrings.loading()
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
    label.text = LocalizedStrings.trialHasEnded()
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
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = Brandbook.lightGray
    button.layer.cornerRadius = 55/2
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 20, weight: .bold)
    button.setTitleColor(.white, for: .normal)
    button.setTitle(LocalizedStrings.continue(), for: .normal)
    return button
  }()

  private let restorePurchasesButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    button.setTitleColor(Brandbook.lightGray, for: .normal)
    button.setTitle(LocalizedStrings.restorePurchases(), for: .normal)
    return button
  }()

  private let termsOfUseButton: UIButton = {
    let button = UIButton()
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    button.setTitleColor(Brandbook.lightGray, for: .normal)
    button.setTitle(LocalizedStrings.termsOfUse(), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let privacyPolicyButton: UIButton = {
    let button = UIButton()
    button.contentHorizontalAlignment = .center
    button.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    button.setTitleColor(Brandbook.lightGray, for: .normal)
    button.setTitle(LocalizedStrings.privacyPolicy(), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let bottomStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let stackView : UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.layer.zPosition = 0
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor  = .white
    setSubscriptionInfo()
  }

  private func setView() {
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 270),
      stackView.widthAnchor.constraint(equalToConstant: 310)
    ])

    mainView.addSubview(mainLabel)
    NSLayoutConstraint.activate([
      mainLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 12),
      mainLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -12),
      mainLabel.topAnchor.constraint(equalTo:mainView.topAnchor , constant: 30),
      mainLabel.bottomAnchor.constraint(
        equalTo: mainView.bottomAnchor,
        constant: -100
      )
    ])

    mainView.addSubview(continueButton)
    NSLayoutConstraint.activate([
      continueButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
      continueButton.heightAnchor.constraint(equalToConstant: 55),
      continueButton.widthAnchor.constraint(equalToConstant: 210),
      continueButton.bottomAnchor.constraint(
        equalTo: mainView.bottomAnchor,
        constant: -30
      )
    ])

    let subscribeGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.subscribe)
    )
    continueButton.addGestureRecognizer(subscribeGesture)

    mainView.layer.shadowColor = UIColor.black.cgColor
    stackView.addArrangedSubview(mainView)

    bottomStackView.addArrangedSubview(termsOfUseButton)
    let showTermsGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.showTerms)
    )
    termsOfUseButton.addGestureRecognizer(showTermsGesture)

    bottomStackView.addArrangedSubview(restorePurchasesButton)
    let restorePurchasesGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.restorePurchasesTapped)
    )
    restorePurchasesButton.addGestureRecognizer(restorePurchasesGesture)
    
    bottomStackView.addArrangedSubview(privacyPolicyButton)
    let showPrivacyPolicyGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(self.showPrivacyPolicy)
    )
    privacyPolicyButton.addGestureRecognizer(showPrivacyPolicyGesture)
    stackView.addArrangedSubview(bottomStackView)
  }

  private func setSubscriptionInfo() {
    hud.show(in: view)
    SwiftyStoreKit.retrieveProductsInfo([selected]) { result in
      for product in result.retrievedProducts {
        if product.productIdentifier == self.selected {
          self.mainLabel.text = LocalizedStrings.trialHasEndedWithArgs([
            product.price.stringValue,
            product.priceLocale.currencySymbol!
          ])
        }
      }

      self.hud.dismiss()
      self.setView()
    }
  }


  @objc private func subscribe(sender : UITapGestureRecognizer) {
    print("ok")
    hud.show(in: view)
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
        self.hud.dismiss()
        self.dismiss(animated: true, completion: nil)
      case .error(let error):
        self.hud.dismiss()
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
    hud.show(in: view)
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
          self.hud.dismiss()
          self.dismiss(animated: true, completion: nil)
        case .expired(let expiryDate, let items):
          print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
          self.defaults.set(false, forKey: "subscribe")
          self.hud.dismiss()
        case .notPurchased:
          print("The user has never purchased \(productIds)")
          self.defaults.set(false, forKey: "subscribe")
          self.hud.dismiss()
        }
      case .error(let error):
        print("Receipt verification failed: \(error)")
        self.defaults.set(false, forKey: "subscribe")
        self.hud.dismiss()
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
