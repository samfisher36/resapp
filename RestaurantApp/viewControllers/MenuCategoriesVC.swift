//
//  MenuCategoriesVC.swift
//  RestaurantApp
//
//  Created by parth vora on 20/07/21.
//

import UIKit
import Alamofire


class MenuCategoriesVC: UIViewController,UITableViewDataSource,UITableViewDelegate,NetworkInteractionDelegate {
    

    @IBOutlet weak var tableView:UITableView!
    
    
    struct cellData {
        var opened = Bool()
        var title = String()
        var sectionData = [[String:Any]]()
    }
    
    var tableViewData = [cellData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let network_call = NetworkBuilder()
        
        let parameters: [String: Any] = [:]
        

        self.loader()
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.FINISH_ORDER , parameters:parameters, requestID: Constant.REQUEST_ID.FINISH_ORDER)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableViewData.count == 0) {
            return 0
        }
        
        
        if (tableViewData[section].opened == true) {
            return tableViewData[section].sectionData.count
        }else {
            return 0
        }
        
        
    }
    
    @IBAction func expand (sender:AnyObject) {
        
        var section = 0
        
        if (sender.isKind(of: UIButton.self)) {
            section = sender.tag
        } else   {
            let tap = sender as! UITapGestureRecognizer
            
            if (tap.view!.isKind(of: UILabel.self))
            {
                let lbl = tap.view as! UILabel
                section = lbl.tag
            } else {
                let view = tap.view as! UIView
                section = view.tag
            }
        }
        

        if (tableViewData[section].opened  == true) {
            tableViewData[section].opened = false
        }else {
            tableViewData[section].opened = true
        }
        
        
        let sections = IndexSet.init(integer:section)
        tableView.reloadSections(sections, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MenuCell1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let view = Bundle.main.loadNibNamed("MenuHeader", owner: self, options:.none)![0] as! MenuHeader
        
        
        view.tag = section
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(expand(sender:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer3)
        
        
        if (tableViewData[section].opened == true) {
            view.img.image = UIImage.init(systemName: "arrowtriangle.up.fill")
        }else {
            view.img.image = UIImage.init(systemName: "arrowtriangle.down.fill")
        }
        
        
        return view
            
       
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("MenuFooter", owner: self, options:.none)![0] as! MenuFooter
        
        
        return view
            
    }
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        
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
