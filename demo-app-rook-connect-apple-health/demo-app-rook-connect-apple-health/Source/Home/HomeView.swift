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
    TabView {
      homeView
        .tabItem {
          Image(systemName: "house.fill")
        }

      settingView
        .tabItem {
          Image(systemName: "gear")
        }
    }
  }

  private var homeView: some View {
    VStack {
      Text("How your journey goes...")
        .font(.title3)
        .fontWeight(.bold)
        .padding(.horizontal, 24.0)
        .padding(.top, 24.0)
      Text("Move, rest, recharge and Repeat every day.")
        .padding(.horizontal, 24.0)
        .padding(.top, 4.0)

      HStack {
        HealthComponentView(imageName: "stepsIcon", value: $viewModel.currentSteps)
        HealthComponentView(imageName: "caloriesIcon", value: $viewModel.activeCalories)
      }
      .padding(.top, 18.0)
      HealthComponentView(imageName: "sleepIcon", value: $viewModel.sleepTime)
      Spacer()
    }.onAppear() {
      viewModel.onAppear()
    }
    .onChange(of: scenePhase) { newPhase in
      if newPhase == .active {
        viewModel.syncYesterdaySummaries()
        viewModel.getData()
      }
    }
  }

  private var settingView: some View {
    VStack {
      NavigationLink(destination: DataSourcesView(), label: {
        HStack {
          Text("Manage connections")
          Spacer()
          Image(systemName: "chevron.right")
        }
        .foregroundColor(.black)
      })
      .padding(.top, 24.0)
      VStack { }
        .frame(height: 1.0)
        .frame(maxWidth: .infinity)
        .background(Color.black)
      Button(action: {
        
      }, label: {
        HStack {
          Text("Log out")
          Spacer()
          Image(systemName: "rectangle.portrait.and.arrow.right")
        }
        .foregroundColor(.red)
      })
      VStack { }
        .frame(height: 1.0)
        .frame(maxWidth: .infinity)
        .background(Color.black)
      Spacer()
    }
    .padding(.horizontal, 24.0)
  }
}
