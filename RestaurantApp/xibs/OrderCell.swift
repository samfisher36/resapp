//
//  OrderCell.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 16/02/21.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var insideTableView:UITableView!
    
    @IBOutlet weak var btnSkipVerify: UIButton!
    @IBOutlet weak var btnVerify: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let view  = self.viewWithTag(1515) as? UIButton
        
        if ((view) != nil)
        {
            view!.layer.cornerRadius = 20
            view!.clipsToBounds = true
            view!.layer.borderWidth = 2
            view!.layer.borderColor = UIColor.green.cgColor
            view!.setTitleColor(UIColor.green, for: .normal)
        }
        
        if (btnSkipVerify != nil) {
        
            btnSkipVerify.layer.borderColor = UIColor.init(red: 217/255, green: 83/255, blue: 79/255, alpha: 1).cgColor
            
            btnSkipVerify.setTitleColor(UIColor.init(red: 217/255, green: 83/255, blue: 79/255, alpha: 1), for: .normal)
            
            btnSkipVerify.layer.borderWidth = 2
            btnVerify.layer.borderWidth = 2
            
            btnVerify.setTitleColor(UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1), for: .normal)
            
            btnVerify.layer.borderColor = UIColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1).cgColor
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
