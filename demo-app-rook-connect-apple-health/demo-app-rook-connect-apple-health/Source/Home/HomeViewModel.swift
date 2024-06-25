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

  func onAppear() {
    getSteps()
    syncYesterdaySummaries()
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
    dataSourceManager.presentDataSourceView { [weak self] result in
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

  func enableBackGround() {
    RookBackGroundSync.shared.enableBackGroundForSummaries()
    RookBackGroundSync.shared.enableBackGroundForEvents()
  }

  func disableBackGround() {
    RookBackGroundSync.shared.disableBackGroundForSummaries()
    RookBackGroundSync.shared.disableBackGroundForEvents()
  }
}
