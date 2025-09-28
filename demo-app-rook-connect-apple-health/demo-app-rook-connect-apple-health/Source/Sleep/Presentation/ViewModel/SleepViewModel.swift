//
//  SleepViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation
import RookSDK

class SleepViewModel: ObservableObject {
  
  
  // MARK:  Properties
  
  private let syncManager: RookSummaryManager = RookSummaryManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  @Published var sleepData: [[String: Any]] = []
  
  // MARK:  Helpers
  
  func getSleepData() {
    self.syncSleepData()
  }
  
  func getSleepPermissions() {
    isLoading = true
    let permissionManager: RookConnectPermissionsManager = RookConnectPermissionsManager()
    permissionManager.requestSleepPermissions() { [weak self] _ in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }
  
  func syncSleepData() {
    syncManager.getSleepSummary(date: date) { [weak self] result in
        switch result {
        case .success(let summaries):
          var sleepDictionaries: [[String: Any]] = []
          for summary in summaries {
            if let data: Data = try? JSONEncoder().encode(summary),
               let jsonObject: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
              sleepDictionaries.append(jsonObject)
            }
          }
          DispatchQueue.main.async {
            self?.sleepData = sleepDictionaries
            self?.message = "data was synchronized"
          }
        case .failure(let error):
          DispatchQueue.main.async {
            self?.message = "Error while storing summary \(error)"
          }
        }
      DispatchQueue.main.async {
        self?.isLoading = false
        self?.showMessage = true
      }
    }
  }
  
}
