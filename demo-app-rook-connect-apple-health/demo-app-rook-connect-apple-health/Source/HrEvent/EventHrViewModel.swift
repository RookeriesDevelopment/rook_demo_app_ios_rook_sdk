//
//  EventHrViewModel.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/06/23.
//

import Foundation
import RookSDK

final class EventHrViewModel: ObservableObject {
  
  // MARK:  Properties
  
  private let eventManager: RookExtractionEventManager = RookExtractionEventManager()
  private let syncEventsManager: RookEventsManager = RookEventsManager()
  
  var message: String = ""
  var eventTypes = ["Body", "Physical"]
  
  @Published var date: Date = Date()
  @Published var hrEvents: [RookHeartRateEventExtraction] = []
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  @Published var selectedType = "Body"
  
  // MARK:  Helpers
  
  func getAndSyncHrEvents() {
    if selectedType == "Body" {
      getHrBodyEvents()
    } else {
      getHrPhysicalEvents()
    }
    syncEvents()
  }
  
  private func getHrBodyEvents() {
    eventManager.getBodyHeartRateEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.hrEvents = events
        case .failure(let failure):
          self?.hrEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
  }
  
  private func getHrPhysicalEvents() {
    eventManager.getPhysicalHeartRateEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.hrEvents = events
        case .failure(let failure):
          self?.hrEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
  }
  
  private func syncEvents() {
    self.isLoading = true
    if selectedType == "Body" {
      syncEventsManager.syncBodyHeartRateEvent(date: date) { [weak self] result in
        self?.handleResult(result: result)
      }
    } else {
      syncEventsManager.syncPhysicalHeartRateEvent(date: date) { [weak self] result in
        self?.handleResult(result: result)
      }
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
