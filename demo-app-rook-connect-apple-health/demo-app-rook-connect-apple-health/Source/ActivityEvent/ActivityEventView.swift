//
//  ActivityEventView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/07/23.
//

import SwiftUI
import Charts
import RookSDK

struct ActivityEventView: View {
  
  @StateObject var viewModel: ActivityEventViewModel = ActivityEventViewModel()
  
  var body: some View {
    
    if viewModel.isLoading {
      VStack {
        ProgressView()
      }
    } else {
      ScrollView {
        VStack {
          
          Text("Activity Events")
            .font(.system(size: 24, weight: .bold))
            .padding(12)
          
          DatePicker("date to sync",
                     selection: $viewModel.date,
                     displayedComponents: .date)
          .pickerStyle(.wheel)
          .padding(8)
          
          Button(action: {
            viewModel.getActivityEvents()
          }, label: {
            Text("sync Events")
              .foregroundColor(.white)
              .font(.system(size: 16, weight: .bold))
              .frame(width: 250, height: 50)
              .background(Color.red)
              .cornerRadius(12)
              .padding(21)
          })
          
        }
        .padding(12)
        .onAppear {
        }
      }
    }
  }
}
