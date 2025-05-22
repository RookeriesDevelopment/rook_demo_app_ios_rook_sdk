//
//  EventOxygenationViewModel.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 27/06/23.
//

import Foundation
import RookSDK

class EventOxygenationViewModel: ObservableObject {
  
  private let syncManager: RookEventsManager = RookEventsManager()

  var message: String = ""

  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  @Published var date: Date = Date()
  
  // MARK:  Helpers
  
  func getOxygenationEvents() {
    self.syncEvents()
  }
  
  private func syncEvents() {
    self.isLoading = true
    syncManager.syncEvents(date: date, eventType: .oxygenation) { [weak self] result in
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
