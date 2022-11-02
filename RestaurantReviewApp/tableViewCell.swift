//
//  tableViewCell.swift
//  RestaurantReviewApp
//
//  Created by Deniz Demirtas on 7/7/22.
//

import UIKit

class tableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantIsClosed: UILabel!
    @IBOutlet weak var restaurantPriceLevel: UILabel!
    @IBOutlet weak var restaurantRating: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
