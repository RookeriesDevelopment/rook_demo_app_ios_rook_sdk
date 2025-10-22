//
//  DataSourcesView.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 13/07/23.
//

import SwiftUI
import RookSDK

struct DataSourcesView: View {
  
  @StateObject var viewModel: DataSourceViewModel = DataSourceViewModel()
  @State var isSourcePagePresented: Bool = false
  
  var body: some View {
    VStack {
      if (viewModel.isLoading) {
        ProgressView()
      } else {
        Text("Get the value of your data")
          .font(.title3)
          .fontWeight(.bold)
          .padding(.horizontal, 24.0)
          .padding(.top, 24.0)
        List(viewModel.sources) { item in
          Button(action: {
            if !checkAppleHealth(item: item) {
              self.viewModel.urlSelected = item.urlConnect
              self.isSourcePagePresented = true
            }
          }, label: {
            ButtonSourceView(viewModel: item)
          })
        }
        .listStyle(.plain)
      }
    }.onAppear {
      viewModel.getDataSourcesAvailable()
    }
    .sheet(isPresented: $isSourcePagePresented, onDismiss: {
      viewModel.getDataSourcesAvailable()
    }) {
      DataSourcePageView(viewModel: DatasourceWebViewModel(dataSourceURL: viewModel.urlSelected))
    }
  }

  private func checkAppleHealth(item: SourceItemViewModel) -> Bool {
    if item.name.lowercased().contains("apple") {
      RookConnectPermissionsManager().requestAllPermissions { _ in }
      return true
    }
    return false
  }
}

struct DataSourcesView_Previews: PreviewProvider {
  static var previews: some View {
    DataSourcesView()
  }
}
