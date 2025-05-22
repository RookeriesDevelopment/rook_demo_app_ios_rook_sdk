//
//  SleepView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import SwiftUI
import RookSDK

struct SleepView: View {
  
  @StateObject var sleepVM: SleepViewModel = SleepViewModel()
  
  var body: some View {
    
    if (sleepVM.isLoading) {
      ProgressView()
        .foregroundColor(.red)
        .progressViewStyle(.circular)
    } else {
      VStack {
        
        Text("Sleep")
          .font(.system(size: 24, weight: .bold))
          .padding(12)
        
        Button(action: {
          sleepVM.getSleepPermissions()
        }, label: {
          Text("Request sleep Permissions")
        }).padding(20)
        
        DatePicker("date to fetch",
                   selection: $sleepVM.date,
                   displayedComponents: .date)
        .pickerStyle(.wheel)
        .padding(8)
        
        Button(action: {
          sleepVM.getSleepData()
        }, label: {
          Text("Sync sleep summary")
        }).padding(10)
        Spacer()
      }.alert(isPresented: $sleepVM.showMessage) {
        Alert(title: Text("Rook"),
              message: Text(sleepVM.message),
              dismissButton: .default(Text("Ok")) {
          sleepVM.showMessage = false
          sleepVM.message = ""
        })
      }
    }
  }
}

struct SleepView_Previews: PreviewProvider {
  static var previews: some View {
    SleepView()
  }
}
