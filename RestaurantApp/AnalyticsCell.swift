//
//  AnalyticsCell.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 23/02/21.
//

import UIKit

class AnalyticsCell: UICollectionViewCell {
    
   
    
    @IBOutlet weak var lblname:UILabel!
    @IBOutlet weak var lbldetails:UILabel!
    @IBOutlet weak var lbldetails1:UILabel!
    
    @IBOutlet weak var img_view:UILabel!
    
    @IBOutlet weak var details_btn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        img_view.layer.cornerRadius = 16
        img_view.clipsToBounds = true
        //img_view.backgroundColor = UIColor.green
        img_view.textColor = .lightGray
        img_view.layer.borderWidth = 1
        
    }

   

}
