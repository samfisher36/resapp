//
//  NetworkManager.swift
//  peAR_Public
//
//  Created by mitesh Churi on 06/02/21.
//

import UIKit
import Alamofire

class NetworkManager:UIViewController {
    static let shared = NetworkManager()
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in

            switch status {
                            case .notReachable:
                                print("The network is not reachable")
                                self.showmsg()
                            case .unknown :
                                self.showmsg()
                            case .reachable(.ethernetOrWiFi):
                                print("The network is reachable over the WiFi connection")
                            case .reachable(.cellular):
                                print("The network is reachable over the cellular connection")
                      }
        })
    }
    
    func showmsg() {
        let alert = UIAlertController(title: "No internet",message: "Please check your internet connection", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
        subview.backgroundColor = .white
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
