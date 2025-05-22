//
//  RemoteSyncManager.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 22/08/23.
//

import Foundation
import RookSDK
import UIKit

final class RemoteSyncManger {
  
  static let shared: RemoteSyncManger = RemoteSyncManger()
  private let summaryManager: RookSummaryManager = RookSummaryManager()
  var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
  
  private func getDate(date: String) -> Date? {
    let dateFormat: DateFormatter = DateFormatter()
    dateFormat.dateFormat = "YYYY-MM-dd"
    
    return dateFormat.date(from: date)
  }
}
