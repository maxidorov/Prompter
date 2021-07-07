//
//  Analytics.swift
//  Prompter
//
//  Created by Maxim V. Sidorov on 7/6/21.
//  Copyright © 2021 Maxim Sidorov. All rights reserved.
//

import Foundation
import YandexMobileMetrica

enum AnalyticsEvent {
  private struct AnalyticsInfo {
    let params: [String: Any]?
  }

  case mainScreenLoaded // logged
  case newNoteCreated // logged
  case openNote // logged
  case closeNote(symbolsCount: Int, timeSpent: TimeInterval) // logged
  case deleteNote(symbolsCount: Int) // logged
  case openCamera // logged
  case closeCamera(timeSpent: TimeInterval) // logged
  case openSettings // logged
  case closeSettings // logged
  case openShareDialogue // logged
  // cases with subscription

  var name: String {
    switch self {
    case .mainScreenLoaded:
      return "MAIN_SCREEN_LOADED"
    case .newNoteCreated:
      return "NEW_NOTE_CREATED"
    case .openNote:
      return "OPEN_NOTE"
    case .closeNote:
      return "CLOSE_NOTE"
    case .deleteNote:
      return "DELETE_NOTE"
    case .openCamera:
      return "OPEN_CAMERA"
    case .closeCamera:
      return "CLOSE_CAMERA"
    case .openSettings:
      return "OPEN_SETTINGS"
    case .closeSettings:
      return "CLOSE_SETTINGS"
    case .openShareDialogue:
      return "OPEN_SHARE_DIALOGUE"
    }
  }

  var metaData: String? {
    switch self {
    case .mainScreenLoaded,
         .newNoteCreated,
         .openNote:
      return nil
    case let .closeNote(symbolsCount, timeSpent):
      return "Symbols count: \(symbolsCount), timeSpent: \(timeSpent)"
    case let .deleteNote(symbolsCount):
      return "Symbols count: \(symbolsCount)"
    case .openCamera:
      return nil
    case let .closeCamera(timeSpent):
      return "TimeSpent: \(timeSpent)"
    case .openSettings,
         .closeSettings:
      return nil
    case .openShareDialogue:
      return nil
    }
  }
}

class AnalyticsTracker {

  static let shared = AnalyticsTracker()

  private init() { }

  func track(_ event: AnalyticsEvent) {
    print(event.name)
    if let metadata = event.metaData {
      print(metadata)
    }
    let reportString = event.name + event.metaData
    YMMYandexMetrica.reportEvent(reportString)
  }
}

extension AnalyticsTracker: NSCopying {
  func copy(with zone: NSZone? = nil) -> Any {
    self
  }
}
