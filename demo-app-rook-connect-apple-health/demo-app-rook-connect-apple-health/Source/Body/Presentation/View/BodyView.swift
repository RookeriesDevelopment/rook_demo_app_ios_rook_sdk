//
//  BodyView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import SwiftUI
import RookSDK

struct BodyView: View {
  
  @StateObject var viewModel: BodyViewModel = BodyViewModel()
  
  var body: some View {
    
    if (viewModel.isLoading) {
      ProgressView()
    } else {
      VStack {
        Text("Body")
          .font(.system(size: 24, weight: .bold))
          .padding(12)
        
        Button(action: {
          viewModel.requestBodyPermission()
        }, label: {
          Text("request body Permissions")
        }).padding(20)
        
        DatePicker("date to fetch",
                   selection: $viewModel.date,
                   displayedComponents: .date)
        .pickerStyle(.wheel)
        .padding(8)
        
        Button(action: {
          viewModel.getBodyData()
        }, label: {
          Text("sync Body summary")
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
}

struct BodyView_Previews: PreviewProvider {
  static var previews: some View {
    BodyView()
  }
}
