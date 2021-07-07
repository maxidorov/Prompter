//
//  AppDelegate.swift
//  Prompter
//
//  Created by Maxim Sidorov on 19.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UserDefaults.standard.register(defaults: UserDefaults.applicationDefaults)

    let configuration = YMMYandexMetricaConfiguration.init(apiKey: ApiKeys.yandexMetrica)
    YMMYandexMetrica.activate(with: configuration!)

    return true
  }
}
