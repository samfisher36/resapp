//
//  AmountTransferVC.swift
//  RestaurantApp
//
//  Created by parth vora on 15/07/21.
//

import UIKit




class AmountTransferVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var titles = ["Gross Revenue (A)","Additions & deductions (B)","Net Receivable (C)","Amount Received through COD order (D)","Net amount (C-D)"]
    
    
    var range = ""
    var amount = 0.0
    var gross = 0.0
    var addsub = 0.0
    var netrec = 0.0
    var cod = 0.0
    var net = 0.0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Transfer1
            
            cell.date.text = range
            cell.price.text = String(amount)
            
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! Transfer2
        
        cell.desc.isHidden = true
        
        cell.price.textColor = UIColor.black
        
        cell.title.text = titles[indexPath.row - 1]
        
        if (indexPath.row == 1) {
            cell.desc.isHidden = false
            cell.desc.text = "Number of order 10"
            cell.price.text = String (gross)
        } else if (indexPath.row == 2 || indexPath.row == 3) {
            cell.desc.isHidden = false
            cell.desc.text = "Inclusive of taxes and charge"
            
        }
        
        if (indexPath.row == 2){
            cell.price.text = String (addsub)
            
            if (addsub as! Double >= 0) {
                cell.price.textColor = .green
            }else {
                cell.price.textColor = .red
            }
            
        }else if (indexPath.row == 3) {
            cell.price.text = String (netrec)
        }else if (indexPath.row == 4) {
            cell.price.text = String (cod)
        }else if (indexPath.row == 5) {
            cell.price.text = String (net)
        }

        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 110
        }
        return 90
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
