//
//  RestaurantDetailViewController.swift
//  RestaurantReviewApp
//
//  Created by Deniz Demirtas on 7/11/22.
//

import UIKit
import SwiftUI

class RestaurantDetailViewController: UIViewController {
    let RestaurantScreendata = restaurantScreenData()
    var restaurantName: String = ""
    var restaurantLat: String = ""
    var restaurantLong: String = ""
    var restaurantLocation: String = ""
    var restaurantRating: String = ""
    var restaurantIsClosed: String = ""
    var restaurantPriceLevel: String = ""
    var restaurantWebURL: String = ""
    var restaurantPhone: String = ""
    var restaurantAddress: String = ""
    var restaurantImage: String = ""
    

    @IBSegueAction func toSwiftUI(_ coder: NSCoder) -> UIViewController? {
        RestaurantScreendata.restaurantName = restaurantName
        RestaurantScreendata.restaurantPhone = restaurantPhone
        RestaurantScreendata.restaurantWebURL = restaurantWebURL
        RestaurantScreendata.restaurantPriceLevel = restaurantPriceLevel
        RestaurantScreendata.restaurantIsClosed = restaurantIsClosed
        RestaurantScreendata.rating = restaurantRating
        RestaurantScreendata.restaurantImage = restaurantImage
        RestaurantScreendata.restaurantAddress = restaurantAddress
        
        
        print("DEBUG:4 \(restaurantName)")
        return UIHostingController(coder: coder, rootView: RestaurantDetailsSwiftUIView().environmentObject(RestaurantScreendata))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: 5 \(restaurantAddress)")
        
        
        
        // Do any additional setup after loading the view.
    }
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
