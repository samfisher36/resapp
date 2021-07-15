//
//  LeadeboardVC.swift
//  RestaurantApp
//
//  Created by Mitesh Churi on 14/07/21.
//

import UIKit
import Alamofire

class LeadeboardVC: UIViewController,NetworkInteractionDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var container:UIView!
    
    var arr = [[String:Any]]()
    
    @IBOutlet weak var img1:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var img3:UIImageView!
    
    @IBOutlet weak var l1:UILabel!
    @IBOutlet weak var l2:UILabel!
    @IBOutlet weak var l3:UILabel!
    
    @IBOutlet weak var rank:UILabel!
    
    
    var response_data:[String:Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavBar()
        
        img1.layer.cornerRadius = img1.frame.size.height/2
        img1.clipsToBounds = true
        img2.layer.cornerRadius = img2.frame.size.height/2
        img2.clipsToBounds = true
        img3.layer.cornerRadius = img3.frame.size.height/2
        img3.clipsToBounds = true
        
        container.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 20)
        
        networkCall()
    }
    
    func networkCall() {
        let network_call = NetworkBuilder()
        
        let parameters: [String: Any] = ["restaurant_id":9999]
        
        loader()
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.LEADERBOARD, parameters:parameters, requestID: Constant.REQUEST_ID.LEARBOARD)
    }
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        DispatchQueue.main.async {
            self.stoploader()
            
        }
        
        do {
            response_data =  try! JSONSerialization.jsonObject(with: response.data!, options: .mutableLeaves) as! [String:Any]
            
            let rank1 =  response_data!["currentRestaurantRank"] as! Int
            
            let total =  response_data!["totalNumberOfRestaurants"] as! Int
            
            rank.text = String(rank1) + "/" + String(total)
            
            
            arr  = response_data!["leaderBoard"] as! [[String:Any]]
            
            for index in 0 ... arr.count - 1 {
                
                let name  = arr[index]["Name"]  as! String
                
                let location  = arr[index]["Location"]  as! String
                
                let url  = arr[index]["restaurant_image"]  as! String
                
                let mainurl = URL(string: url)
                
                var urlStr = ""
                
                if (mainurl == nil) {
                    urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
                }
                else {
                    urlStr = url
                }
                
                
                
                if (index == 0) {
                    img2.sd_setImage(with: URL(string: urlStr), completed: nil)
                    l2.text = name  + "\n" +  location
                } else if (index == 1) {
                    img1.sd_setImage(with: URL(string: urlStr), completed: nil)
                    l1.text = name  + "\n" +  location
                } else {
                    img3.sd_setImage(with: URL(string: urlStr), completed: nil)
                    l3.text = name  + "\n" +  location
                }
            }
            self.tableView.reloadData()
            print(response_data)
            
        }catch {
            
        }
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! LeaderboardCell
        
        cell.srno.text = String(indexPath.row + 1)
        
        let name  = arr[indexPath.row]["Name"]  as! String
        
        let location  = arr[indexPath.row]["Location"]  as! String
        
        let url  = arr[indexPath.row]["restaurant_image"]  as! String
        
        let mainurl = URL(string: url)
        
        var urlStr = ""
        
        if (mainurl == nil) {
            urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        }
        else {
            urlStr = url
        }
        
        
        
        cell.img.sd_setImage(with: URL(string: urlStr), completed: nil)
        cell.name.text = name
        cell.location.text = location
        
        
        let life = arr[indexPath.row]["numberOfLifetimeOrders"]  as! Int
        let month = arr[indexPath.row]["numberOfCurrentMonthOrders"]  as! Int
        
        
        cell.comp.text = String(month)
        
        cell.lifetime.text =  String(life)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
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
    

}
