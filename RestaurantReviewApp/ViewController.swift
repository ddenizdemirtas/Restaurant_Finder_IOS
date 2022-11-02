//
//  ViewController.swift
//  RestaurantReviewApp
//
//  Created by Deniz Demirtas on 6/28/22.
//

import Firebase
import FirebaseCore
import FirebaseStorage
import MapKit
import SwiftUI
import UIKit
import VisilabsIOS


var mainVC = ViewController()
class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var userMapView: MKMapView!
    @objc let locationManager = CLLocationManager()
    
//    let semaphore = DispatchSemaphore(value: 0)
//    let dispatchQueue = DispatchQueue.global(qos: .userInitiated)

    var firstTimeVC: Bool = true
    var properties = [String:String]()
    var userPrevLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)

    @IBAction func addNewRestaurantButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "segueToAddView", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("INSIDE TABLEVIEW ROW COUNT \(names.count)")
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableViewCell
        //print("DEBUG 1RELOAD: \(names)")
        cell.restaurantName.text = names[indexPath.row]
        cell.restaurantRating.text = rating[indexPath.row]
        cell.restaurantIsClosed.text = isClosed[indexPath.row]
        cell.restaurantPriceLevel.text = priceLevel[indexPath.row]

        //print("DEBUG RELOAD: \(names)")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 154
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "restaurantDetailSegue", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "restaurantDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let destinationVC = segue.destination as! RestaurantDetailViewController
                destinationVC.restaurantName = names[selectedRow]
                destinationVC.restaurantPriceLevel = priceLevel[selectedRow]
                destinationVC.restaurantIsClosed = isClosed[selectedRow]
                destinationVC.restaurantRating = rating[selectedRow]
                destinationVC.restaurantPhone = phone[selectedRow]
                destinationVC.restaurantWebURL = webURL[selectedRow]
                destinationVC.restaurantAddress = addressList[selectedRow]
                print("IMAGE LIST \(imageList.count) \(names.count)")
                destinationVC.restaurantImage = imageList[selectedRow]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("CHECKMARK")
        firstTimeVC = true
        Visilabs.callAPI().loggingEnabled = true
        Visilabs.callAPI().signUp(exVisitorId: "userId")
        
        properties["OM.sys.TokenID"] = "F7C5231053E6EC543B8930FB440752E2FE41B2CFC2AA8F4E9C4843D347E6A847" // Token ID to use for push messages
        properties["OM.sys.AppID"] = "VisilabsIOSExample" //App ID to use for push messages

        Visilabs.callAPI().signUp(exVisitorId: "userId", properties: properties)

        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let currentLocation = locations.first {
            print("INSIDE DID UPDATE LOCATION FUNC ")
            callRestaurants(currentLocation) {
                print("FIREBASE CALL FUNC CALLED")
                dataCall(currentLocation) {
                    self.render(currentLocation) {
                        print("LOCATION RENDER CALL DONE")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            print("TABLE VIEW RELOADED")
                            self.userPrevLocation = currentLocation
                        }
                    }
                }
            }
        }
    }

    func render(_ location: CLLocation, completionHandler: @escaping () -> Void) {
       
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        userMapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        userMapView.addAnnotation(pin)
        print("LOCATION RENDERED")
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.locationManager.stopUpdatingLocation()
        }

        completionHandler()
    }
}
