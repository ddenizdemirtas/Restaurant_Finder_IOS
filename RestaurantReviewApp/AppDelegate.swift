//
//  AppDelegate.swift
//  RestaurantReviewApp
//
//  Created by Deniz Demirtas on 6/28/22.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import VisilabsIOS


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Visilabs.createAPI(organizationId: "676D325830564761676D453D", profileId: "356467332F6533766975593D"
               , dataSource: "visistore", inAppNotificationsEnabled: true, channel: "IOS"
               , requestTimeoutInSeconds: 30, geofenceEnabled: true, maxGeofenceCount: 20, isIDFAEnabled: true)

    
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

