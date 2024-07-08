import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // تهيئة Firebase
        FirebaseApp.configure()

        // تهيئة Crashlytics
        Fabric.with([Crashlytics.self])

        // تهيئة Messaging
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }

        application.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // تهيئة رمز APNs لجهازك
        Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // تعامل مع رمز FCM
        print("FCM token: \(fcmToken ?? "")")
        // إذا كنت تريد إرسال الرمز إلى خادم التطبيقات الخاص بك...
    }

    // التعامل مع الرسائل الواردة
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    // أي تعاملات إضافية مع الرسائل يمكن إضافتها هنا إذا لزم الأمر
}
