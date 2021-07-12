//
//  ItemShowCell.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 15/02/21.
//

import UIKit

class OrdersItemCell: UITableViewCell {
    
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblCategory:UILabel!
    @IBOutlet weak var lblQty:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var btnRemove:UIButton!
    
    
    @IBOutlet weak var lblCust:UILabel!
    @IBOutlet weak var lblNote:UILabel!
    
    @IBOutlet weak var lblNoteShow:UILabel!
    @IBOutlet weak var lblCustShow:UILabel!
    

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    
    @IBOutlet weak var veg_icon: UIImageView!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
