//
//  HomeViewModel.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 21/12/23.
//

import Foundation
import RookSDK
import SwiftUI

struct OptionView {
  let title: String
  let view: any View
}

class HomeViewModel: ObservableObject {
  
  private let syncManager: RookSummaryManager = RookSummaryManager()
  private let dataSourceManager: DataSourcesManager = DataSourcesManager()
  private let eventManager: RookEventsManager = RookEventsManager()
  private let userManager: UserManager = UserManager()
  private var sleep: RookSleepSummary?

  @Published var isLoading: Bool = false
  @Published var user: String = ""
  @Published var currentSteps: String = "-"
  @Published var activeCalories: String = "-"
  @Published var sleepTime: String = "-"
  @Published var loadingSteps: Bool = false

  @Published var summariesStatusText: String = ""
  @Published var eventsStatusText: String = ""

  @Published var summariesStatusColor: String = "RedStatus"
  @Published var eventsStatusColor: String = "RedStatus"

  @Published var loadingSummariesBackgroundStatus: Bool = false
  @Published var loadingEventsBackgroundStatus: Bool = false


  func onAppear() {
    getData()
    syncYesterdaySummaries()
  }

  func syncYesterdaySummaries() {
    isLoading = true
    syncManager.sync() { [weak self] _ in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }

  func getData() {
    getSteps()
    getCalories()
    getSleep()
  }

  private func getSteps() {
    self.eventManager.getTodayStepCount { [weak self] result in
      DispatchQueue.main.async {
        self?.loadingSteps = false
        switch result {
        case .success(let steps):
          self?.currentSteps = "\(steps)"
        case .failure(let error):
          debugPrint("error while fetching steps \(error)")
        }
      }
    }
  }

  private func getCalories() {
    self.eventManager.getTodayCalories { [weak self] result in
      DispatchQueue.main.async {
        self?.loadingSteps = false
        switch result {
        case .success(let calories):
          if let activeCalories: Int = calories.activeCalories {
            self?.activeCalories = "\(activeCalories)"
          }
        case .failure(let error):
          debugPrint("error while fetching calories \(error)")
        }
      }
    }
  }

  private func getSleep() {
    if sleep == nil {
      syncManager.getSleepSummary(date: Date()) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let summaries):
          DispatchQueue.main.async {
            self.sleep = summaries.first(where: {
              $0.sleepDurationSeconds != nil
            })
            self.sleepTime = self.secondToHourMinute(summaries.first(where: {
              $0.sleepDurationSeconds != nil
            })?.sleepDurationSeconds ?? 0)
          }
        case .failure(let error):
          debugPrint("error while fetching sleep \(error)")
        }
      }
    }
  }

  private func secondToHourMinute(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let hours = minutes / 60
    let remainingMinutes = minutes % 60
    return String(format: "%02d:%02d", hours, remainingMinutes)
  }
}
