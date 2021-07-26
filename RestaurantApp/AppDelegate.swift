//
//  AppDelegate.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 15/02/21.
//

import UIKit
import CoreData
import Firebase
import UserNotificationsUI
import AVFoundation
import FirebaseMessaging
import FirebaseRemoteConfig
import Alamofire
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate,NetworkInteractionDelegate {
    
    

    var window: UIWindow?
    var timer:Timer?
    var remoteConfig = RemoteConfig.remoteConfig()
    //what 
    
    var audioPlayer: AVAudioPlayer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //FirebaseApp.configure()
        
        FirebaseApp.configure()
        
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        setupRemoteConfigDefaults()
        
        fetchRemoteConfig()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
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

        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        
        
        if ((UserDefaults.standard.value(forKey: "uid")) != nil) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "center")

            window!.rootViewController = vc
            
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func setupRemoteConfigDefaults() {
        let defaultValue = ["ios_version_restaurant": "2.0.2" as NSObject , "ios_update_required_restaurant":"true" as NSObject]
        remoteConfig.setDefaults(defaultValue)
    }
    
    func fetchRemoteConfig(){
        remoteConfig.fetch(withExpirationDuration: 20) { [unowned self] (status, error) in
            guard error == nil else { print("error now \(error!.localizedDescription)")
            return }
        print("Got the value from Remote Config!")
        remoteConfig.activate()
        self.displayNewValues()
    }}
   
    
   
    
    func displayNewValues(){
        let newLabelText = remoteConfig.configValue(forKey: "ios_version_restaurant").stringValue
        
        let isRequired = remoteConfig.configValue(forKey: "ios_update_required_restaurant").boolValue
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        
       
            if (version != newLabelText) {
                
                //CALL BACKGROUND API
                let network_call = NetworkBuilder()
                
                network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.SEND_VER, parameters: ["user_id":Auth.auth().currentUser!.uid , "app_version":newLabelText], requestID: 00)
                
                if (isRequired) {
                    let alertController = UIAlertController(title: "Update Required", message: "Please update your app", preferredStyle: .alert)
                    let action = UIAlertAction(title: "UPDATE", style: .cancel) { [self] (action) in
                        let appstoreUrl =  "itms-apps://itunes.apple.com/us/app/1551461688"
                        UIApplication.shared.openURL(URL(string: appstoreUrl)!)
                    }
                    alertController.addAction(action)
                    UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Update Required", message: "Please update your app", preferredStyle: .alert)
                    let action = UIAlertAction(title: "UPDATE", style: .default) { [self] (action) in
                        let appstoreUrl =  "itms-apps://itunes.apple.com/us/app/1551461688"
                        UIApplication.shared.openURL(URL(string: appstoreUrl)!)
                    }
                    
                    let action1 = UIAlertAction(title: "No thanks", style: .cancel) { [self] (action) in
                        alertController.dismiss(animated: true, completion: nil)
                    }
                    
                    alertController.addAction(action)
                    alertController.addAction(action1)
                    
                    UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
                }
            
        }
    }

    
    
    
    func registerAndPlaySound() {
        AudioServicesPlaySystemSound (1054)
    }
    
    //MARK: - FCM
    
    internal func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
//    func application(_ application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//        Messaging.messaging().apnsToken = deviceToken
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//
//    }
    
    func show(data:NSDictionary) {
        //creating the notification content
       let content = UNMutableNotificationContent()
       
       //adding title, subtitle, body and badge
        
        
        if (data["status"] as! String == "Order placed") {
            content.title = "Order Placed"
            content.body = data["message"] as! String
            content.sound = .default
            //content.badge = 1
        
       
       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
       
       //getting the notification request
       let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

        playLoopSound()
            
        if let vc = UIApplication.topViewController() {
                //do sth with root view controller
            if (vc.isKind(of: ViewController.self)) {
                print("in vc")
                (vc as! ViewController).refreshPage()
            }
        }
            
        }
        else {
            
                if let vc = UIApplication.topViewController() {
                        //do sth with root view controller
                    if (vc.isKind(of: ViewController.self)) {
                        print("in vc")
                        (vc as! ViewController).refreshPage()
                    }
                }
                }
            
    }
        
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notif response \(response.notification.request.content.userInfo)")
        if let timerMain = timer {
            timerMain.invalidate()
            timer = nil
        }
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if (UIApplication.shared.applicationState == .active) {
            show(data: userInfo as! NSDictionary)
            
        } else {
            
        let data = userInfo
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
         
         
         if (data["status"] as! String == "Order placed") {
             content.title = "Order Placed"
             content.body = data["message"] as! String
             content.sound = .default
            
         } else if (data["status"] as! String == "Order cancelled") {
            content.title = "Order Cancelled"
            content.body = data["message"] as! String
            content.sound = .default
            
        } else if (data["status"] as! String == "Batch cancelled") {
            content.title = "Batch Cancelled"
            content.body = data["message"] as! String
            content.sound = .default
            
        }
        else if (data["status"] as! String == "Item cancelled") {
            content.title = "Item Cancelled"
            content.body = data["message"] as! String
            content.sound = .default
            
        }
        else if (data["status"] as! String == "Bill requested") {
            content.title = "Bill requested"
            content.body = data["message"] as! String
            content.sound = .default
            
        }
        else if (data["status"] as! String == "OTP verification") {
            content.title = "OTP verification"
            content.body = data["message"] as! String
            content.sound = .default
            
        }
        else if (data["status"] as! String == "Card payment") {
            content.title = "Card payment"
            content.body = data["message"] as! String
            content.sound = .default
            
        }
        else if (data["status"] as! String == "Order accepted") {
            content.title = "Order accepted"
            content.body = data["message"] as! String
            content.sound = .default
            
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler:nil)
            
            self.playLoopSound()
            
       
        }
    }
    
    func playLoopSound () {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in

            self.registerAndPlaySound()

           // self.playSound()
        }
    }
            
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
      }
    
    //MARK: - Unity requirements
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
//        if isUnityRunning {
//            currentUnityController.applicationWillResignActive(application)
//        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        if isUnityRunning {
//            currentUnityController.applicationDidEnterBackground(application)
//        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        timer?.invalidate()
        

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let vc  = UIApplication.topViewController()
        
        if (vc!.isKind(of: ViewController.self)) {
            (vc as! ViewController).refreshPage()
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        
    }
    
    func onFailure() {
        
    }
    
    func notAuthorized() {
        
    }
    
    func noInternetConnectivity() {
        
    }
    
}


