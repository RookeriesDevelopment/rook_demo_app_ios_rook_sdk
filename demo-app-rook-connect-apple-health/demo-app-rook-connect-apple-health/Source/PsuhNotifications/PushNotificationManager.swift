//
//  PushNotificationManager.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 22/08/23.
//

import Foundation
import UserNotifications
import UIKit

class PushNotificationManager: NSObject {
  
  // MARK:  Properties
  
  static let shared: PushNotificationManager = PushNotificationManager()
  
  private var requestNotificationClosure: (() -> Void)?
  
  // MARK:  Helpers
  
  private override init() {
    
  }
  
  // MARK:  Methods
  
  func requestRegister() {
    requestNotificationClosure?()
  }
  
  func listenerRequestNotification() {
    self.requestNotificationClosure = { [unowned self] in
      self.registerForPushNotifications()
    }
  }
  
  
  private func registerForPushNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self]
      (granted, error) in
      self?.getNotificationSettings()
    }
  }
  
  private func getNotificationSettings() {
    
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      print("Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
  
}

extension PushNotificationManager: UNUserNotificationCenterDelegate {

}

extension AppDelegate {
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    print("Device Token: \(token)")
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(error)
  }
  
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("user info \(userInfo)")
    if let data: [String: String] = userInfo["data"] as? [String : String], let summary: String = data["summary"], let date: String = data["date"] {
      debugPrint("data \(data)")
    } else {
      print("no data")
      completionHandler(.noData)
    }
  }
}
