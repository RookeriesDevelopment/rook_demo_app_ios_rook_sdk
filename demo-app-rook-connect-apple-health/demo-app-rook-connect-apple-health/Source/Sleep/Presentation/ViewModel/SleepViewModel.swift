//
//  SleepViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation
import RookAppleHealth
import RookSDK

class SleepViewModel: ObservableObject {
  
  
  // MARK:  Properties
  
  private let extractioManager = RookExtractionManager()
  private let syncManager: RookSummaryManger = RookSummaryManger()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var sleepData: RookSleepData?
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
  // MARK:  Helpers
  
  func getSleepData() {
    extractioManager.getSleepSummary(date: date) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          self?.sleepData = data
          debugPrint("sleep data \(data)")
        case .failure(let error):
          debugPrint("error while fecthing sleep \(error)")
        }
      }
    }
    
    self.syncSleepData()
  }
  
  func getSleepPermissions() {
    isLoading = true
    let permissionManager = RookPermissionExtraction()
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
