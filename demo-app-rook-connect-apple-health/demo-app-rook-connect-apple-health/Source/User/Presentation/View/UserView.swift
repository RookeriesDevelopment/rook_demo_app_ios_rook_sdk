//
//  UserView.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 28/03/23.
//

import SwiftUI

struct UserView: View {
  
  @StateObject var viewModel: UserViewModel = UserViewModel()
  
  var body: some View {
    NavigationView() {
      VStack {
        
        
        Text("Add your user")
          .padding(.top, 24)
        
        TextField("User id", text: $viewModel.userId)
          .frame(maxWidth: .infinity, minHeight: 40)
          .background(Color.gray)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .keyboardType(.emailAddress)
          .foregroundColor(.black)
          .font(.system(size: 16, weight: .medium))
          .cornerRadius(8)
          .padding([.leading, .trailing], 24)
          .padding(.bottom, 42)
        
        Spacer()
        
        if viewModel.isAddUserEnable && !viewModel.loading {
          
          Button(action: {
            viewModel.addUser()
          }, label: {
            Text("Add User")
              .frame(width: 250)
              .font(.system(size: 16, weight: .bold))
              .foregroundColor(.white)
              .padding(20)
              .background(Color.red)
              .cornerRadius(10)
          })
        }
        
        NavigationLink(isActive: $viewModel.isUserStored,
                       destination: {
          PermissionView(viewModel: PermissionViewModel()).navigationBarBackButtonHidden()
        }, label: {
          EmptyView()
        })
        
      }.onAppear() {
        viewModel.validateUserStored()
        viewModel.validateId()
      }
    }
    
  }
}
