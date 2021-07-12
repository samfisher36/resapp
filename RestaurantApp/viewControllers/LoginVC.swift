//
//  LoginVC.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 03/03/21.
//

import UIKit
import Alamofire
import Firebase
import FirebaseMessaging

class LoginVC: UIViewController,NetworkInteractionDelegate,UITextFieldDelegate {
    
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        
        DispatchQueue.main.async {
            self.stoploader()
        }
    
        switch (requestId) {
        case Constant.REQUEST_ID.LOGIN :
            
        
            do {
                let dict =  try! JSONSerialization.jsonObject(with: response.data!, options: .mutableLeaves) as! [String:Any]
                
                let name  = dict["Name"] as! String
                let uid  = dict["_id"] as! String
                let photo_url  = dict["restaurant_image"] as! String
                
                UserDefaults.standard.setValue(name, forKey: "name")
                UserDefaults.standard.setValue(uid, forKey: "uid")
                UserDefaults.standard.setValue(photo_url, forKey: "photo_url")
                
                let network_call = NetworkBuilder()
                
                let parameters: [String: Any] = ["id":user.text!,"fcmid":Messaging.messaging().fcmToken]
                
                self.loader()
                
                network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.FCM_UPDTAE , parameters:parameters, requestID: Constant.REQUEST_ID.FCM_UPDTAE)
                
            }catch (let error) {
                showError(msg: error.localizedDescription)
            }
            
        case Constant.REQUEST_ID.FCM_UPDTAE :
            
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: "center")

            UIApplication.shared.keyWindow?.rootViewController = vc
            
            
        default:
        break
    
        }
    }
    
    func onFailure() {
        stoploader()
        showErrorTitle(msg: "PeAR", title: "Failure")
    }
    
    func notAuthorized() {
        stoploader()
        showErrorTitle(msg: "PeAR", title: "not Authorized")
    }
    
    func noInternetConnectivity() {
        stoploader()
        showErrorTitle(msg: "PeAR", title: "No internet")
    }
    
    
    @IBOutlet weak var user:UITextField!
    @IBOutlet weak var password:UITextField!
    
    
    @IBAction func forgot() {
        showErrorTitle(msg: "", title: "peAR")
    }
    
    
    @IBAction func login() {
        
        guard let uname = user.text,uname.count > 0 else {
            showError(msg: "Enter user name")
            return
        }
        
        guard let upass = password.text,upass.count > 0 else {
            showError(msg: "Enter password")
            return
        }
        
        let network_call = NetworkBuilder()
        
        let parameters: [String: Any] = ["ID":uname,"password":upass]
        
        loader()
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.LOGIN , parameters:parameters, requestID: Constant.REQUEST_ID.LOGIN)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
