//
//  ActivityeventViewModel.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/07/23.
//

import Foundation
import RookSDK
import RookAppleHealth

class ActivityEventViewModel: ObservableObject {
  
  private let eventManager: RookExtractionEventManager = RookExtractionEventManager()
  private let syncEventsManager: RookEventsManager = RookEventsManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var activityEvents: [RookActivityEvent] = []
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
  // MARK:  Helpers
  
  func getLastExtractionDateTime() {
    guard let date: Date = eventManager.getLastExtractionDate(of: .activityEvent) else {
      return
    }
    
    debugPrint("last extraction activity \(date)")
  }
  
  
  func getActivityEvents() {
    eventManager.getActivityEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.activityEvents = events
        case .failure(let failure):
          self?.activityEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
    self.syncEvents()
  }
  
  private func syncEvents() {
    self.isLoading = true
    syncEventsManager.syncTrainingEvent(date: date) { [weak self] result in
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
