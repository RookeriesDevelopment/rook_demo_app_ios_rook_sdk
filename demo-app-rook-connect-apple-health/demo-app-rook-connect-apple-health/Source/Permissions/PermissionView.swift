//
//  PermissionView.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 02/02/24.
//

import SwiftUI
import RookSDK

struct PermissionView: View {

  @StateObject var viewModel: PermissionViewModel

  var body: some View {
    VStack {
      if viewModel.isLoading {
        ProgressView()
      } else {
        Button(action: {
          viewModel.requestAllPermission()
        }, label: {
          Text("request Permissions")
            .frame(width: 250, height: 50)
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .background(Color.red)
            .cornerRadius(12)
            .padding(21)
        })
        
        NavigationLink(isActive: $viewModel.isActive,
                       destination: {
          HomeView()
            .navigationBarBackButtonHidden()
        }, label: {
          EmptyView()
        })
        
      }
    }.onAppear() {
      viewModel.requestAllPermission()
    }
  }
}

struct PermissionView_Previews: PreviewProvider {
  static var previews: some View {
    PermissionView(viewModel: PermissionViewModel())
  }
}
