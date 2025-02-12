//
//  CaloriesView.swift
//  RookSDKDemeApp
//
//  Created by Francisco Guerrero Escamilla on 11/02/25.
//

import SwiftUI

struct CaloriesView: View {

  @StateObject var viewModel: CaloriesViewModel = CaloriesViewModel()
    var body: some View {
      VStack {
        if viewModel.loading {
          ProgressView()
        } else {
          elements
        }
      }
    }

  var elements: some View {
    VStack {
      Text("Calories Extraction")
        .font(.title2)
        .padding(.top, 48)

      Button(action: {
        viewModel.syncCalories()
      }, label: {
        Text(" Get Today Calories")
          .frame(width: 200 , height: 40)
          .background(Color.gray)
          .foregroundColor(.white)
        
      })
      .padding(.vertical, 20)
      
      Text("Active calories \(viewModel.activeEnergy)")
      Text("Basal calories \(viewModel.basalEnergy)")

      Spacer()
    }
  }
}

struct CaloriesView_Previews: PreviewProvider {
  static var previews: some View {
    CaloriesView()
  }
}
