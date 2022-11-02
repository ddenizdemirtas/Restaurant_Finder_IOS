//
//  jsonCall.swift
//  RestaurantReviewApp
//
//  Created by Deniz Demirtas on 6/28/22.
//

import Alamofire
import CoreLocation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Foundation
import SwiftyJSON

var names = [String]()
var latitude = [String]()
var longitude = [String]()
var rating = [String]()
var isClosed = [String]()
var priceLevel = [String]()
var webURL = [String]()
var phone = [String]()
var imageList = [String]()
var addressList = [String]()

func callRestaurants(_ currentLocation: CLLocation, completionHandler: @escaping () -> Void) {
    let firestoreDB = Firestore.firestore()
    firestoreDB.collection("Restaurants").addSnapshotListener { snapshot, error in
        if error != nil {
            print("Error calling data from Firestore ")
        }
        print("IS SNAPSHOT EMPTY \(snapshot?.isEmpty)")
        if snapshot?.isEmpty == false {
            print("FIREBASE SNAPSHOT RECEIVED")

            let geoCoder = CLGeocoder()
            print("FIREBASE SNAPSHOT RECEIVED2")
            for document in snapshot!.documents {
                print("FIREBASE SNAPSHOT RECEIVED3 \(document.get("restaurantName"))")
                let address = document.get("restaurantAddress")
                geoCoder.geocodeAddressString(address as! String) { placemarks, error
                    in
                    if error == nil {
                        print("FIREBASE ERROR \(error?.localizedDescription)")
                        let placemarks = placemarks
                        let location = placemarks?.first?.location
                        print("SNAPSHOT LOCATION BEING CHECKED \(address)")
                        print("SNAPSHOT LOCATION OK \(document.documentID)")
                        names.append(document.get("restaurantName") as! String)
                        priceLevel.append(document.get("restaurantHours") as! String)
                        addressList.append(address as! String)
                        phone.append(document.get("restaurantPhone") as! String)
                        webURL.append(document.get("restaurantPhone") as! String)
                        isClosed.append(document.get("restaurantHours") as! String)
                        rating.append(document.get("restaurantRating") as! String)

                        
                        
                    }
                    let placemarks = placemarks
                    let location = placemarks?.first?.location
                    print("SNAPSHOT LOCATION BEING CHECKED \(address)")
                    if (location?.distance(from: currentLocation))! < 5000 {
                        print("SNAPSHOT LOCATION OK \(document.documentID)")
                        names.append(document.get("restaurantName") as! String)
                        print("FINAL \(names)")
                        priceLevel.append(document.get("restaurantHours") as! String)
                        addressList.append(address as! String)
                        phone.append(document.get("restaurantPhone") as! String)
                        webURL.append(document.get("restaurantPhone") as! String)
                        isClosed.append(document.get("restaurantHours") as! String)
                        rating.append(document.get("restaurantRating") as! String)
                    }
                }
                print("SNAPSHOT LOCATION NOT OK \(error?.localizedDescription)")
                names.append(document.get("restaurantName") as! String)
                print("FINAL \(names)")
            }
            print("FINAL \(names)")
        }
        print("FIRESTORE CALLBACK DONE1")
        completionHandler()
    }
}

func dataCall(_ currentLocation: CLLocation, completionHandler: @escaping () -> Void) {
    let apiURL = "https://travel-advisor.p.rapidapi.com/restaurants/list-by-latlng?latitude=\(currentLocation.coordinate.latitude)&longitude=\(currentLocation.coordinate.longitude)&limit=30&currency=USD&distance=2&open_now=false&lunit=km&lang=en_US"
    let httpHeaders: HTTPHeaders = [
        "X-RapidAPI-Key": "a092d120dfmsh5b10fee1df9cce3p1ed898jsna29cd393157b",
        "X-RapidAPI-Host": "travel-advisor.p.rapidapi.com",
    ]
    print("call in progress")
    sendRequest(url: apiURL, parameters: [:], headers: httpHeaders) { resultVal in
        switch resultVal.result {
        case let .success(value):
            names.removeAll(keepingCapacity: false)
            latitude.removeAll(keepingCapacity: false)
            longitude.removeAll(keepingCapacity: false)
            rating.removeAll(keepingCapacity: false)
            isClosed.removeAll(keepingCapacity: false)
            priceLevel.removeAll(keepingCapacity: false)
            webURL.removeAll(keepingCapacity: false)
            addressList.removeAll(keepingCapacity: false)
            imageList.removeAll(keepingCapacity: false)
            let restJson = JSON(value)
            let jsonData = restJson["data"]
            for restaurant in jsonData {
                if restaurant.1["name"].exists() {
                    names.append(restaurant.1["name"].stringValue)
                    latitude.append(restaurant.1["latitude"].stringValue)
                    longitude.append(restaurant.1["longitude"].stringValue)
                    rating.append(restaurant.1["rating"].stringValue)
                    if restaurant.1["is_closed"] == true {
                        isClosed.append("Closed")
                    } else if restaurant.1["is_closed"] == false {
                        isClosed.append("Open")
                    }
                    priceLevel.append(restaurant.1["price_level"].stringValue)
                    webURL.append(restaurant.1["web_url"].stringValue)
                    phone.append(restaurant.1["phone"].stringValue)
                    addressList.append(restaurant.1["address"].stringValue)
                    imageList.append(restaurant.1["photo"]["images"]["original"]["url"].stringValue)
                }
            }

            print("DEBUG: \(names)")
            completionHandler()

        case let .failure(e):
            print(e)
        }
    }

    func sendRequest(url: String, parameters: [String: String], headers: HTTPHeaders, completionHandler: @escaping (_ resultVal: AFDataResponse<Data>) -> Void) {
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { response in
            completionHandler(response)
        }
    }
}
