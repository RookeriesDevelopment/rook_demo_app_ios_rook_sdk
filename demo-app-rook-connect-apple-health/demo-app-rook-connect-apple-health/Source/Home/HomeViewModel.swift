//
//  HomeViewModel.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 21/12/23.
//

import Foundation
import RookSDK
import RookAppleHealth

class HomeViewModel: ObservableObject {
  
  private let syncManager: RookSummaryManger = RookSummaryManger()
  
  @Published var isLoading: Bool = false
  @Published var backGroundText: String = ""
  
  

  func onAppear() {
    syncYesterdaySummaries()
    RookBackGroundExtraction.shared.isBackgroundEnable(for: .allSummariesBackGroundExtractionEnable) { [weak self] isEnable in
      DispatchQueue.main.async {
        self?.backGroundText = isEnable ? "Disable Background" : "Enable Background"
      }
    }
  }

  func syncYesterdaySummaries() {
    isLoading = true
    syncManager.syncYesterdaySummaries { [weak self] in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }

  func enableBackGround() {
    RookBackGroundExtraction.shared.isBackgroundEnable(for: .allSummariesBackGroundExtractionEnable) { [weak self] isEnable in
      DispatchQueue.main.async {
        if !isEnable {
          RookBackGroundSync.shared.enableBackGroundForSummaries()
          RookBackGroundSync.shared.enableBackGroundForActivityEvents()
          self?.backGroundText = "Disable Background"
        } else {
          RookBackGroundSync.shared.disableBackGroundForSummaries()
          RookBackGroundSync.shared.disableBackGroundForActivityEvents { _ in }
          self?.backGroundText = "Enable Background"
        }
      }
    }
  }
}
