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
    RookConnectConfigurationManager.shared.setConsoleLogAvailable(true)
    
    UNUserNotificationCenter.current().delegate = self
    PushNotificationManager.shared.listenerRequestNotification()
    
    RookBackGroundSync.shared.setBackListeners()
    handleEvents()
    return true
  }

  func handleEvents() {
    RookBackGroundSync.shared.handleSummariesUploaded = { [weak self] in
      let dateFormatterWithTime: DateFormatter = {
          let dateFormatter = DateFormatter()
          dateFormatter.calendar = Calendar(identifier: .gregorian)
          dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          return dateFormatter
      }()
      
      self?.scheduleLocalNotification(
        body: "\(dateFormatterWithTime.string(from: Date())) summaries uploaded",
        category: "summaries",
        type: "daily")
    }
  
    RookBackGroundSync.shared.handleActivityEventsUploaded = { [weak self] in
      let dateFormatterWithTime: DateFormatter = {
          let dateFormatter = DateFormatter()
          dateFormatter.calendar = Calendar(identifier: .gregorian)
          dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          return dateFormatter
      }()
      
      self?.scheduleLocalNotification(
        body: "\(dateFormatterWithTime.string(from: Date())) workouts uploaded",
        category: "events",
        type: "workouts")
    }
  }
  
  private func scheduleLocalNotification(body: String,
                                         category: String,
                                         type: String) {
    // Create Notification Content
    let notificationContent = UNMutableNotificationContent()
    
    // Configure Notification Content
    notificationContent.title = "Rook Health"
    notificationContent.subtitle = "local notification health"
    notificationContent.body = body
    notificationContent.categoryIdentifier = category
    notificationContent.sound = .defaultCritical
    
    // Add Trigger
    let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0,
                                                                repeats: false)
    
    // Create Notification Request
    let notificationRequest = UNNotificationRequest(identifier: "rook \(category) \(type) \(Date())",
                                                    content: notificationContent, trigger: notificationTrigger)
    
    // Add Request to User Notification Center
    UNUserNotificationCenter.current().add(notificationRequest) { (error) in
      if let error = error {
        print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
      }
    }
  }
}
