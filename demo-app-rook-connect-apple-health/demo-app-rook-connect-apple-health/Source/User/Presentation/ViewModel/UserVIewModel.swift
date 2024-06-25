//
//  UserVIewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 15/08/23.
//

import Foundation
import Combine
import RookSDK

class UserViewModel: ObservableObject {
  
  // MARK:  Properties
  
  private let rookConfiguration: RookConnectConfigurationManager = RookConnectConfigurationManager.shared
  
  @Published var userId: String = ""
  @Published var isUserStored: Bool = false
  @Published var isAddUserEnable: Bool = false
  @Published var loading: Bool = false
  
  var id: String = ""
  
  var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
  
  // MARK:  init
  
  // MARK:  Helpers
  
  func addUser() {
    if !(userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
      loading = true
      rookConfiguration.updateUserId(userId) { [weak self] result in
        DispatchQueue.main.async {
          switch result {
          case .success(let success):
            
            debugPrint("success adding user \(success)")
            self?.id = self?.userId ?? ""
            self?.isUserStored = true
          case .failure(let failure):
            debugPrint("error adding user \(failure)")
          }
          self?.loading = false
        }
      }
    }
  }
  
  func validateUserStored() {
    rookConfiguration.getUserId() { [weak self] result in
      switch result {
      case .success(let id):
        self?.id = id
        self?.isUserStored = true
      case .failure(_):
        self?.isUserStored = false
      }
    }
  }
  
  func validateId() {
    $userId.sink { _ in
    } receiveValue: { [weak self] idUser in
      self?.isAddUserEnable = !(idUser.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }.store(in: &cancellables)
    
  }
  
}
