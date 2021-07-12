//
//  AnalyticsVC.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 23/02/21.
//

import UIKit
import Alamofire
import CalendarDateRangePickerViewController

class AnalyticsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CalendarDateRangePickerViewControllerDelegate,NetworkInteractionDelegate {
    
    @IBOutlet weak var date_btn:UIButton!
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var from:UIView!
    @IBOutlet weak var to:UIView!
    
    @IBOutlet weak var btn1:UIView!
    @IBOutlet weak var btn2:UIView!
    @IBOutlet weak var btn3:UIView!
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    var dict = [String:Any]()
    var dict1 = [String:Any]()
    var dict2 = [String:Any]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dict.count > 0 && dict1.count > 0 && dict2.count > 0) {
            return 6
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! AnalyticsCell
        
        cell.lbldetails1.isHidden = false
        cell.lbldetails.textColor = .black
        cell.details_btn.isHidden = true
        
        if (indexPath.row == 0) {
            cell.img_view.text = "A"
            cell.lblname.text = "Gross Revenue"
            cell.lbldetails.text = String((dict["gross_revenue"] as! Double).rounded())
            cell.lbldetails1.text = "No of orders : \(dict["NOO"]!)"
        } else if (indexPath.row == 1) {
            cell.details_btn.isHidden = false
            cell.img_view.text = "B"
            cell.lblname.text = "Additions and deductions"
            
            if (dict["AAD"] as! Double >= 0) {
                cell.lbldetails.textColor = .green
            }else {
                cell.lbldetails.textColor = .red
            }
            
            cell.lbldetails.text = String((dict["AAD"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
            
        } else if (indexPath.row == 2) {
            
            cell.img_view.text = "C"
            cell.lblname.text = "Net receivable (A+B)"
            cell.lbldetails.text = String((dict["net_revenue"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        }
        
        else if (indexPath.row == 3) {
            
            cell.img_view.text = "D"
            cell.lblname.text = "Amount received throught cash orders"
            
            cell.lbldetails.text = String((dict1["cod_total"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        }
        
        else if (indexPath.row == 4) {
            
            cell.img_view.text = "E"
            cell.lblname.text = "Amount transferrable by peAR"
            
            if (dict["AT"] as! Double >= 0) {
                cell.lbldetails.textColor = .green
            }else {
                cell.lbldetails.textColor = .red
            }
            cell.details_btn.isHidden = false
            cell.lbldetails.text = String((dict["AT"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        }
        else  {
            
            cell.img_view.text = "F"
            cell.lblname.text = "Amount received throught card orders"
            
            cell.lbldetails.text = String((dict2["card_total"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        }
    
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        DispatchQueue.main.async {
            self.stoploader()
        }
        
        switch requestId {
        case Constant.REQUEST_ID.ANALYTICS_1:
            let jsonData = response.data
            dict.removeAll()
            do {
                let array = try (JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! NSArray)
               
                if (array.count > 0) {
                    dict = array[0] as! [String:Any]
                    self.tableView.reloadData()
                }
                
                
            }catch (let error) {
                showError(msg: error.localizedDescription)
            }
            break
            
        case Constant.REQUEST_ID.ANALYTICS_2:
            let jsonData = response.data
            dict1.removeAll()
            do {
                let array = try (JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! NSArray)
               
                if (array.count > 0) {
                    dict1 = array[0] as! [String:Any]
                    self.tableView.reloadData()
                }
                
                
            }catch (let error) {
                showError(msg: error.localizedDescription)
            }
            break
            
        case Constant.REQUEST_ID.ANALYTICS_3:
            let jsonData = response.data
            dict2.removeAll()
            do {
                let array = try (JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! NSArray)
               
                if (array.count > 0) {
                    dict2 = array[0] as! [String:Any]
                    self.tableView.reloadData()
                }
                
                
            }catch (let error) {
                showError(msg: error.localizedDescription)
            }
            break
            
        default:
            break
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

    
    func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        
        dict.removeAll()
        dict1.removeAll()
        dict2.removeAll()
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDate1 = dateFormatter.string(from: startDate!)
        
        
        let newEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)
        let endDate1 = dateFormatter.string(from: newEndDate!)
        
        
        dateFormatter.dateFormat = "dd MMM"
        let startDateStr = dateFormatter.string(from: startDate!)
        let endDateStr = dateFormatter.string(from: endDate!)
        
        date_btn.setTitle(startDateStr + "-" + endDateStr, for: .normal)
        
        let network_call = NetworkBuilder()
        loader()

        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_1 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_1)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_2 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_2)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_3 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_3)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
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
    
    func designall() {
        from.layer.cornerRadius = 10
        from.clipsToBounds = true
        from.layer.borderWidth = 1
        
        to.layer.cornerRadius = 10
        to.clipsToBounds = true
        to.layer.borderWidth = 1
        
        btn1.layer.cornerRadius = 10
        btn1.clipsToBounds = true
       
        btn3.layer.cornerRadius = 10
        btn3.clipsToBounds = true
        
        btn2.layer.cornerRadius = 10
        btn2.clipsToBounds = true
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        designall()
        
        let network_call = NetworkBuilder()
        loader()


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let today = Date()
        let todayStr = dateFormatter.string(from: today)
        
        let todayDate = dateFormatter.date(from: todayStr)
        
        
        let endDate = Calendar.current.date(byAdding: .day,value: 7, to: today)
        
        let endDateStr = dateFormatter.string(from: endDate!)
  

        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_1 + "9999", parameters: ["endDate":"2020-12-22T18:29:59.000+0530","startDate":"2020-12-01T05:30:00.000+0530"], requestID: Constant.REQUEST_ID.ANALYTICS_1)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_2 + "9999", parameters: ["endDate":"2020-12-22T18:29:59.000+0530","startDate":"2020-12-01T05:30:00.000+0530"], requestID: Constant.REQUEST_ID.ANALYTICS_2)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_3 + "9999", parameters: ["endDate":"2020-12-22T18:29:59.000+0530","startDate":"2020-12-01T05:30:00.000+0530"], requestID: Constant.REQUEST_ID.ANALYTICS_3)
        
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
