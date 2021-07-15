//
//  Extensions.swift
//  WeConnect
//
//  Created by mitesh Churi on 10/01/21.
//  Copyright © 2021 mitesh Churi. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    func colorPlaced () -> UIColor {
        return UIColor.init(red: 239/255, green: 63/255, blue: 108/255, alpha: 1)
    }
    
    func colorAccepted () -> UIColor {
        return UIColor.init(red: 113/255, green: 129/255, blue: 253/255, alpha: 1)
    }
    
    func colorGetBill () -> UIColor {
        return UIColor.init(red: 255/255, green: 164/255, blue: 13/255, alpha: 1)
    }
    
    func colorPaymentVeify () -> UIColor {
        return UIColor.init(red: 131/255, green: 88/255, blue: 237/255, alpha: 1)
    }
    
    func colorCompleted () -> UIColor {
        return UIColor.init(red: 1/255, green: 188/255, blue: 80/255, alpha: 1)
    }
    
}

extension UIViewController {
    
    
    func setNavBar () {
        let url = UserDefaults.standard.value(forKey: "photo_url") as! String
        
        let name = UserDefaults.standard.value(forKey: "name") as! String
        
        
        let view = Bundle.main.loadNibNamed("NavTitle", owner: self, options: .none)![0] as! NavTitle
        
        view.title.text = name
        
        view.img.sd_setImage(with: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!), completed: nil)
        
        self.navigationItem.titleView = view
    }
    
  
    func loader() {
        let loader = UIActivityIndicatorView.init(style: .whiteLarge)
        let dimView = UIView.init(frame: self.view.frame)
        dimView.tag = 26
        loader.tag = 25
        dimView.backgroundColor = .black
        dimView.alpha = 0.4
        DispatchQueue.main.async {
                
            
            loader.center = self.view.center
            
            
            self.view.addSubview(dimView)
            self.view.addSubview(loader)
            loader.startAnimating()
        }
    }
    
    func stoploader() {
        
        DispatchQueue.main.async {
            if let loader = self.view.viewWithTag(25) as? UIActivityIndicatorView {
            let dimView = self.view.viewWithTag(26) as? UIView
            
                dimView?.removeFromSuperview()
                loader.stopAnimating()
                loader.removeFromSuperview()
            }
        }
    }
 
    func showError(msg:String) {
        let alert = UIAlertController(title: "Error",message: msg, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion:  nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
        subview.backgroundColor = .white
    }
    
    func showErrorTitle(msg:String,title:String) {
        let alert = UIAlertController(title: title,message: msg, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion:  nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
        subview.backgroundColor = .white
    }
    
    func setTitle(_ nav_item: UINavigationItem) {
        let imageView = UIImageView(image: UIImage(named: "restaurantapp"))
        imageView.frame.size = CGSize(width: 45, height: 45)
        nav_item.titleView = imageView
        nav_item.titleView?.backgroundColor = .clear
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func isIntOrNot () -> Any {
        if self.rounded(.up) == self.rounded(.down){
            //number is integer
            return Int(self)
        }else{
            //number is not integer
            return self
        }
    }
}

extension Float {
    func isIntOrNot () -> Any {
        if self.rounded(.up) == self.rounded(.down){
            //number is integer
            return Int(self)
        }else{
            //number is not integer
            return self
        }
    }
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
