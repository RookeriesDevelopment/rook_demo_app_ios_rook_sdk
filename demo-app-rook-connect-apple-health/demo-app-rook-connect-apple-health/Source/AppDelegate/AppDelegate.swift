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
      clientUUID: "",
      secretKey: "") // Set your client uuid and your secrete key here.
    
    RookConnectConfigurationManager.shared.setEnvironment(.sandbox)
    
    RookConnectConfigurationManager.shared.initRook()
    
    UNUserNotificationCenter.current().delegate = self
    PushNotificationManager.shared.listenerRequestNotification()
    
    return true
  }
}
