//
//  BodyViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation
import RookSDK

class BodyViewModel: ObservableObject {
  
  private let permissionManager: RookConnectPermissionsManager = RookConnectPermissionsManager()
  private let syncManager: RookSummaryManager = RookSummaryManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  @Published var bodyData: [[String: Any]] = []
  
  // MARK:  Helpers
  
  func requestBodyPermission() {
    self.isLoading = true
    permissionManager.requestPermissions(nil) { [weak self] result in
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
    
    self.syncSummary()
  }
  
  private func syncSummary() {
    self.isLoading = true
    syncManager.getBodySummary(date: date) { [weak self] result in
      self?.handleResult(result: result)
    }
  }
  
  private func handleResult(result: Result<RookBodySummary, Error>) {
    DispatchQueue.main.async {
      switch result {
      case .success(let summary):
        if let data: Data = try? JSONEncoder().encode(summary),
           let jsonObject: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
          self.bodyData = [jsonObject]
        }
        self.message = "data was synchronized"
      case .failure(let error):
        self.message = "Error while storing summary \(error)"
      }
      self.isLoading = false
      self.showMessage = true
    }
  }
  
}
