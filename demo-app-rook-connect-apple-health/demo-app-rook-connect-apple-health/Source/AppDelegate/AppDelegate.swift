//
//  AppDelegate.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import Foundation
import UIKit
import RookSDK

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    RookConnectConfigurationManager.shared.setConfiguration(
      clientUUID: "9593d0ec-47c1-4477-a8ce-10d3f4f43127",
      secretKey: "YR9GoQ3mP0zey5nZ9w3WHQMvtvFvMdnefblx")
    
    RookConnectConfigurationManager.shared.setEnvironment(.sandbox)
    
    RookConnectConfigurationManager.shared.initRook()
    
    UNUserNotificationCenter.current().delegate = self
    PushNotificationManager.shared.listenerRequestNotification()
    
    return true
  }
}
