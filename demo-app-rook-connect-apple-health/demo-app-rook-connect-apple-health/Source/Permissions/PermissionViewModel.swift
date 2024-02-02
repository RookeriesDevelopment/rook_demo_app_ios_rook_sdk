//
//  PermissionViewModel.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 02/02/24.
//

import Foundation
import RookSDK

class PermissionViewModel: ObservableObject {

  let permissionsManager: RookConnectPermissionsManager = RookConnectPermissionsManager()

  var user: String = ""
  
  @Published var isLoading: Bool = false
  @Published var isActive: Bool = false
  
  init() { }

  func onAppear() {
    RookConnectConfigurationManager.shared.getUserId { [weak self] result in
      switch result {
      case .success(let userId):
        self?.user = userId
      case .failure:
        break
      }
    }
  }

  func requestAllPermission() {
    self.isLoading = true
    permissionsManager.requestAllPermissions { [weak self] _ in
      DispatchQueue.main.async {
        self?.isLoading = false
        self?.isActive = true
      }
    }
  }
}
