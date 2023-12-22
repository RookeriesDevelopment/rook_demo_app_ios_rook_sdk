//
//  HomeViewModel.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 21/12/23.
//

import Foundation
import RookSDK

class HomeViewModel: ObservableObject {
  
  private let syncManager: RookSummaryManger = RookSummaryManger()
  
  @Published var isLoading: Bool = false
  
  func syncYesterdaySummaries() {
    isLoading = true
    syncManager.syncYesterdaySummaries { [weak self] in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }
  
}
