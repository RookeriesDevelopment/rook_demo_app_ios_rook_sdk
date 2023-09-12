//
//  demo_app_rook_connect_apple_healthApp.swift
//  demo-app-rook-connect-apple-health
//
//  Created by Francisco Guerrero Escamilla on 21/08/23.
//

import SwiftUI

@main
struct demo_app_rook_connect_apple_healthApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      UserView()
    }
  }
}
