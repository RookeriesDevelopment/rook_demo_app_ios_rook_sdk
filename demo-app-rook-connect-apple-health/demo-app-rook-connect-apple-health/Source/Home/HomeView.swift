//
//  HomeView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 06/03/23.
//

import SwiftUI
import RookConnectTransmission
import RookSDK

struct HomeView: View {
  
  let user: String
  @StateObject var viewModel: HomeViewModel = HomeViewModel()
  @Environment(\.scenePhase) var scenePhase
  
  var body: some View {
    
    VStack {
      Text(user)
        .font(.system(size: 24, weight: .bold))
        .padding([.top], 12)
      
      if viewModel.isLoading {
        
        HStack {
          Spacer()
          ProgressView()
            .progressViewStyle(.circular)
            .padding([.trailing], 12)
          
          Text("Synchronizing yesterday Summaries...")
          Spacer()
        }
        .frame(height: 44)
        .background(Color.gray)
        .cornerRadius(5)
        .padding(12)
      }
      
      Spacer()
      
      List {
        
        NavigationLink(destination: {
          DataSourcesView()
        }, label: {
          Text("Data Sources Page")
        })
        
        NavigationLink(destination: {
          SleepView()
        }, label: {
          Text("Sleep")
        })
        
        NavigationLink(destination: {
          PhysicalView()
        }, label: {
          Text("Physical")
        })
        
        NavigationLink(destination: {
          BodyView()
        }, label: {
          Text("Body")
        })
        
        NavigationLink(destination: {
          EventHrView()
        }, label: {
          Text("Hr Events")
        })
        
        NavigationLink(destination: {
          EventOxygenationView()
        }, label: {
          Text("Oxygenation Events")
        })
        
        NavigationLink(destination: {
          ActivityEventView()
        }, label: {
          Text("Activity Events")
        })
        
      }
    }.onAppear() {
      PushNotificationManager.shared.requestRegister()
      RookConnectConfigurationManager.shared.syncUserTimeZone() { result in
        switch result {
        case .success(let success):
          debugPrint("success while uploading time zone \(success)")
        case .failure(let failure):
          debugPrint("error while uploading time zone \(failure)")
        }
      }
      viewModel.syncYesterdaySummaries()
    }
    .onChange(of: scenePhase) { newPhase in
      if newPhase == .active {
        viewModel.syncYesterdaySummaries()
      }
    }
  }
}
