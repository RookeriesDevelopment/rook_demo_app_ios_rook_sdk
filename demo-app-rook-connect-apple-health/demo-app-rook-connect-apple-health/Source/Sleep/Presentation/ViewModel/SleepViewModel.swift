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
  @Published var sleepData: [RookSleepData]?
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
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
    syncManager.syncSleepSummary(from: date) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(_):
          self?.message = "data was synchronized"
        case .failure(let error):
          self?.message = "Error while storing summary \(error)"
        }
        self?.isLoading = false
        self?.showMessage = true
      }
    }
  }
  
}
