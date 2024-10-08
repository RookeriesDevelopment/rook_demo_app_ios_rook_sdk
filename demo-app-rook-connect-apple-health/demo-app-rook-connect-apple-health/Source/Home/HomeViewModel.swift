//
//  HomeViewModel.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 21/12/23.
//

import Foundation
import RookSDK

class HomeViewModel: ObservableObject {
  
  private let syncManager: RookSummaryManager = RookSummaryManager()
  private let dataSourceManager: DataSourcesManager = DataSourcesManager()
  private let eventManager: RookEventsManager = RookEventsManager()

  @Published var isLoading: Bool = false
  @Published var user: String = ""
  @Published var currentSteps: Int?
  @Published var loadingSteps: Bool = false

  @Published var summariesStatusText: String = ""
  @Published var eventsStatusText: String = ""

  @Published var summariesStatusColor: String = "RedStatus"
  @Published var eventsStatusColor: String = "RedStatus"

  @Published var loadingSummariesBackgroundStatus: Bool = false
  @Published var loadingEventsBackgroundStatus: Bool = false

  func onAppear() {
    getSteps()
    syncYesterdaySummaries()
    getBackgroundStatusEvents()
    getBackgroundStatusSummaries()
    RookConnectConfigurationManager.shared.getUserId { result in
      switch result {
      case .success(let userId):
        DispatchQueue.main.async {
          self.user = userId
        }
      case .failure:
        break
      }
    }
  }

  func syncYesterdaySummaries() {
    isLoading = true
    syncManager.syncSummaries { [weak self] in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }

  func showDataSourceView() {
    self.isLoading = true
    dataSourceManager.presentDataSourceView(redirectURL: nil) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }

  func getSteps() {
    DispatchQueue.main.async {
      self.currentSteps = 0
      self.loadingSteps = true
    }
    self.eventManager.getTodayStepCount { [weak self] result in
      DispatchQueue.main.async {
        self?.loadingSteps = false
        switch result {
        case .success(let steps):
          self?.currentSteps = steps
        case .failure(let error):
          debugPrint("error while fetching steps \(error)")
        }
      }
    }
  }

  func getBackgroundStatusSummaries() {
    if RookBackGroundSync.shared.isBackGroundForSummariesEnable() {
      DispatchQueue.main.async {
        self.summariesStatusText = "Enable"
        self.summariesStatusColor = "GreenStatus"
      }
    } else {
      DispatchQueue.main.async {
        self.summariesStatusText = "Disable"
        self.summariesStatusColor = "RedStatus"
      }
    }
  }

  func getBackgroundStatusEvents() {
    if RookBackGroundSync.shared.isBackGroundForEventsEnable() {
      DispatchQueue.main.async {
        self.eventsStatusText = "Enable"
        self.eventsStatusColor = "GreenStatus"
      }
    } else {
      DispatchQueue.main.async {
        self.eventsStatusText = "Disable"
        self.eventsStatusColor = "RedStatus"
      }
    }
  }
  
  func toggleSummariesBackgroundStatus() {
    self.loadingSummariesBackgroundStatus = true
    if RookBackGroundSync.shared.isBackGroundForSummariesEnable() {
      RookBackGroundSync.shared.disableBackGroundForSummaries()
      getBackgroundStatusSummaries()
    } else {
      RookBackGroundSync.shared.enableBackGroundForSummaries()
      getBackgroundStatusSummaries()
    }
    self.loadingSummariesBackgroundStatus = false
  }

  func toggleEventsBackgroundStatus() {
    self.loadingEventsBackgroundStatus = true
    if RookBackGroundSync.shared.isBackGroundForEventsEnable() {
      RookBackGroundSync.shared.disableBackGroundForEvents()
      self.getBackgroundStatusEvents()
      DispatchQueue.main.async {
        self.loadingEventsBackgroundStatus = false
      }
    } else {
      RookBackGroundSync.shared.enableBackGroundForEvents()
      getBackgroundStatusEvents()
      self.loadingEventsBackgroundStatus = false
    }
  }

}
