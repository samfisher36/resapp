//
//  MySlider.swift
//  RestaurantApp
//
//  Created by Mitesh Churi on 13/07/21.
//

import UIKit

class MySlider: UISlider {

    @IBInspectable var height: CGFloat = 2
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: height))
    }

}
