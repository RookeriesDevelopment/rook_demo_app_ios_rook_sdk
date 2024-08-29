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

      userStepsView
      
      statusBackgroundView

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

  private var userStepsView: some View {
    VStack {
      HStack {
        Text("user id \(viewModel.user)")
        if let steps: Int = viewModel.currentSteps {
          if viewModel.loadingSteps {
            ProgressView()
          } else {
            Spacer()
            Image(systemName: "figure.walk")
            Text("steps: \(steps)")
          }
        }
      }
      .padding(8)
      .onReceive(NotificationCenter.default.publisher(
        for: UIScene.willEnterForegroundNotification)) { _ in
          viewModel.getSteps()
          viewModel.getBackgroundStatusSummaries()
          viewModel.getBackgroundStatusEvents()
        }

      if viewModel.isLoading {
        HStack {
          Spacer()
          ProgressView()
            .progressViewStyle(.circular)
            .padding([.trailing], 12)
          Text("Synchronizing Summaries...")
          Spacer()
        }
        .frame(height: 44)
        .background(Color.gray)
        .cornerRadius(5)
        .padding(12)
      }
    }
  }

  private var statusBackgroundView: some View {
    VStack {
      HStack {
        Text("Background summaries")
          .padding(.horizontal, 8)
        
        if viewModel.loadingSummariesBackgroundStatus {
          ProgressView()
        } else {
          Button(action: {
            viewModel.toggleSummariesBackgroundStatus()
          }, label: {
            VStack {
              Text(viewModel.summariesStatusText)
                .padding(18)
                .foregroundColor(.white)
            }
            .frame(height: 24)
            .background(Color(viewModel.summariesStatusColor, bundle: nil))
            .cornerRadius(6)
          })
        }

        Spacer()
      }
      .padding(.vertical, 12)
      
      HStack {
        Text("Background events")
          .padding(.horizontal, 8)
        
        if viewModel.loadingEventsBackgroundStatus {
          ProgressView()
        } else {
          Button(action: {
            viewModel.toggleEventsBackgroundStatus()
          }) {
            VStack {
              Text(viewModel.eventsStatusText)
                .padding(18)
                .foregroundColor(.white)
            }
            .frame(height: 24)
            .background(Color(viewModel.eventsStatusColor, bundle: nil))
            .cornerRadius(6)
          }
        }

        Spacer()
      }
      .padding(.vertical, 12)
    }
  }
}
