//
//  DataSourceViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 12/07/23.
//

import Foundation
import Combine
import RookSDK
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
        let sources: [DataSourceStatus] = try await dataSourceManager.getAuthorizedDataSources()
        DispatchQueue.main.async {
          self.isLoading = false
          self.sources = sources.map {
            SourceItemViewModel(sourceDTO: DataSourcesDTO(
              name: $0.source,
              description: String(),
              imageUrl: $0.imageURL.absoluteString,
              connected: $0.status,
              authorizationURL: nil))
          }
        }
      } catch {
        DispatchQueue.main.async {
          self.isLoading = false
        }
        debugPrint("error \(error)")
      }
    }
  }
}
