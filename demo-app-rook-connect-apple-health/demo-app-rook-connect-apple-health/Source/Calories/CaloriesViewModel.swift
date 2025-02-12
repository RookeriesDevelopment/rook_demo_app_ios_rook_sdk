//
//  CaloriesViewModel.swift
//  RookSDKDemeApp
//
//  Created by Francisco Guerrero Escamilla on 11/02/25.
//

import Foundation
import RookSDK

final class CaloriesViewModel: ObservableObject {
  
  // MARK:  Properties
  private let eventSyncManager: RookEventsManager = RookEventsManager()
  @Published var basalEnergy: String = ""
  @Published var activeEnergy: String = ""
  @Published var loading: Bool = false
  // MARK:  Helpers
  
  func syncCalories() {
    Task {
      do {
        loading = true
        let calories: RookCalories = try await eventSyncManager.getTodayCalories()
        DispatchQueue.main.async {
          self.loading = false
          self.basalEnergy = "\(calories.basalCalories ?? 0) kcal"
          self.activeEnergy = "\(calories.activeCalories ?? 0) kcal"
        }
        debugPrint("success calories \(calories)")
      } catch {
        DispatchQueue.main.async {
          self.loading = false
        }
        debugPrint("error sync calories \(error)")
      }
    }
  }
  
}

