//
//  PreviousOrdersViewController.swift
//  peAR_UIKit
//
//  Created by Preeti Chauhan on 10/06/20.
//  Copyright © 2020 peAR Technologies. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController

import Alamofire
import FirebaseAuth
extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}

class PreviousOrdersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NetworkInteractionDelegate,UICollectionViewDelegateFlowLayout,CalendarDateRangePickerViewControllerDelegate {
    
    var previous_orders = [PreviousOrders]()
    @IBOutlet weak var no_orders: UILabel!
    @IBOutlet weak var previous_order_collection: UICollectionView!
    
    @IBOutlet weak var nav_item: UINavigationItem!
    
    @IBOutlet weak var dateBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItem?.target = self
    }
    
    @IBAction func showMenu() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)
        
        let startDateStr = dateFormatter.string(from: startDate!)
     
        let endDateStr = dateFormatter.string(from: endDate)
        
        
        
        dateFormatter.dateFormat = "dd MMM"
        let startDateStr1 = dateFormatter.string(from: startDate!)
        let endDateStr1 = dateFormatter.string(from: endDate)
        
        self.dateBtn.setTitle(startDateStr1 + "-" + endDateStr1, for: .normal)
        
        let network_call = NetworkBuilder()
        loader()

        // "RPrkkzB20OfeD1MZTn4MhlL5KWf2"
      
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.PREVIOUS_ORDERS + "9999", parameters: ["endDate":endDateStr,"startDate":startDateStr], requestID: Constant.REQUEST_ID.PREVIOUS_ORDERS)
        
        
        
    }
    
    //MARK: - Custom Functions
    
    func isHiddenNoOrders(hide: Bool) {
        previous_order_collection.isHidden = !hide
        no_orders.isHidden = hide
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - UICollectionView Functions

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previous_orders.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousOrderCell", for: indexPath) as? PreviousOrdersCollectionViewCell else {
            fatalError("The dequeue cell is not an instance of PreviousOrderTableViewCell")
        }
        
       // cell.width(370)
        
        //This creates the shadows and modifies the cards a little bit
        //cell.backgroundColor = UIColor.lightGray

        cell.layer.cornerRadius = 10.0
        
        //cell.addShadow(rounded: true)
        //cell.shadowDecorate()
        
        
        let pd = previous_orders[indexPath.row]
       
        cell.lbl_name.text = pd.user_name
        cell.lbl_oid.text = String(pd.order_id)
        cell.lbl_total.text = String(pd.grand_total)
        cell.lbl_status.text = pd.settlement_status
        cell.lbl_paymentMethod.text = pd.payment_type
        cell.lbl_orderedOn.text = pd.timestamp
        cell.lbl_netrec.text = String(pd.amount_transferrable)
        
        cell.delegate = self
        cell.previous_order = pd
        
        return cell
    }
    
    @IBAction func openDate () {
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        
        dateRangePickerViewController.selectedStartDate = Date()
        dateRangePickerViewController.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        dateRangePickerViewController.maximumDate = Date()
        
 
    
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        
        
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDate1 = dateFormatter.string(from: startDate!)
        
        
        let newEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)
        let endDate = dateFormatter.string(from: newEndDate!)
        
        dateFormatter.dateFormat = "dd MMM"
        let startDateStr1 = dateFormatter.string(from: startDate!)
        let endDateStr1 = dateFormatter.string(from: newEndDate!)
        
        self.dateBtn.setTitle(startDateStr1 + "-" + endDateStr1, for: .normal)
        
        
        let network_call = NetworkBuilder()
        loader()

        // "RPrkkzB20OfeD1MZTn4MhlL5KWf2"
      
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.PREVIOUS_ORDERS + "9999", parameters: ["endDate":endDate,"startDate":startDate1], requestID: Constant.REQUEST_ID.PREVIOUS_ORDERS)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Network Calls
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:previous_order_collection.frame.size.width * 0.98 , height: 320)
    }
    
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        stoploader()
        let jsonData = response.data
        
        previous_orders = try! JSONDecoder().decode([PreviousOrders].self, from: jsonData!)
        
        if(previous_orders.count == 0) {
            isHiddenNoOrders(hide: false)
        } else {
            isHiddenNoOrders(hide: true)
            previous_order_collection.reloadData()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SegueShowOrderDetails") {
            let orderDetailsVC = segue.destination as! PreviousOrderDetailsViewController
            orderDetailsVC.previous_order = sender as? PreviousOrders
        }
    }
    

}

extension PreviousOrdersViewController: PreviousOrdersCellDelegate {
    func onMoreDetails(_ sender: UIButton, previous_order: PreviousOrders) {
        performSegue(withIdentifier: "SegueShowOrderDetails", sender: previous_order)
    }
}

class PreviousOrdersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_oid: UILabel!
    @IBOutlet weak var lbl_orderedOn: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_paymentMethod: UILabel!
    @IBOutlet weak var lbl_netrec: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    
    var previous_order: PreviousOrders?
    var delegate: PreviousOrdersCellDelegate?
    
    @IBAction func onClickMoreDetails(_ sender: Any) {
        delegate?.onMoreDetails(sender as! UIButton, previous_order: previous_order!)
    }
}

protocol PreviousOrdersCellDelegate {
    func onMoreDetails(_ sender: UIButton, previous_order: PreviousOrders)
}
