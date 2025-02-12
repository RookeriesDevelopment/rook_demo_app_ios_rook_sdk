//
//  PhysicalViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation 
import RookSDK

class PhysicalViewModel: ObservableObject {
  
  // MARK:  Properties
  
  private let permissionManager: RookConnectPermissionsManager = RookConnectPermissionsManager()
  private let syncManager: RookSummaryManager = RookSummaryManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var physicalData: RookPhysicalData?
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
  // MARK:  Helpers
  
  func requestPhysicalPermission() {
    self.isLoading = true
    permissionManager.requestPhysicalPermissions() { [weak self] _ in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }
  
  func getPhysicalData() {
    syncPhysicalSummary()
  }
  
  private func syncPhysicalSummary() {
    self.isLoading = true
    syncManager.syncPhysicalSummary(from: date) { [weak self] result in
      
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
