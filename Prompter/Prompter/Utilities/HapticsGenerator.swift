//
//  HapticsGenerator.swift
//  Prompter
//
//  Created by Maxim Sidorov on 24.04.2020.
//  Copyright © 2020 Maxim Sidorov. All rights reserved.
//

import UIKit

final class HapticsGenerator {
  private static let impact = UIImpactFeedbackGenerator(style: .medium)
  private static let selection = UISelectionFeedbackGenerator()
  private static let notification = UINotificationFeedbackGenerator()
  
  static func generateImpactFeedback() {
    DispatchQueue.main.async {
      self.impact.impactOccurred()
    }
  }
  
  static func generateSelectionFeedback() {
    DispatchQueue.main.async {
      self.selection.selectionChanged()
    }
  }
  
  static func generateNotificationFeedback(
    _ notificationType: UINotificationFeedbackGenerator.FeedbackType
  ) {
    DispatchQueue.main.async {
      self.notification.notificationOccurred(notificationType)
    }
  }
}
