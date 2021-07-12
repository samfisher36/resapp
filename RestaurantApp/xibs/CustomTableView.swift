//
//  CustomTableView.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 16/02/21.
//

import UIKit

class CustomTableView: UITableView {
   
    override var intrinsicContentSize: CGSize {
            self.layoutIfNeeded()
            return self.contentSize
        }

        override var contentSize: CGSize {
            didSet{
                self.invalidateIntrinsicContentSize()
            }
        }

        override func reloadData() {
            super.reloadData()
            self.invalidateIntrinsicContentSize()
        }
}
