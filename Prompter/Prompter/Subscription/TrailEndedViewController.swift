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
  let selected = "Monthly"
  let defaults = UserDefaults.standard
  let hud : JGProgressHUD = {
    var h = JGProgressHUD(style: .dark)
    h.textLabel.text = NSLocalizedString("Loading", comment: "")
    return h
  }()

  var mainView : UIView = {
    var v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = .white
    v.layer.cornerRadius = 15
    v.layer.shadowOpacity = 0.3
    v.layer.shadowOffset = .zero
    v.layer.shadowRadius = 5
    return v
  }()

  var mainLabel : UILabel = {
    var l = UILabel()
    l.translatesAutoresizingMaskIntoConstraints = false
    l.text = "Your trial has ended,\ncontinue with\njust 29RUB/Month"
    l.textAlignment = .center
    l.backgroundColor = .clear
    l.textColor = .black
    l.font = Brandbook.font(size: 22, weight: .bold)
    l.numberOfLines = 3
    return l
  }()

  var continueButton : UIButton = {
    var b = UIButton()
    b.translatesAutoresizingMaskIntoConstraints = false
    b.backgroundColor = Brandbook.lightGray
    b.layer.cornerRadius = 55/2
    b.contentHorizontalAlignment = .center
    b.titleLabel?.font = Brandbook.font(size: 20, weight: .bold)
    b.setTitleColor(.white, for: .normal)
    b.setTitle("Continue", for: .normal)
    return b
  }()

  var restorePurchasesButton : UIButton = {
    var b = UIButton()
    b.translatesAutoresizingMaskIntoConstraints = false
    b.contentHorizontalAlignment = .center
    b.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    b.setTitleColor(Brandbook.lightGray, for: .normal)
    b.setTitle("Restore Purchases", for: .normal)
    return b
  }()

  var termsOfUseButton : UIButton = {
    var b = UIButton()
    b.contentHorizontalAlignment = .center
    b.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    b.setTitleColor(Brandbook.lightGray, for: .normal)
    b.setTitle("Terms of Use", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()

  var privacyPolicyButton : UIButton = {
    var b = UIButton()
    b.contentHorizontalAlignment = .center
    b.titleLabel?.font = Brandbook.font(size: 13, weight: .bold)
    b.setTitleColor(Brandbook.lightGray, for: .normal)
    b.setTitle("Privacy policy", for: .normal)
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()

  var bottomStackView : UIStackView = {
    var s : UIStackView = UIStackView()
    s.axis = .horizontal
    s.alignment = .fill
    s.distribution = .equalSpacing
    s.translatesAutoresizingMaskIntoConstraints = false
    return s
  }()

  var stackView : UIStackView = {
    var s : UIStackView = UIStackView()
    s.axis = .vertical
    s.alignment = .fill
    s.distribution = .equalSpacing
    s.translatesAutoresizingMaskIntoConstraints = false
    s.layer.zPosition = 0
    return s
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor  = .white
    setSubscriptioInfo()
  }

  func setView() {
    self.view.addSubview(stackView)
    stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    stackView.heightAnchor.constraint(equalToConstant: 270).isActive = true
    stackView.widthAnchor.constraint(equalToConstant: 310).isActive = true

    mainView.addSubview(mainLabel)
    mainLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
    mainLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
    mainLabel.topAnchor.constraint(equalTo:mainView.topAnchor , constant: 30).isActive = true
    mainLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -100).isActive = true

    mainView.addSubview(continueButton)
    continueButton.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
    continueButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    continueButton.widthAnchor.constraint(equalToConstant: 210).isActive = true
    continueButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -30).isActive = true
    let subscribeGesture = UITapGestureRecognizer(target: self, action:  #selector(self.subscribe))
    self.continueButton.addGestureRecognizer(subscribeGesture)

    mainView.layer.shadowColor = UIColor.black.cgColor
    stackView.addArrangedSubview(mainView)

    bottomStackView.addArrangedSubview(termsOfUseButton)
    let showTermsGesture = UITapGestureRecognizer(target: self, action:  #selector(self.showTerms))
    self.termsOfUseButton.addGestureRecognizer(showTermsGesture)

    bottomStackView.addArrangedSubview(restorePurchasesButton)
    let restorePurchasesGesture = UITapGestureRecognizer(target: self, action:  #selector(self.restorePurchasesTapped))
    self.restorePurchasesButton.addGestureRecognizer(restorePurchasesGesture)
    
    bottomStackView.addArrangedSubview(privacyPolicyButton)
    let showPrivacyPolicyGesture = UITapGestureRecognizer(target: self, action:  #selector(self.showPrivacyPolicy))
    self.privacyPolicyButton.addGestureRecognizer(showPrivacyPolicyGesture)
    stackView.addArrangedSubview(bottomStackView)
  }

  func setSubscriptioInfo() {
    self.hud.show(in: self.view)
    SwiftyStoreKit.retrieveProductsInfo([self.selected]) { result in
      for i in result.retrievedProducts {
        if i.productIdentifier == self.selected {
          self.mainLabel.text = "Your trial has ended,\ncontinue with\njust " + i.price.stringValue + i.priceLocale.currencySymbol! + "/Month"
        }
      }

      self.hud.dismiss()
      self.setView()
    }
  }


  @objc func subscribe(sender : UITapGestureRecognizer) {
    print("ok")
    self.hud.show(in: self.view)
    SwiftyStoreKit.purchaseProduct(self.selected, quantity: 1, atomically: false) { result in
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
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: print("Not allowed to make the payment")
        case .paymentCancelled: break
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: print("The device is not allowed to make the payment")
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
        default: print((error as NSError).localizedDescription)
        }
      }
    }
  }

  @objc func restorePurchasesTapped(sender : UITapGestureRecognizer) {
    self.hud.show(in: self.view)
    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Brandbook.sharedKey)
    SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
      switch result {
      case .success(let receipt):
        let productIds =  Set(Brandbook.subscriptions)
        let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
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

  @objc func showPrivacyPolicy(sender : UITapGestureRecognizer) {
    let url = URL(string: "https://maxidorov.github.io/Prompter-privacy-policy/")
    UIApplication.shared.open(url!)
  }

  @objc func showTerms(sender : UITapGestureRecognizer) {
    let url = URL(string: "https://dimazzziks.github.io/Prompter-terms-of-use/")
    UIApplication.shared.open(url!)
  }
}
