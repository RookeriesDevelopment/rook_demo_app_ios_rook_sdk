//
//  ActivityeventViewModel.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/07/23.
//

import Foundation
import RookSDK

class ActivityEventViewModel: ObservableObject {
  
  private let syncEventsManager: RookEventsManager = RookEventsManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  @Published var eventsData: [[String: Any]] = []
  
  // MARK:  Helpers
  
  func getActivityEvents() {
    self.syncEvents()
  }
  
  private func syncEvents() {
    self.isLoading = true
    syncEventsManager.getActivityEvents(date: date) { [weak self] result in
      self?.handleResult(result: result)
    }
  }
  
  private func handleResult(result: Result<[RookActivityEvent], Error>) {
    DispatchQueue.main.async {
      switch result {
      case .success(let events):
        var physicalEvents: [[String: Any]] = []
        for event in events {
          if let data: Data = try? JSONEncoder().encode(event),
             let jsonObject: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            physicalEvents.append(jsonObject)
          }
        }
        self.eventsData = physicalEvents
        self.message = "data was synchronized"
      case .failure(let error):
        self.message = "Error while storing summary \(error)"
      }
      self.isLoading = false
      self.showMessage = true
    }
  }
  
}
