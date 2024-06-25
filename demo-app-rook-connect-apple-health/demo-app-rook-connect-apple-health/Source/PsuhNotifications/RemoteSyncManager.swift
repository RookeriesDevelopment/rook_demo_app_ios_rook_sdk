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
  
  func updateSleepSummary(from date: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    if let date: Date = getDate(date: date) {
      
      summaryManager.syncSleepSummary(from: date) { [unowned self] result in
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        switch result {
        case .success(let success):
          completion(.success(success))
        case .failure(let error):
          completion(.failure(error))
        }
      }
      
      self.backgroundTask = UIApplication.shared.beginBackgroundTask {
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = UIBackgroundTaskIdentifier.invalid
      }
    } else {
      let error: Error = NSError(domain: "no domain", code: 0)
      completion(.failure(error))
    }
  }
  
  private func getDate(date: String) -> Date? {
    let dateFormat: DateFormatter = DateFormatter()
    dateFormat.dateFormat = "YYYY-MM-dd"
    
    return dateFormat.date(from: date)
  }
}
