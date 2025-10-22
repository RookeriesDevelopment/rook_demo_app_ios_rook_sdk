//
//  UserView.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 28/03/23.
//

import SwiftUI
import Combine

struct UserView: View {
  
  @StateObject var viewModel: UserViewModel = UserViewModel()
  @State private var keyboardHeight: CGFloat = 0
  
  var body: some View {
    NavigationView() {
      ZStack {
        Image("userBackground", bundle: Bundle.main)
          .resizable()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .scaledToFill()
          .ignoresSafeArea(.all)

        VStack {
          Spacer()
          VStack(spacing: 16.0) {
            Text("Get Started")
              .font(.title3)
              .fontWeight(.bold)
              .frame(maxWidth: .infinity, alignment: .leading)
              .multilineTextAlignment(.leading)
              .padding(.horizontal, 24)
              .padding(.top, 24)

            TextField("user id", text: $viewModel.userId)
              .padding(.horizontal, 12)
              .frame(height: 40)
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(Color.gray.opacity(0.4), lineWidth: 1)
              )
              .padding(.horizontal, 24)
              .padding(.top, 12)
            Button(action: {
              viewModel.addUser()
            }, label: {
              Text("Next ->")
                .frame(maxWidth: .infinity)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .padding(12)
                .background(Color(.greenButton))
                .padding(.horizontal, 25)
            })
            .disabled(!viewModel.isAddUserEnable || viewModel.loading)
            Spacer()
          }
          .frame(height: 253.0)
          .background(Color.white)
          .clipShape(RoundedCorner(radius: 16.0, corners: [.topLeft, .topRight]))
        }.onAppear() {
          viewModel.validateUserStored()
          viewModel.validateId()
        }
        NavigationLink(isActive: $viewModel.isUserStored,
                       destination: {
          HomeView()
            .navigationBarBackButtonHidden()
        }, label: {
          EmptyView()
        })
      }
      .padding(.bottom, keyboardHeight)
      .onReceive(Publishers.keyboardHeight) { height in
        keyboardHeight = height
      }
      .animation(.easeOut(duration: 0.3), value: keyboardHeight)
    }
    
  }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default
            .publisher(for: UIApplication.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 }

        let willHide = NotificationCenter.default
            .publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide).eraseToAnyPublisher()
    }
}
