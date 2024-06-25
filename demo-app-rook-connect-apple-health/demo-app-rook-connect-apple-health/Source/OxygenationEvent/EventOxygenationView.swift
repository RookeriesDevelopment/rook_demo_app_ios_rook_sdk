//
//  EventOxygenationView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 27/06/23.
//

import SwiftUI
import Charts
import RookSDK

struct EventOxygenationView: View {
  
  @StateObject var viewModel: EventOxygenationViewModel = EventOxygenationViewModel()
  
  var body: some View {
    
    if viewModel.isLoading {
      ProgressView()
    } else {
      ScrollView {
        VStack {
          
          Text("Oxygenation Events")
            .font(.system(size: 24, weight: .bold))
            .padding(12)
          
          DatePicker("date to fetch",
                     selection: $viewModel.date,
                     displayedComponents: .date)
          .pickerStyle(.wheel)
          .padding(8)
          
          HStack {
            Picker("Please choose a type", selection: $viewModel.selectedType) {
              ForEach(viewModel.eventTypes, id: \.self) {
                Text($0)
              }
            }
            Spacer()
            Text("\(viewModel.selectedType)")
          }
          
          Button(action: {
            viewModel.getOxygenationEvents()
          }, label: {
            Text("Get Events")
              .foregroundColor(.white)
              .font(.system(size: 16, weight: .bold))
              .frame(width: 250, height: 50)
              .background(Color.red)
              .cornerRadius(12)
              .padding(21)
          })
          
          EventListSaturation(events: viewModel.oxygenationEvents)
            .frame(height: 230)
          
        }
        .padding(12)
        .onAppear {
          viewModel.getLastExtractionDateTime()
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
}

struct EventListSaturation: View {
  
  var events: [RookOxygentationEvent] = []
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack{
        ForEach(events, id: \.metadata.datetime) { event in
          VStack {
            
            Text("saturation Avg \(event.oxygenationData.saturationAvgPercentage ?? 0)")
            
            Text("Vo2 Max \(event.oxygenationData.vo2MaxMlPerMinPerKg ?? 0)")
            
            if #available(iOS 16.0, *) {
              Chart(event.oxygenationData.saturationGranularDataPercentage ?? [], id: \.datetime) { granular in
                RectangleMark(
                  x: .value("time",
                            "\(granular.datetime)"),
                  y: .value("BPM",
                            granular.saturationPercentage)
                )
              }
            }
          }
          .frame(width: 350)
        }
      }
    }
  }
}
