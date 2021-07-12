//
//  AnalyticsCell.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 23/02/21.
//

import UIKit

class AnalyticsCell: UITableViewCell {
    
    @IBOutlet weak var view:UIView!
    
    @IBOutlet weak var lblname:UILabel!
    @IBOutlet weak var lbldetails:UILabel!
    @IBOutlet weak var lbldetails1:UILabel!
    
    @IBOutlet weak var img_view:UILabel!
    
    @IBOutlet weak var details_btn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.7
        
        img_view.layer.cornerRadius = 20
        img_view.clipsToBounds = true
        img_view.backgroundColor = UIColor.green
        img_view.textColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
