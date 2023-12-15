//
//  BodyViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation
import RookAppleHealth
import RookSDK

class BodyViewModel: ObservableObject {
  
  private let extractioManager = RookExtractionManager()
  private let permissionManager = RookPermissionExtraction()
  private let syncManager: RookSummaryManger = RookSummaryManger()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var bodyData: RookBodyData?
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
  // MARK:  Helpers
  
  func requestBodyPermission() {
    self.isLoading = true
    permissionManager.requestBodyPermissions() { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(let success):
          debugPrint(success)
        case .failure(let error):
          debugPrint(error)
        }
      }
    }
  }
  
  func getBodyData() {
    
    extractioManager.getBodySummary(date: date) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          self?.bodyData = data
          debugPrint("body data \(data)")
        case .failure(let error):
          debugPrint("error while fecthing body \(error)")
        }
      }
    }
    self.syncSummary()
  }
  
  private func syncSummary() {
    self.isLoading = true
    syncManager.syncBodySummary(from: date) { [weak self] result in
      self?.handleResult(result: result)
    }
  }
  
  private func handleResult(result: Result<Bool, Error>) {
    DispatchQueue.main.async {
      switch result {
      case .success(_):
        self.message = "data was synchronized"
      case .failure(let error):
        self.message = "Error while storing summary \(error)"
      }
      self.isLoading = false
      self.showMessage = true
    }
  }
  
}
