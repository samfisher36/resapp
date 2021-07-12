//
//  ViewController.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 15/02/21.
//

import UIKit
import Alamofire
import CalendarDateRangePickerViewController
import AVFoundation

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = CurrentOrders()
}

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NetworkInteractionDelegate,UITextFieldDelegate {
 
    
    
    
    var currentOrder =  [CurrentOrders()]
    
    var response_data:[Any]?

    
    @IBOutlet weak var lblHeaderName:UILabel!
    @IBOutlet weak var lblTable:UILabel!
    
    @IBOutlet weak var header:UIView!
    
    @IBOutlet weak var majorTableView:UITableView!
    
    var tableViewData = [cellData]()
    
    var orderId = ""
    
    
    func onSuccess(requestId: Int, response: AFDataResponse<Any>) {
        
        DispatchQueue.main.async {
            self.stoploader()
        }
        
        switch requestId {
        case Constant.REQUEST_ID.CURRENT_ORDER:
            currentOrder.removeAll()
            
            currentOrder = try! JSONDecoder().decode([CurrentOrders].self, from: response.data!)
            
            for i in currentOrder {
                tableViewData.append(cellData(opened: false, title: i.user_name, sectionData: i))
            }
            
            
            do {
                response_data =  try! JSONSerialization.jsonObject(with: response.data!, options: .mutableLeaves) as! [Any]
                
            }catch {
                
            }
            
            if (currentOrder.count > 0) {
                for index in 0...currentOrder.count - 1 {
                    if (currentOrder[index].status == "getbill" || currentOrder[index].status == "paymentcash" ||
                        currentOrder[index].status == "paymentcomplete"
                    || currentOrder[index].status == "paymentcard") {
                        var batchDict = Batch()
                        var itemsArray = [Item]()
                        for batch in  currentOrder[index].batch {
                            
                            for item in batch.items {
                                itemsArray.append(item)
                            }
                            batchDict.items = itemsArray
                        }
                        
                        currentOrder[index].batch = [batchDict]
                    }
                }
                
                
            }
            
            //CHECK IF OTP IS PRESENT
            let def = UserDefaults.standard
            if (currentOrder.count > 0) {
            for index in 0...currentOrder.count - 1 {
                
                if (currentOrder[index].status == "paymentcash") {
                     let otp = currentOrder[index].payment_otp
                    def.setValue(otp, forKey: String(index))
                    
                }
            }
            }
            self.majorTableView.reloadData()

            break
            
        case Constant.REQUEST_ID.ACCEPT_ORDER:
            print("accepted order")
            networkCall()
            break
            
            
        case Constant.REQUEST_ID.CANCEL_BATCH:
            print("CANCEL_BATCH")
            networkCall()
            break
            
            
        case Constant.REQUEST_ID.ORDER_CANCEL:
            print("ORDER_CANCEL")
            networkCall()
            break
            
            
        case Constant.REQUEST_ID.GENERATE_BILL:
            print("ORDER_CANCEL")
            networkCall()
            break
            
            
        case Constant.REQUEST_ID.PAYMENT_RECEIVED:
            print("PAYMENT_RECEIVED")
            networkCall()
            break
            
        case Constant.REQUEST_ID.FINISH_ORDER:
            print("FINISH_ORDER")
            networkCall()
            break
            
        case Constant.REQUEST_ID.SKIP_VERYFICATION:
            print("SKIP_VERYFICATION")
            networkCall()
            break
            
            
        case Constant.REQUEST_ID.VERIFY_OTP:
            print("VERIFY_OTP")
            networkCall()
            break
            
        case Constant.REQUEST_ID.CANCEL_ITEM:
            print("cancel item")
            networkCall()
            break
            
        case Constant.REQUEST_ID.ADD_ITEM:
            print("ADD ITEM")
            dismissView()
            networkCall()
            break
            
        default:
            showError(msg: "IN DEFAULT")
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableViewData.count == 0) {
            return 0
        }
        
        if (tableView == majorTableView) {
            if (tableViewData[section].opened == true) {
                return 1
            }else {
                return 0
            }
        }
        
        if (tableViewData[section].opened == true) {
            return tableViewData[tableView.tag].sectionData.batch[section].items.count
        }else {
            return 0
        }
        
        //return currentOrder[tableView.tag].batch[section].items.count
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
        majorTableView.reloadSections(sections, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == majorTableView) {
            
            
            if (tableViewData[indexPath.section].sectionData.status == "paymentcash") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! OrderCell
                
                //SET NAME AND TABLE NO
                
                let nameObj = tableViewData[indexPath.section].sectionData
                
                let headerTableNo = cell.viewWithTag(9999) as! UILabel
                
                let headerName = cell.viewWithTag(8888) as! UILabel
                
                headerTableNo.text = "Table " +  String(nameObj.table_id)
                
                headerName.text =  (nameObj.user_name) +  "(" + (nameObj.user_phone) + ")"
                
                
                //SET COLOR OF HEADER
                let headerView = cell.viewWithTag(7777)!
                headerView.backgroundColor = UIColor().colorPaymentVeify()
                
                let verify = cell.viewWithTag(1616) as! UIButton
                
                let skip_verify = cell.viewWithTag(1717) as! UIButton
                
                
                verify.addTarget(self, action: #selector(verifyOtp), for: .touchUpInside)
                
                skip_verify.addTarget(self, action: #selector(skipverifyOtp), for: .touchUpInside)
                
                
                
                cell.insideTableView.tag = indexPath.row
                
                cell.insideTableView.reloadData()
                cell.layoutSubviews()

                cell.layoutIfNeeded()
                
                
                cell.tag = indexPath.section
                
                
                return cell
            } else if (tableViewData[indexPath.section].sectionData.status == "paymentcomplete" || tableViewData[indexPath.section].sectionData.status == "paymentcard") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! OrderCell
                
                //SET NAME AND TABLE NO
                
                let nameObj = tableViewData[indexPath.section].sectionData
                
                let paymentIcon = cell.viewWithTag(7878) as! UIImageView
                
                if (currentOrder[indexPath.row].status == "paymentcard") {
                    paymentIcon.image = UIImage.init(named: "card-payment")
                } else {
                    paymentIcon.image = UIImage.init(named: "cash-payment")
                }
                
                let headerTableNo = cell.viewWithTag(9999) as! UILabel
                
                let headerName = cell.viewWithTag(8888) as! UILabel
                
                let finishBtn = cell.viewWithTag(1515) as! UIButton

                finishBtn.addTarget(self, action: #selector(finishedOrder), for: .touchUpInside)
                
                headerTableNo.text = "Table " +  String(nameObj.table_id)
                
                headerName.text =  (nameObj.user_name) +  "(" + (nameObj.user_phone) + ")"
                
                
                //SET COLOR OF HEADER
                let headerView = cell.viewWithTag(7777)!
                headerView.backgroundColor = UIColor().colorCompleted()
                
                
                cell.insideTableView.tag = indexPath.row
                
                cell.insideTableView.reloadData()
                
                cell.layoutSubviews()

                cell.layoutIfNeeded()
                
                cell.tag = indexPath.section
                
                
                return cell
            }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! OrderCell
            
            
            //SET NAME AND TABLE NO
            
            let nameObj = tableViewData[indexPath.section].sectionData
            
            let headerTableNo = cell.viewWithTag(9999) as! UILabel
            
            let headerName = cell.viewWithTag(8888) as! UILabel
            
            headerTableNo.text = "Table " +  String(nameObj.table_id)
            
            headerName.text =  (nameObj.user_name) +  "(" + (nameObj.user_phone) + ")"
            
            
            //SET COLOR OF HEADER
            let headerView = cell.viewWithTag(7777)!
            
            if (nameObj.status == "orderplaced") {
                headerView.backgroundColor = UIColor().colorPlaced()
            }
            else if (nameObj.status == "orderaccepted") {
                headerView.backgroundColor = UIColor().colorAccepted()
            }
            else if (nameObj.status == "getbill") {
                headerView.backgroundColor = UIColor().colorGetBill()
            }
            else if (nameObj.status == "paymentverify") {
                headerView.backgroundColor = UIColor().colorPaymentVeify()
            }
            else {
                headerView.backgroundColor = UIColor().colorCompleted()
            }

            
            cell.insideTableView.tag = indexPath.row
            
            cell.insideTableView.reloadData()
            
           
            cell.layoutSubviews()

            cell.layoutIfNeeded()
            
            cell.tag = indexPath.section
            
            
            return cell
            
        } else {

            var obj = Item()
            
            
            if (tableViewData[tableView.tag].sectionData.status == "paymentcash") {
                obj =   tableViewData[tableView.tag].sectionData.batch[0].items[indexPath.row]
            } else {
        
                obj =   tableViewData[tableView.tag].sectionData.batch[indexPath.section].items[indexPath.row]
            }

            var cell = OrdersItemCell()
                
            if (obj.customisation.count > 0 || obj.instructions.count > 3) {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! OrdersItemCell
                
                if (obj.instructions.count > 2) {
                    cell.lblNote.isHidden = false
                    cell.lblNoteShow.isHidden = false
                }else {
                    cell.lblNote.isHidden = true
                    cell.lblNoteShow.isHidden = true
                }
                
                if (obj.customisation.count > 2) {
                    cell.lblCust.isHidden = false
                    cell.lblCustShow.isHidden = false
                }else {
                    cell.lblCust.isHidden = true
                    cell.lblCustShow.isHidden = true
                }
                
            }
            else {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! OrdersItemCell
            }
                
            
            cell.layoutIfNeeded()
            cell.lblName.text = obj.name
            cell.lblCategory.text = obj.category
            cell.lblQty.text = String(obj.quantity)
            
            
            if (tableViewData[tableView.tag].sectionData.batch[indexPath.section].status == "orderaccepted") {
                
                let df = DateFormatter()
                df.dateFormat = "dd MM YYYY hh:mm:ss a"
                let date_str = df.date(from: String(tableViewData[tableView.tag].sectionData.batch[indexPath.section].timestamp))
                df.dateFormat = "hh:mm a"
                cell.lblPrice.text = df.string(from: date_str!)
                cell.btnRemove.isHidden = true
            } else {
                cell.btnRemove.isHidden = false
                cell.lblPrice.text = String(obj.price)
            }
            
            //CHECK IF WE NEED TO HIDE REMOVE BUTTON
            if (tableViewData[tableView.tag].sectionData.batch[indexPath.section].status == "orderaccepted" ||
                    
                    tableViewData[tableView.tag].sectionData.batch[indexPath.section].status == "paymentcash" ||
                    
                    tableViewData[tableView.tag].sectionData.batch[indexPath.section].status == "getbill" ||
                    
                    tableViewData[tableView.tag].sectionData.batch[indexPath.section].status == "paymentcomplete" || tableViewData[tableView.tag].sectionData.batch[indexPath.section].status == "paymentcard") {
                
                                cell.btnRemove.isHidden = true
                            }else {
                                
                                cell.btnRemove.isHidden = false
                            }
            
           
            
            
            //CHECK IF WE NEED TO HIDE REMOVE BUTTON
            if ( tableViewData[tableView.tag].sectionData.status == "paymentcash" ||
                    tableViewData[tableView.tag].sectionData.status == "getbill" ||
                    tableViewData[tableView.tag].sectionData.status == "paymentcomplete" || tableViewData[tableView.tag].sectionData.status == "paymentcard"){
                        cell.btnRemove.isHidden = true
                    }else {
                        
                        cell.btnRemove.isHidden = false
                        
                        //check for order cancel or batch cancel or item cancel
                        
                        let batchCount = tableViewData[tableView.tag].sectionData.batch.count
                        
                        let itemCount = tableViewData[tableView.tag].sectionData.batch[indexPath.section].items.count
                        
                        if (itemCount <= 1) {
                            cell.btnRemove.isHidden = true
                        }else {
                            cell.btnRemove.isHidden = false
                        }
                        
                    }
        
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            
            cell.btnRemove.addTarget(self, action: #selector(removeItem(sender:)), for: .touchUpInside)
            
            
            //CHECK VEG NON_VEG
            if (obj.item_type == "1") {
                cell.veg_icon.image  = UIImage.init(named: "veg")
            } else if (obj.item_type == "2") {
                cell.veg_icon.image  = UIImage.init(named: "non-veg")
            }
            else {
                cell.veg_icon.image  = UIImage.init(named: "egg")
            }
            cell.tag = indexPath.section
            cell.btnRemove.tag = indexPath.row
            
            
            //CUSTOMISATION OR NOTE
            if(obj.customisation.count > 0) {
                cell.lblCust.text = obj.customisation
                cell.lblCustShow.isHidden = false
                cell.lblCust.isHidden = false
            } else {
                //cell.lblCustShow.isHidden = true
                //cell.lblCust.isHidden = true
            }
            
            if(obj.instructions.count > 2) {
                
                cell.lblNote.text = obj.instructions
                //cell.lblNoteShow.isHidden = false
                //cell.lblNote.isHidden = false
            }
            else {
                //cell.lblNoteShow.isHidden = true
                //cell.lblNote.isHidden = true
            }
    
            return cell

        }
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == majorTableView) {
            var rows = 0
            var cust = 0
            var footerHeight = 0
            var headerHeight = 0
            var custHeight = 0
            var noteHeight = 0
            var paymentHeader = 0
            
            if (currentOrder[tableView.tag].batch.count <= 1) {
                for object in currentOrder[tableView.tag].batch[0].items {
                    
                    if (object.instructions.count > 2) {
                        cust = cust + 1
                        noteHeight = noteHeight + object.instructions.count
                    }
                    
                    if (object.customisation.count > 0) {
                        cust = cust + 1
                        custHeight = custHeight + object.customisation.count
                    }else {
                        rows = rows + 1
                    }
                    
                }
                
                headerHeight =  headerHeight + 50
                
                
                if (currentOrder[tableView.tag].status == "paymentcash" ||
                        currentOrder[tableView.tag].status == "paymentcomplete" || currentOrder[tableView.tag].status == "paymentcard") {
                    
                    paymentHeader =  paymentHeader + 200
                }
                
                if (currentOrder[tableView.tag].status == "getbill" ||
                        currentOrder[tableView.tag].status == "paymentcash" ||
                        currentOrder[tableView.tag].status == "paymentcomplete" || currentOrder[tableView.tag].status == "paymentcard") {
                    footerHeight = footerHeight + 350
                } else {
                    let index = 0
                    let batch_object =  currentOrder[tableView.tag].batch[index]
                    
                    if (batch_object.status == "orderaccepted") {
                        if (index == currentOrder[tableView.tag].batch.count-1) {
                            footerHeight = footerHeight + 250
                        } else {
                            footerHeight = footerHeight + 100
                        }
                        
                    } else if (batch_object.status == "orderplaced") {
                        if (index == currentOrder[tableView.tag].batch.count-1) {
                            footerHeight = footerHeight + 150
                        } else {
                            footerHeight = footerHeight + 100
                        }
                    }
                    else if (batch_object.status == "getbill") {
                        if (index == currentOrder[tableView.tag].batch.count-1) {
                            footerHeight = footerHeight + 250
                        }
                        return 0
                    }
                
            }
            }
            else {
                for index in 0 ... currentOrder[tableView.tag].batch.count - 1 {
                    for object in currentOrder[tableView.tag].batch[index].items {
                        
                        if (object.instructions.count > 2) {
                            cust = cust + 1
                            noteHeight = noteHeight + object.instructions.count
                        }
                        
                        
                        if (object.customisation.count > 0) {
                            cust = cust + 1
                            custHeight = custHeight + object.customisation.count
                        }else {
                            rows = rows + 1
                        }
                        
                    }
                    
                    headerHeight =  headerHeight + 50
                    
                    if (currentOrder[tableView.tag].status == "paymentcash" ||
                            currentOrder[tableView.tag].status == "paymentcomplete" || currentOrder[tableView.tag].status == "paymentcard") {
                        
                        paymentHeader =  paymentHeader + 200
                    }
                    
                    if (currentOrder[tableView.tag].status == "getbill" ||
                            currentOrder[tableView.tag].status == "paymentcash" ||
                            currentOrder[tableView.tag].status == "paymentcomplete" || currentOrder[tableView.tag].status == "paymentcard") {
                        footerHeight = footerHeight + 350
                    } else {
                        
                    let batch_object =  currentOrder[tableView.tag].batch[index]
                    
                    if (batch_object.status == "orderaccepted") {
                        if (index == currentOrder[tableView.tag].batch.count-1) {
                            footerHeight = footerHeight + 250
                        } else {
                            footerHeight = footerHeight + 100
                        }
                        
                    } else if (batch_object.status == "orderplaced") {
                        if (index == currentOrder[tableView.tag].batch.count-1) {
                            footerHeight = footerHeight + 150
                        } else {
                            footerHeight = footerHeight + 100
                        }
                    }
                    else if (batch_object.status == "getbill") {
                        if (index == currentOrder[tableView.tag].batch.count-1) {
                            footerHeight = footerHeight + 250
                        }
                        return 0
                    }
                
            }
            }
            }
            
            let height = (rows * 125) + (custHeight * 4) + footerHeight + headerHeight + (noteHeight * 3) + paymentHeader
    
            return CGFloat(height + 80)
            
            
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (currentOrder.count <= 0) {
            let lbl = UILabel.init(frame: CGRect(x: 0, y: 0, width: 400, height: 60))
            lbl.text = "No Food in queue"
            lbl.font = UIFont.systemFont(ofSize: 30)
            lbl.center = self.view.center
            lbl.tag = 12345
            tableView.separatorStyle = .none
            tableView.addSubview(lbl)
            lbl.textAlignment = .center
        } else {
            if let v = tableView.viewWithTag(12345) {
                tableView.separatorStyle = .singleLine
                v.removeFromSuperview()
            }
        }
        
        if (tableView == majorTableView) {
            return tableViewData.count
        }
        
        if (tableViewData.count == 0) {
            return 0
        }
        
        return tableViewData[tableView.tag].sectionData.batch.count
        
        //return currentOrder[tableView.tag].batch.count

    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (tableView == majorTableView) {
            let view = Bundle.main.loadNibNamed("MainHeader", owner: self, options:.none)![0] as! MainHeader
            view.status.text  = tableViewData[section].sectionData.status
            
            let df = DateFormatter()
            df.dateFormat = "dd MM YYYY hh:mm:ss a"
            let date_str = df.date(from: String(tableViewData[section].sectionData.batch[0].timestamp))
            df.dateFormat = "hh:mm a"
            let str = df.string(from: date_str!)
            
            view.tablenumber.text = String(tableViewData[section].sectionData.table_id) + "   " + tableViewData[section].sectionData.user_phone + "     " + str
            
            view.container.layer.borderWidth = 2
            view.container.clipsToBounds = true
            view.container.layer.cornerRadius = 10
            
            
            if (tableViewData[section].sectionData.status == "orderplaced") {
                view.view.backgroundColor = UIColor().colorPlaced()
                view.container.layer.borderColor = UIColor().colorPlaced().cgColor
            }
            else if (tableViewData[section].sectionData.status == "orderaccepted") {
                view.view.backgroundColor = UIColor().colorAccepted()
                view.container.layer.borderColor = UIColor().colorAccepted().cgColor
            }
            else if (tableViewData[section].sectionData.status == "getbill") {
                view.view.backgroundColor = UIColor().colorGetBill()
                view.container.layer.borderColor = UIColor().colorGetBill().cgColor
            }
            else if (tableViewData[section].sectionData.status == "paymentverify") {
                view.view.backgroundColor = UIColor().colorPaymentVeify()
                view.container.layer.borderColor = UIColor().colorPaymentVeify().cgColor
            }
            else {
                view.view.backgroundColor = UIColor().colorCompleted()
                view.container.layer.borderColor = UIColor().colorCompleted().cgColor
            }
            
            
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
        
        let view = Bundle.main.loadNibNamed("ItemDetailsHeader", owner: self, options:.none)![0] as! ItemDetailsHeader
        if (currentOrder[tableView.tag].batch[section].status == "orderaccepted") {
            view.lblAmount.text = "TIME"
        } else {
            view.lblAmount.text = "AMOUNT"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        if (currentOrder[tableView.tag].status == "getbill" || currentOrder[tableView.tag].status == "paymentcash" || currentOrder[tableView.tag].status == "paymentcomplete"
        || currentOrder[tableView.tag].status == "paymentcard") {
            
            let view = Bundle.main.loadNibNamed("GetBillFooter", owner: self, options:.none)![0] as! GetBillFooter
            
            view.sub_total.text = String(currentOrder[tableView.tag].sub_total)
            view.discount.text = String(currentOrder[tableView.tag].discount)
            view.net_total.text = String(currentOrder[tableView.tag].net_total)
            view.cgst.text = String(currentOrder[tableView.tag].cgst)
            view.sgst.text = String(currentOrder[tableView.tag].sgst)
            view.service_charge.text = String(currentOrder[tableView.tag].service_charge)
            view.grand_total.text = String(currentOrder[tableView.tag].grand_total)
            
            
            
            view.btn_generate_bill.setTitle("Payment Received", for: .normal)
            
            view.btn_generate_bill.setTitleColor(UIColor.green, for: .normal)
            
            view.btn_generate_bill.layer.cornerRadius = 10
            view.btn_generate_bill.clipsToBounds = true
            view.btn_generate_bill.layer.borderWidth = 2
            view.btn_generate_bill.layer.borderColor = UIColor.green.cgColor
            
            view.btn_generate_bill.setTitleColor(.green, for: .normal)
            
            view.btn_generate_bill.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(paymentRecieved)))
            
            
            if (currentOrder[tableView.tag].status == "paymentcomplete" || currentOrder[tableView.tag].status == "paymentcard") {
                view.btn_generate_bill.isHidden = true
                
            }else {
                view.btn_generate_bill.isHidden = false
            }
            
            //NOW CHECK COUPON
            if (currentOrder[tableView.tag].coupon_discount > 0) {
                
                view.coupon_value.text = String(currentOrder[tableView.tag].coupon_discount)
                view.coupon_label.text = "Coupon Discount " + "(" +  currentOrder[tableView.tag].coupon_code + ")"
                view.layoutIfNeeded()
            }else {
                view.coupon_label.text = "Coupon Discount"
                view.coupon_value.text = "NA"
                view.layoutIfNeeded()
            }
            
            //check for service charge
            if (currentOrder[tableView.tag].service_charge == 0) {
                view.service_charge.text = "NA"
            
            }else {
                view.service_charge.text = String(currentOrder[tableView.tag].service_charge)
            }
            
            //check for cgst
            if (currentOrder[tableView.tag].cgst == 0) {
                view.cgst.text = "NA"
            
            }else {
                view.cgst.text = String(currentOrder[tableView.tag].cgst)
            }
            
            
            if (currentOrder[tableView.tag].sgst == 0) {
                view.cgst.text = "NA"
            
            }else {
                view.sgst.text = String(currentOrder[tableView.tag].sgst)
            }
            
            return view
        }
        
        let view = Bundle.main.loadNibNamed("ItemShowFooter", owner: self, options:.none)![0] as! ItemShowFooter
        
        view.height_additem.constant = 0
        view.height_genbill.constant = 0
        
        view.layoutIfNeeded()
        
        
        if (section == currentOrder[tableView.tag].batch.count-1) {
            view.height_additem.constant = 60
            view.height_genbill.constant = 60
            view.seperator.isHidden = true
            view.layoutIfNeeded()
        } else {
            view.seperator.isHidden = false
        }
        
        
        
        //SHOW HIDE CANCEL BUTTON
        if (currentOrder[tableView.tag].batch[section].status == "orderaccepted") {
            let width = view.btnAccept.frame.width
            
            view.btnAccept.isHidden = true
            view.center_space.constant = -(width * 2) + 20
            
            if (section == currentOrder[tableView.tag].batch.count-1) {
                view.height_genbill.constant = 60
            } else {
                view.height_genbill.constant = 0
            }
        } else {
            view.btnAccept.isHidden = false
            view.center_space.constant = 20
        }
        
        view.layoutIfNeeded()
        
        let batch_count = currentOrder[tableView.tag].batch.count
        
        if (batch_count <= 1) {
            view.btnCancel.setTitle("Cancel Order", for: .normal)
        } else {
            view.btnCancel.setTitle("Cancel Batch", for: .normal)
        }
        
        view.btnCancel.layer.cornerRadius = 10
        view.btnCancel.clipsToBounds = true
        view.btnCancel.layer.borderWidth = 2
        view.btnCancel.layer.borderColor = UIColor.init(red: 217/255, green: 83/255, blue: 79/255, alpha: 1).cgColor
        
        view.btnCancel.setTitleColor(UIColor.init(red: 217/255, green: 83/255, blue: 79/255, alpha: 1), for: .normal)
        
        
        view.btnAccept.layer.cornerRadius = 10
        view.btnAccept.clipsToBounds = true
        view.btnAccept.layer.borderWidth = 2
        view.btnAccept.layer.borderColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1).cgColor
        
        view.btnAccept.setTitleColor(UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1), for: .normal)
        
        view.btnAddItem.layer.cornerRadius = 10
        view.btnAddItem.clipsToBounds = true
        view.btnAddItem.layer.borderWidth = 2
        view.btnAddItem.layer.borderColor = UIColor.init(red: 2/255, green: 117/255, blue: 216/255, alpha: 1).cgColor
        
        view.btnAddItem.setTitleColor(UIColor.init(red: 2/255, green: 117/255, blue: 216/255, alpha: 1), for: .normal)
        
        
        view.btnGenerate.layer.cornerRadius = 10
        view.btnGenerate.clipsToBounds = true
        view.btnGenerate.layer.borderWidth = 2
        view.btnGenerate.layer.borderColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1).cgColor
        
        view.btnGenerate.setTitleColor(UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1), for: .normal)
        
        
        
        //ADD ACTIONS
        view.btnCancel.gestureRecognizers = nil
        view.btnAccept.gestureRecognizers = nil
        view.btnCancel.gestureRecognizers = nil
        view.btnGenerate.gestureRecognizers = nil
        
        view.btnAccept.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(AcceptOrder)))
        
        view.btnGenerate.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(GenerateBill)))
        
        view.btnCancel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(cancelOrder)))
        
        view.btnAddItem.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(AddItem)))
        
        
        //add tags to button for getting data after click
        view.btnAccept.tag = section
        view.btnCancel.tag = section
        view.btnGenerate.tag = section
        
        return view
    }
    
    
    
    @objc func finishedOrder(sender:Any) {
        let table_view = (sender as! UIButton).superview?.superview?.superview
        
        let network_call = NetworkBuilder()
        
        let parameters: [String: Any] = ["ord":self.response_data![table_view!.tag]]
        
        //serialise json data

        self.loader()
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.FINISH_ORDER , parameters:parameters, requestID: Constant.REQUEST_ID.FINISH_ORDER)
        
    }
    
    @objc func verifyOtp(sender:Any) {
        
        let table_view = (sender as! UIButton).superview?.superview?.superview as! UITableView

        let textFiled = table_view.viewWithTag(1919) as! UITextField
        
        guard let otp = textFiled.text , otp.count > 0 else {
            showError(msg: "Enter otp")
            return
        }
        
        //CHECK DEFAULTS OTP WITH THIS
        let def = UserDefaults.standard
        
        let otp_def = def.value(forKey: String(table_view.tag))
        
        
        if (otp_def as! Int == Int(otp)!) {
            
            let network_call = NetworkBuilder()
            
            let parameters: [String: Any] = ["ord":self.response_data![table_view.tag]]
            
            //serialise json data

            self.loader()
            
            network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.VERIFY_OTP , parameters:parameters, requestID: Constant.REQUEST_ID.VERIFY_OTP)
        } else {
            showError(msg: "Enter Valid OTP")
        }
        
        
    }
    
    @objc func removeItem(sender:Any) {
        let alert = UIAlertController(title: "peAR",message: "Are you sure you want remove an item", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            let table_view = (sender as! UIButton).superview?.superview?.superview
            
            let network_call = NetworkBuilder()
            
            let item_id = self.currentOrder[table_view!.tag].batch[(sender as! UIButton).superview!.superview!.tag].items[(sender as! UIButton).tag].id
            
            
            let parameters: [String: Any] = ["ord":self.response_data![table_view!.tag],"item_id":item_id]
            
            //serialise json data

            self.loader()
            
            network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.CANCEL_ITEM , parameters:parameters, requestID: Constant.REQUEST_ID.CANCEL_ITEM)
        }
        
        let dismissAction1 = UIAlertAction(title: "No", style: .destructive) { (action) in
            
        }
        
        alert.addAction(dismissAction)
        alert.addAction(dismissAction1)
            self.present(alert, animated: true, completion:  nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
            subview.backgroundColor = .white
    }
    
    
    @objc func skipverifyOtp(sender:Any) {

        let alert = UIAlertController(title: "peAR",message: "Are you sure you want skip veryfication", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            let table_view = (sender as! UIButton).superview?.superview?.superview
            
            let network_call = NetworkBuilder()
            
            let parameters: [String: Any] = ["ord":self.response_data![table_view!.tag]]
            
            //serialise json data

            self.loader()
            
            network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.SKIP_VERYFICATION , parameters:parameters, requestID: Constant.REQUEST_ID.SKIP_VERYFICATION)
        }
        
        let dismissAction1 = UIAlertAction(title: "No", style: .destructive) { (action) in
            
        }
        
        alert.addAction(dismissAction)
        alert.addAction(dismissAction1)
            self.present(alert, animated: true, completion:  nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
        subview.backgroundColor = .white
        
       
    }
    
    
    
    @objc func cancelOrder(sender:Any) {
        
        let alert = UIAlertController(title: "peAR",message: "Are you sure you want to remove from the order?", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            let table_view = (sender as! UITapGestureRecognizer).view?.superview?.superview
            
            if (self.currentOrder[table_view!.tag].batch.count > 1 ) {
                let batch_id = self.currentOrder[table_view!.tag].batch[((sender as! UITapGestureRecognizer).view?.superview?.subviews[0].tag)!].id
                
                let network_call = NetworkBuilder()
                
                let parameters: [String: Any] = ["batch_id":batch_id,"ord":self.response_data![table_view!.tag]]
                
                //serialise json data

                self.loader()
                
                network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.CANCEL_BATCH , parameters:parameters, requestID: Constant.REQUEST_ID.CANCEL_BATCH)
            } else {
            
                let network_call = NetworkBuilder()
                
                let parameters: [String: Any] = ["ord":self.response_data![table_view!.tag]]
                
                //serialise json data

                self.loader()
                
                network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ORDER_CANCEL , parameters:parameters, requestID: Constant.REQUEST_ID.ORDER_CANCEL)
                
                
            }

        }
        
        let dismissAction1 = UIAlertAction(title: "No", style: .destructive) { (action) in
            
        }
        
        alert.addAction(dismissAction)
        alert.addAction(dismissAction1)
            self.present(alert, animated: true, completion:  nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
        subview.backgroundColor = .white
        
    }
    
    
    @objc func GenerateBill(sender:Any) {
        
        let table_view = (sender as! UITapGestureRecognizer).view?.superview?.superview
        
        let alert = UIAlertController(title: "peAR",message: "Generate bill of table number:\(currentOrder[table_view!.tag].table_id)?", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in

             
            let parameters: [String: Any] = ["ord":self.response_data![table_view!.tag]]
            
            self.loader()
            
            let network_call = NetworkBuilder()
            
            network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.GENERATE_BILL , parameters:parameters, requestID: Constant.REQUEST_ID.GENERATE_BILL)

        }
        
        let dismissAction1 = UIAlertAction(title: "No", style: .destructive) { (action) in
            
        }
        
        alert.addAction(dismissAction)
        alert.addAction(dismissAction1)
            self.present(alert, animated: true, completion:  nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
        subview.backgroundColor = .white
    }
    
    
    @objc func paymentRecieved(sender:Any) {
        
        let table_view = (sender as! UITapGestureRecognizer).view?.superview?.superview
        
        let alert = UIAlertController(title: "peAR",message: "Are you sure you have received the payment of table number:\(currentOrder[table_view!.tag].table_id) from \(currentOrder[table_view!.tag].user_name)?", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in

             
            let parameters: [String: Any] = ["ord":self.response_data![table_view!.tag]]
            
            self.loader()
            
            let network_call = NetworkBuilder()
            
            network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.PAYMENT_RECEIVED , parameters:parameters, requestID: Constant.REQUEST_ID.PAYMENT_RECEIVED)

        }
        
        let dismissAction1 = UIAlertAction(title: "No", style: .destructive) { (action) in
            
        }
        
        alert.addAction(dismissAction)
        alert.addAction(dismissAction1)
            self.present(alert, animated: true, completion:  nil)
            // change the background color
            let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.layer.cornerRadius = 1
        subview.backgroundColor = .white
    }
    
    @objc func AcceptOrder(sender:Any) {
        
        let table_view = (sender as! UITapGestureRecognizer).view?.superview?.superview
        
       // let order_data = currentOrder[table_view!.tag]
        
        let batch_id = currentOrder[table_view!.tag].batch[((sender as! UITapGestureRecognizer).view?.superview?.subviews[0].tag)!].id
        
        let network_call = NetworkBuilder()
        
        let parameters: [String: Any] = ["batch_id":batch_id,"ord":response_data![0]]
        
        //serialise json data

        loader()
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ACCEPT_ORDER , parameters:parameters, requestID: Constant.REQUEST_ID.ACCEPT_ORDER)
    }
    
    @IBAction func AddItemCallApi () {
        
        let view = self.view.viewWithTag(2020) as! AddItemView
        
        guard let name = view.txtName.text , name.count > 0 else {
            showError(msg: "Enter name of the item")
            return
        }
        
        guard let qty = view.txtQuantity.text , qty.count > 0 else {
            showError(msg: "Enter Quantity of the item")
            return
        }
        
        guard let price = view.txtPrice.text , price.count > 0 else {
            showError(msg: "Enter price of the item")
            return
        }
        
        let type = view.item_type
        if (type == "select") {
            showError(msg: "Please select one of item type")
            return
        }
        
        let dict = ["name":name,"price":price,"quantity":qty,"category":"ADDED ITEM","item_type":type,"customisation":"","instructions":" ","optionPrice":0,"jain":false,"isAvailableJain":false,"taxable":true] as! NSDictionary
        
        
        do {

            let jsonObj = try JSONSerialization.data(withJSONObject: dict, options:.fragmentsAllowed)
            
            var json_str = String.init(data: jsonObj, encoding: .utf8)
            
            
            let parameters: [String: Any] = ["order_id":orderId,"item":json_str!]
            
            let network_call = NetworkBuilder()
            
            //let json_str1 = json_str!.replacingOccurrences(of: "\\", with: " ")
            
            //LETS GET ORDER ID
            
            loader()
            
            network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.ADD_ITEM, parameters:parameters, requestID: Constant.REQUEST_ID.ADD_ITEM)
            
            
        } catch (let error) {
            showError(msg: error.localizedDescription)
        }
        
        
        
        
    }
    
    @objc func AddItem(sender:Any) {
        
        let table_view = (sender as! UITapGestureRecognizer).view?.superview?.superview
        
        let view = Bundle.main.loadNibNamed("AddItemView", owner: self, options: .none)![0] as! AddItemView
        
        view.txtPrice.addDoneButtonOnKeyboard()
        view.txtQuantity.addDoneButtonOnKeyboard()
 
        
        orderId = currentOrder[table_view!.tag].id
        view.tag = 2020
        
        view.center = self.view.center
        let dimView = UIView.init(frame: self.view.frame)
        dimView.tag = 2121
        dimView.backgroundColor = .black
        dimView.alpha = 0.4
        dimView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissView)))
        dimView.isUserInteractionEnabled = true
        
        self.view.addSubview(dimView)
        self.view.addSubview(view)
    }
    
    @objc func dismissView() {
        self.view.viewWithTag(2020)?.removeFromSuperview()
        self.view.viewWithTag(2121)?.removeFromSuperview()
        
    }
    
  
    
    func networkCall() {
        let network_call = NetworkBuilder()
        
        let parameters: [String: Any] = [:]
        
        loader()
        
        network_call.makePostRequest(delegate: self, headers: [], postURL: Constant.URL.CURRENT_ORDER + "9999", parameters:parameters, requestID: Constant.REQUEST_ID.CURRENT_ORDER)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (tableView == self.majorTableView) {
            return 100
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if (tableView == majorTableView) {
            return 0
        }
        
        if (currentOrder[tableView.tag].status == "getbill" ||
                currentOrder[tableView.tag].status == "paymentcash" ||
                currentOrder[tableView.tag].status == "paymentcomplete" || currentOrder[tableView.tag].status == "paymentcard") {
            return 350
        }
        
        if (currentOrder[tableView.tag].batch[section].status == "orderaccepted") {
            if (section == currentOrder[tableView.tag].batch.count-1) {
                return 250
            } else {
                return 100
            }
            
        } else if (currentOrder[tableView.tag].batch[section].status == "orderplaced") {
            if (section == currentOrder[tableView.tag].batch.count-1) {
                return 170
            }
            return 100
        }
        else if (currentOrder[tableView.tag].batch[section].status == "getbill") {
            if (section == currentOrder[tableView.tag].batch.count-1) {
                return 250
            }
            return 0
        }
        
        return 0
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkCall()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func refreshPage() {
        self.networkCall()
    }
}

