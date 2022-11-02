//
//  RestaurantDetailsSwiftUIView.swift
//  RestaurantReviewApp
//
//  Created by Deniz Demirtas on 7/11/22.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct RestaurantDetailsSwiftUIView: View {
    @EnvironmentObject private var restaurantDetail: restaurantScreenData
    
        
    
    
    var body: some View {
        VStack{
            Label(restaurantDetail.restaurantName, systemImage: "fork.knife")
                .position(x: 190, y: 30)
            WebImage(url: URL(string: restaurantDetail.restaurantImage))
                .resizable()
                .frame(width: 200, height: 200, alignment: .trailing)
                .aspectRatio(contentMode: .fill)
                .position(x: 190, y: 50)
            Button {
                let telephone = "tel://"
                let formattedString = telephone + restaurantDetail.restaurantPhone
                guard let url = URL(string: formattedString) else {return}
                UIApplication.shared.open(url)
            } label: {
                Text("Make a reservation: \(restaurantDetail.restaurantPhone)")
            }
            Spacer()
            Button {
                let formattedLocationString = restaurantDetail.restaurantAddress.replacingOccurrences(of: " ", with: ".")
                print("formatted \(formattedLocationString)")
                
                openMap(address: formattedLocationString)
            } label: {
                Text("Directions:  \(restaurantDetail.restaurantAddress)")
            }
            
            Spacer()
            Link(" Go To Restaurant Website ", destination: URL(string: restaurantDetail.restaurantWebURL)!)
                
    

            
            HStack{
                Text("Rating: \(restaurantDetail.rating)")
                
                Text("Currently \(restaurantDetail.restaurantIsClosed)")
               
                Text("Price: \(restaurantDetail.restaurantPriceLevel)")
               
            }
            .position(x: 190, y: 200)}
            

        
        
        
        
            
        }
    }







func openMap(address: String){
    UIApplication.shared.openURL(NSURL(string: "https://maps.apple.com/?address=\(address)")! as URL)
}



struct RestaurantDetailsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailsSwiftUIView()
    }
}

class restaurantScreenData: ObservableObject{
    @Published var restaurantName: String = ""
    @Published var rating: String = ""
    @Published var restaurantIsClosed: String = ""
    @Published var restaurantPriceLevel: String = ""
    @Published var restaurantWebURL: String = ""
    @Published var restaurantPhone: String = ""
    @Published var restaurantAddress: String = ""
    @Published var restaurantImage: String = ""
    
   
}

class RestaurantDetailUIViewVHC: UIHostingController<RestaurantDetailsSwiftUIView>{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RestaurantDetailsSwiftUIView())
    }
}
