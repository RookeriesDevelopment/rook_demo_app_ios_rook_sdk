//
//  AppDelegate.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import Foundation
import UIKit
import RookSDK

class ConfigurationManager {
  static let shared: ConfigurationManager = ConfigurationManager()
  
  var clientUUID: String = "" // Set your client uuid here
  var secreteKey: String = "" // Set your secrete key here.
  
  private init() { }
  
  
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    RookConnectConfigurationManager.shared.setConfiguration(
      clientUUID: ConfigurationManager.shared.clientUUID,
      secretKey: ConfigurationManager.shared.secreteKey)
    
    RookConnectConfigurationManager.shared.setEnvironment(.sandbox)
    
    RookConnectConfigurationManager.shared.initRook()
    
    UNUserNotificationCenter.current().delegate = self
    PushNotificationManager.shared.listenerRequestNotification()
    
    return true
  }
}
