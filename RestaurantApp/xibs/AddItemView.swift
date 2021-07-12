//
//  AddItemView.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 20/02/21.
//

import UIKit

class AddItemView: UIView {
    
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtQuantity:UITextField!
    @IBOutlet weak var txtPrice:UITextField!
    
    var item_type = "select"

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func select(sender:UIButton) {

        sender.isSelected = !sender.isSelected
        
        for btn in self.subviews {
            if btn.isKind(of: UIButton.self) {
                if (btn.tag >= 1 && btn.tag != sender.tag ) {
                    (btn as! UIButton).isSelected = false
                }
            }
        }
        
        if (sender.tag == 1 ) {
            item_type = "1"
        } else if (sender.tag == 2 ) {
            item_type = "2"
        } else if (sender.tag == 3 ) {
            item_type = "3"
        }
        
        
    }

}
