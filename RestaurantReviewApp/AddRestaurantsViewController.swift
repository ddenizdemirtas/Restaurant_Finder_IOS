//
//  AddRestaurantsViewController.swift
//  RestaurantReviewApp
//
//  Created by Deniz Demirtas on 7/18/22.
//

import CoreLocation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import UIKit

class AddRestaurantsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var priceRangeField: UITextField!
    @IBOutlet var hoursField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var addressField: UITextField!

    @IBOutlet var websiteURLField: UITextField!
    @IBOutlet var phoneField: UITextField!
    var pickedImage = false

    @IBAction func saveToMainButtonClicked(_ sender: Any) {
        print("SAVE BUTTON CLICKED")
        let firestoreDatabase = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageFoler = storageRef.child("restaurantsAdded")
        var FirestoreRef: DocumentReference?
        let firestoreRestaurant = ["restaurantName": nameField.text , "restaurantPriceRange": priceRangeField.text, "restaurantHours": hoursField.text, "restaurantAddress": addressField.text, "restaurantWebURL": websiteURLField.text, "restaurantPhone": phoneField.text, "restaurantRating": ratingField.text] as [String: Any]
        FirestoreRef = firestoreDatabase.collection("Restaurants").addDocument(data: firestoreRestaurant) { error in
            if error != nil {
                self.makeAlert(titleInput: "Error uploading to firebase", messageInput: "Error \(String(describing: error?.localizedDescription))")
            }
            print("IMAGE UPLOAD START")
            let imageData = self.imageView.image?.jpegData(compressionQuality: 0.5)
            let imageReference = imageFoler.child(FirestoreRef!.documentID)
            imageReference.putData(imageData!) { _, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error uploading to firebase", messageInput: "Error \(String(describing: error?.localizedDescription))")
                }
                imageReference.downloadURL { url, error in
                    if error != nil {
                    }
                    let imageURL = url!.absoluteString
                    imageList.append(imageURL)
                    print("IMAGE APPENDED")
                }
            }
        }
        performSegue(withIdentifier: "savedToMainSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)

        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }

    // Do any additional setup after loading the view.
    @IBAction func tapImageView(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
            pickedImage = true
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
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
