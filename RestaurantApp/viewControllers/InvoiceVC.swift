//
//  PreviousOrderDetailsViewController.swift
//  peAR_UIKit
//
//  Created by Preeti Chauhan on 11/06/20.
//  Copyright © 2020 peAR Technologies. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class InvoiceVC: UIViewController, UITableViewDelegate, UITableViewDataSource,NetworkInteractionDelegate {
    
    @IBOutlet weak var order_details_table: UITableView!
    
    var previous_order: PreviousOrders!
    
    var dict = [String:Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        order_details_table.layer.borderWidth = 2
        order_details_table.layer.borderColor = UIColor.black.cgColor
        
        setNavBar()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkCalls()
    }
    
    @IBAction func showMenu() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func networkCalls() {
        
        let network_call = NetworkBuilder()
        loader()
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.PREVIOUS_ORDER_DETAILS + previous_order.id, parameters: [:], requestID: Constant.REQUEST_ID.PREVIOUS_ORDER_DETAILS)
    }
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        stoploader()
        let jsonData = response.data
        dict.removeAll()
        do {
            dict = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            print(dict)
            order_details_table.reloadData()
            
        }catch (let error) {
            showError(msg: error.localizedDescription)
        }
    }
    
    func onFailure() {
        stoploader()
        print("Failure")
    }
    
    func notAuthorized() {
        stoploader()
        print("Not Authorized")
    }
    
    func noInternetConnectivity() {
        stoploader()
        print("No internet connectivity")
    }
    
    
    // MARK: - Table Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && ((dict["batch"] as? NSArray) != nil) {
            //get list of items
            
            let data = (dict["batch"] as! NSArray)[0] as! [String:Any]
        
            let count = (data["items"] as! NSArray).count
            
            return count
        }
        if (dict.count > 0) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //RestaurantDetailsTableViewCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailsCellId", for: indexPath) as? InvoiceCell else {
                fatalError("The dequeue cell is not an instance of PreviousOrderTableViewCell")
            }
  
            cell.name.text = dict["user_name"] as! String
            cell.table_no.text = (String(dict["table_id"] as! Int))
            cell.date.text = (dict["timestamp"] as! String)
           // cell.payment_mode.text = "Payment Mode :  \(dict["payment_type"] as! String)"
            
            cell.order_number.text = String(dict["oid"] as! Int)
            
            cell.resname.text = dict["restaurant_name"] as! String
            
            cell.address.text = dict["restaurant_location"] as! String
            
            cell.email.text = dict["user_email"] as! String
            
            cell.phone.text = dict["user_phone"] as! String
            
            cell.cid.text = dict["user_id"] as! String
            
            return cell
        case 1:
            //OrderItemsDetailsTableViewCell
            
            let data = (dict["batch"] as! NSArray)[0] as! [String:Any]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BillCellId", for: indexPath) as? OrderItemsDetailsTableViewCell else {
                fatalError("The dequeue cell is not an instance of PreviousOrderTableViewCell")
            }
            
            let items = (data["items"] as! NSArray)[indexPath.row] as! [String:Any]
            
            if (items.keys.contains("customisation")) {
            
                cell.customisation.text = items["customisation"] as? String
            }
            
            cell.category.text = items["category"] as! String
            
            
            cell.item_name.text = (items["name"] as! String)
            cell.quantity.text = String(items["quantity"] as! Int)
            cell.total_price.text = String(items["price"] as! Double + (items["optionPrice"] as! Double))
            //cell.jain_value.text = items[""] as! String
            
            return cell
            
            
        case 2:
            //OrderItemsDetailsTableViewCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalculationCellId", for: indexPath) as? BillDetailsTableViewCell else {
                fatalError("The dequeue cell is not an instance of PreviousOrderTableViewCell")
            }
            
            cell.sub_total.text = String(dict["sub_total"] as! Double)
            cell.discount_price.text = String(dict["total_discount"] as! Double)
            
            let tax = (dict["cgst"]  as! Double) + (dict["sgst"] as! Double)
            
            cell.taxes.text = String(tax)
            
            //cell.service_charge.text = String(dict["service_charge"] as! Double)
            
            cell.grand_total.text = String(dict["grand_total"] as! Double)
            
            cell.net_receivable.text = String(dict["grand_total"] as! Double)
            
            return cell
       
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            let header = Bundle.main.loadNibNamed("PrevHeader", owner: self, options: .none)![0] as! UIView
            
//            if (dict.count > 0) {
//                header.price.text = String(dict["grand_total"] as! Double)
//            }
            return header
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 330
        }else if (indexPath.section == 1 ) {
            return UITableView.automaticDimension
        } else {
            return 220
        }
    }
}

class InvoiceCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var resname: UILabel!
    @IBOutlet weak var cid: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var table_no: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var order_number: UILabel!
}


