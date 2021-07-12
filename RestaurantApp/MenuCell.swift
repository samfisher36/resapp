//
//  MenuCell.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 04/03/21.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var icon:UIImageView!
    @IBOutlet weak var name:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
