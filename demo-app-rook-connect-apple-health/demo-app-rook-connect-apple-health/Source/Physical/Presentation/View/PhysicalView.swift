//
//  PhysicalView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 06/03/23.
//

import SwiftUI
import RookSDK

struct PhysicalView: View {
  
  @StateObject var viewModel: PhysicalViewModel = PhysicalViewModel()
  
  var body: some View {
    VStack {
      
      Text("Physical")
        .font(.system(size: 24, weight: .bold))
        .padding(12)
      
      Button(action: {
        viewModel.requestPhysicalPermission()
      }, label: {
        Text("request physical Permissions")
      }).padding(20)
      
      DatePicker("date to fetch",
                 selection: $viewModel.date,
                 displayedComponents: .date)
      .pickerStyle(.wheel)
      .padding(8)
      
      Button(action: {
        viewModel.getPhysicalData()
      }, label: {
        Text("sync physical summary")
      })
      
      Spacer()
    }
    .alert(isPresented: $viewModel.showMessage) {
      Alert(title: Text("Rook"),
            message: Text(viewModel.message),
            dismissButton: .default(Text("Ok")) {
        viewModel.showMessage = false
        viewModel.message = ""
      })
    }
  }
}
