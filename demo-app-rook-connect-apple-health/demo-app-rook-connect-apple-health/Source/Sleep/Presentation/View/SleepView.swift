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
  @State var showGranular: Bool = false

  
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

        DataView(viewModel: DataViewModel(dataModel: sleepVM.sleepData))
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

final class DataViewModel: ObservableObject {
  var dataModel: [[String: Any]]
  @Published var showGranular: Bool = false
  @Published var granular: [[String: Any]] = []
  
  init(dataModel: [[String : Any]]) {
    self.dataModel = dataModel
  }

  func getArrayOfKeys(dictionary: [String: Any]) -> [String] {
    return dictionary.map({ $0.key })
  }

  func getDateString(value: Any?) -> String {
    if let valueInt: Double = value as? Double {
      let date: Date = Date(timeIntervalSinceReferenceDate: valueInt)
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      return dateFormatter.string(from: date)
    } else {
      return "\(value ?? "-")"
    }
  }
}

struct DataView: View {

  @ObservedObject var viewModel: DataViewModel

  var body: some View {
    VStack {
      List {
        ForEach(Array(viewModel.dataModel.enumerated()), id: \.offset) { index, dictionary in
          Section {
            ForEach(Array(dictionary.keys.enumerated()), id: \.offset) { index, key in
              HStack {
                Text(key)
                  .font(.headline)
                Spacer()
                if let array = dictionary[key] as? [[String: Any]] {
                  Button(action: {
                    viewModel.showGranular.toggle()
                    viewModel.granular = array
                  }, label: {
                    Text("show granular \(key) ")
                  })
                } else {
                  if key.lowercased().contains("date") {
                    Text(viewModel.getDateString(value: dictionary[key]))
                      .font(.subheadline)
                  } else {
                    Text("\(dictionary[key] ?? "-")")
                      .font(.subheadline)
                  }
                }
              }
            }
          }
        }
      }
    }
    .sheet(isPresented: $viewModel.showGranular) {
      VStack {
        Text("Granular")
        List {
          ForEach(Array(viewModel.granular.enumerated()), id: \.offset) { index, item in
            ForEach(Array(item.keys.enumerated()), id: \.offset) { index, key in
              if key.lowercased().contains("date") {
                EmptyView()
              } else {
                HStack() {
                  Text(key.capitalized)
                    .font(.headline)
                  Spacer()
                  Text("\(item[key] ?? "-")")
                    .font(.subheadline)
                }
              }
            }
          }
        }
      }
    }
  }
}

struct SleepView_Previews: PreviewProvider {
  static var previews: some View {
    SleepView()
  }
}
