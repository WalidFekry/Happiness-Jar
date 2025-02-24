import UIKit
import Flutter
import FirebaseMessaging
import UserNotifications
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
          // Initialize Messaging
          if #available(iOS 10.0, *) {
              UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                  options: authOptions,
                  completionHandler: {_, _ in })
          } else {
              let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
          }
          application.registerForRemoteNotifications()
          Messaging.messaging().delegate = self
          GeneratedPluginRegistrant.register(with: self)
          // Flutter local notification
          FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)}
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
