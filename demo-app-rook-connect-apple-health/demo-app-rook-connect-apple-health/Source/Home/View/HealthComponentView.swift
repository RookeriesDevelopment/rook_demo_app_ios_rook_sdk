//
//  ComponentView.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 28/09/25.
//

import SwiftUI

struct HealthComponentView: View {

  let imageName: String
  @Binding var value: String

  var body: some View {
    VStack {
      Image(imageName, bundle: .main)
      Text(value)
    }
    .frame(width: 136, height: 136)
    .background(Color(.cardView))
    .cornerRadius(12.0)
  }
}
