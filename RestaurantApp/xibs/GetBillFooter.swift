//
//  GetBillFooter.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 17/02/21.
//

import UIKit

class GetBillFooter: UIView {
    
    @IBOutlet weak var sub_total:UILabel!
    @IBOutlet weak var discount:UILabel!
    @IBOutlet weak var net_total:UILabel!
    @IBOutlet weak var cgst:UILabel!
    @IBOutlet weak var sgst:UILabel!
    @IBOutlet weak var service_charge:UILabel!
    @IBOutlet weak var grand_total:UILabel!
    
 
    @IBOutlet weak var height_coupon: NSLayoutConstraint!
    @IBOutlet weak var coupon_label:UILabel!
    @IBOutlet weak var coupon_value:UILabel!
    
    
    @IBOutlet weak var btn_generate_bill:UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
