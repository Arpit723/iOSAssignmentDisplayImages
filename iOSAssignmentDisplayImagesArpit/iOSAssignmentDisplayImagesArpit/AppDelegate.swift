//
//  AppDelegate.swift
//  iOSAssignmentDisplayImagesArpit
//
//  Created by Ravi Chokshi on 05/05/24.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = try! Reachability()
    var isConnectedToInternet = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setUpReachability()
        return true
    }
    
    func setUpReachability() {
        reachability.whenReachable = { reachability in
            self.isConnectedToInternet = true
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.isConnectedToInternet = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}

