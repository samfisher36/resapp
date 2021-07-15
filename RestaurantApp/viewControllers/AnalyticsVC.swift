//
//  AnalyticsVC.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 23/02/21.
//

import UIKit
import Alamofire
import CalendarDateRangePickerViewController

class AnalyticsVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,CalendarDateRangePickerViewControllerDelegate,NetworkInteractionDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var date_btn:UIButton!
    
    @IBOutlet weak var cview:UICollectionView!
    
    @IBOutlet weak var from:UIView!
    @IBOutlet weak var to:UIView!
    
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var btn2:UIButton!
    @IBOutlet weak var btn3:UIButton!
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    var start = ""
    var end = ""
    
    var dict = [String:Any]()
    var dict1 = [String:Any]()
    var dict2 = [String:Any]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (dict.count > 0 && dict1.count > 0 && dict2.count > 0) {
            return 8
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 6) {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! AnalyticsCell1
            cell.lbldetails.isHidden = false
            if (indexPath.row == 1) {
                cell.details_btn.isHidden = false
                cell.img_view.text = "B"
                cell.lblname.text = "Additions and deductions"
                
                if (dict["AAD"] as! Double >= 0) {
                    cell.lbldetails.textColor = .green
                }else {
                    cell.lbldetails.textColor = .red
                }
                
                cell.lbldetails.text = String((dict["AAD"] as! Double).rounded())
                //cell.lbldetails1.isHidden = true
                
            } else if (indexPath.row == 4) {
                
                cell.img_view.text = "E"
                cell.lblname.text = "Amount transferrable by peAR"
                
                if (dict["AT"] as! Double >= 0) {
                    cell.lbldetails.textColor = .green
                }else {
                    cell.lbldetails.textColor = .red
                }
                cell.details_btn.isHidden = false
                cell.lbldetails.text = String((dict["AT"] as! Double).rounded())
                //cell.lbldetails1.isHidden = true
            }
            
            else if (indexPath.row == 6) {
                
                cell.img_view.text = "G"
                cell.lblname.text = "Bank settlements (Bank UTRs)"
                
//                if (dict["AT"] as! Double >= 0) {
//                    cell.lbldetails.textColor = .green
//                }else {
//                    cell.lbldetails.textColor = .red
//                }
//                cell.details_btn.isHidden = false
//                cell.lbldetails.text = String((dict["AT"] as! Double).rounded())
                //cell.lbldetails1.isHidden = true
                cell.lbldetails.isHidden = true
            }
            
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.borderColor = UIColor.black.cgColor
            
            return cell
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! AnalyticsCell
        
        if (indexPath.row == 0) {
            cell.img_view.text = "A"
            cell.lblname.text = "Gross Revenue"
            cell.lbldetails.text = String((dict["gross_revenue"] as! Double).rounded())
            cell.lbldetails1.text = "No of orders : \(dict["NOO"]!)"
        }else if (indexPath.row == 2) {
            
            cell.img_view.text = "C"
            cell.lblname.text = "Net receivable (A+B)"
            cell.lbldetails.text = String((dict["net_revenue"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        }else if (indexPath.row == 3) {
            
            cell.img_view.text = "D"
            cell.lblname.text = "Amount received throught cash orders"
            
            cell.lbldetails.text = String((dict1["cod_total"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        }else if (indexPath.row == 5)  {
            
            cell.img_view.text = "F"
            cell.lblname.text = "Amount received throught card orders"
            
            cell.lbldetails.text = String((dict2["card_total"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        } else if (indexPath.row == 7)  {
            
            cell.img_view.text = "H"
            cell.lblname.text = "Average cart value"
            
            cell.lbldetails.text = String((dict2["card_total"] as! Double).rounded())
            cell.lbldetails1.isHidden = true
        }
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
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
                    self.cview.reloadData()
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
                    self.cview.reloadData()
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
                    self.cview.reloadData()
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
        
        
        
        let network_call = NetworkBuilder()
        loader()

        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_1 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_1)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_2 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_2)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_3 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_3)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sel1() {
        sel(choice: 1)
    }
    
    @IBAction func sel2() {
        sel(choice: 2)
    }
    
    @IBAction func sel3() {
        sel(choice: 3)
    }
    
    func sel(choice:Int) {
        
        var startDate:Date?
        var endDate:Date?
        
        if (choice == 1) {
            startDate = Date()
            endDate = Date()
            btn1.backgroundColor = UIColor.systemGreen
            btn1.setTitleColor(UIColor.white, for: .normal)
            btn2.setTitleColor(UIColor.black, for: .normal)
            btn3.setTitleColor(UIColor.black, for: .normal)
            btn2.backgroundColor = UIColor.clear
            btn3.backgroundColor = UIColor.clear
            
        }else if (choice == 2) {
            startDate = Date()
            endDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            
            btn2.backgroundColor = UIColor.systemGreen
            btn2.setTitleColor(UIColor.white, for: .normal)
            btn1.setTitleColor(UIColor.black, for: .normal)
            btn3.setTitleColor(UIColor.black, for: .normal)
            btn1.backgroundColor = UIColor.clear
            btn3.backgroundColor = UIColor.clear
            
            
        }else {
            startDate = Date()
            endDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
            
            btn3.backgroundColor = UIColor.systemGreen
            btn3.setTitleColor(UIColor.white, for: .normal)
            btn2.setTitleColor(UIColor.black, for: .normal)
            btn1.setTitleColor(UIColor.black, for: .normal)
            btn2.backgroundColor = UIColor.clear
            btn1.backgroundColor = UIColor.clear
        }
        
        dict.removeAll()
        dict1.removeAll()
        dict2.removeAll()
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDate1 = dateFormatter.string(from: startDate!)
        
        
        
        let endDate1 = dateFormatter.string(from: endDate!)
        
        
        dateFormatter.dateFormat = "MMM dd yyyy"
        let startDateStr = dateFormatter.string(from: startDate!)
        let endDateStr = dateFormatter.string(from: endDate!)
        
        lbl_from.text = startDateStr
        lbl_to.text = endDateStr
        
        let network_call = NetworkBuilder()
        loader()

        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_1 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_1)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_2 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_2)
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ANALYTICS_3 + "9999", parameters: ["endDate":endDate1,"startDate":startDate1], requestID: Constant.REQUEST_ID.ANALYTICS_3)
        
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
        
        btn1.layer.borderWidth = 1
        btn1.layer.borderColor = UIColor.black.cgColor
        
        btn2.layer.borderWidth = 1
        btn2.layer.borderColor = UIColor.black.cgColor
        
        btn3.layer.borderWidth = 1
        btn3.layer.borderColor = UIColor.black.cgColor
        
        
        
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
        setNavBar()
        designall()
        
        let network_call = NetworkBuilder()
        loader()


        sel(choice: 1)
        
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
