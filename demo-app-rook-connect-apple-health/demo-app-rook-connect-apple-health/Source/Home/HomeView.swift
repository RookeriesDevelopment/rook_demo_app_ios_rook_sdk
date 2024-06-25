//
//  HomeView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 06/03/23.
//

import SwiftUI
import RookSDK

struct HomeView: View {
  
  @StateObject var viewModel: HomeViewModel = HomeViewModel()
  @Environment(\.scenePhase) var scenePhase
  
  var body: some View {
    VStack {

      HStack {
        Text(viewModel.user)
          .font(.system(size: 14, weight: .bold))

        if let steps: Int = viewModel.currentSteps {
          if viewModel.loadingSteps {
            ProgressView()
          } else {
            Spacer()
            Image(systemName: "figure.walk")
            Text("current steps: \(steps)")
          }
        }
      }
      .padding(8)

      Button(action: {
        viewModel.enableBackGround()
      }, label: {
        Text("Enable backGround")
          .frame(width: 250, height: 50)
          .foregroundColor(.white)
          .font(.system(size: 16, weight: .bold))
          .background(Color.red)
          .cornerRadius(12)
          .padding(21)
      })

      Button(action: {
        viewModel.disableBackGround()
      }, label: {
        Text("Disable backGround")
          .frame(width: 250, height: 50)
          .foregroundColor(.white)
          .font(.system(size: 16, weight: .bold))
          .background(Color.red)
          .cornerRadius(12)
          .padding(21)
      })
      
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

      Button(action: {
        viewModel.showDataSourceView()
      }, label: {
        Text("Data Sources Page")
          .frame(width: 250, height: 35)
          .foregroundColor(.white)
          .font(.system(size: 14, weight: .bold))
          .background(Color.red)
          .cornerRadius(12)
          .padding(21)
      })

      Spacer()
      
      List {
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
      viewModel.onAppear()
    }
    .onChange(of: scenePhase) { newPhase in
      if newPhase == .active {
        viewModel.syncYesterdaySummaries()
        viewModel.getSteps()
      }
    }
  }
}
