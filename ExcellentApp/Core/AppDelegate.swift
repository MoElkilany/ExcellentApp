//
//  AppDelegate.swift
//  ExcellentApp
//
//  Created by Mohamed Elkilany on 4/6/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.Message_ID"
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyD3_R6vda3akvnGRSH0Gz9jzfkGD6eFKEk")
        
        LocalizationManager.shared.setAppInnitLanguage()
        LocalizationManager.shared.delegate = self
        
        IQKeyboardManager.shared.enable  = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let appLanguage = SplashVC()

        window?.rootViewController = appLanguage
        window?.makeKeyAndVisible()
        
//        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
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
        return true
    }
}

