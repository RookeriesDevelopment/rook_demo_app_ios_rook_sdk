//
//  DataSourceViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 12/07/23.
//

import Foundation
import Combine
@preconcurrency import RookSDK

final class DataSourceViewModel: ObservableObject {
  
  // MARK:  Properties
  private let dataSourceManager: DataSourcesManager = DataSourcesManager()
  var urlSelected: URL? = nil
  
  @Published var isLoading: Bool = false
  @Published var sources: [SourceItemViewModel] = []
  
  // MARK:  Helpers
  
  func getDataSourcesAvailable() {
    Task {
      isLoading = true
      do {
        let sources: [DataSourceStatus] = try await dataSourceManager.getDataSourcesAuthorizedV2(userId: nil)
        DispatchQueue.main.async {
          self.isLoading = false
          self.sources = self.mapSources(sources)
        }
      } catch {
        DispatchQueue.main.async {
          self.isLoading = false
        }
        debugPrint("error \(error)")
      }
    }
  }

  private func mapSources(_ rookSources: [DataSourceStatus]) -> [SourceItemViewModel] {
    return rookSources.map {
      SourceItemViewModel(sourceDTO: DataSourcesDTO(
        name: $0.name,
        description: String(),
        imageUrl: $0.imageUrl.absoluteString,
        connected: $0.authorized,
        authorizationURL: nil))
    }
  }
}
