//
//  APIClient.swift
//  Memory

import Foundation
import AFNetworking
import SwiftyJSON

typealias CardsArray = [Card]

// MARK: - APIClient
class APIClient: AFHTTPSessionManager {
    
    struct URLHosts {
        static let baseURL = "https://source.unsplash.com/"
        static let random = "random/"
        static let category = "category/"
    }
    
    static let shared = APIClient()
    
    
    static var defaultCardImages:[UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!
    ];
    
    func getCardImages(completion: ((CardsArray?, Error?) -> ())?) {
        var cards = CardsArray()
        let cardImages = APIClient.defaultCardImages
        
        for image in cardImages {
            let card = Card(image: image)
            let copy = card.copy()
            
            cards.append(card)
            cards.append(copy)
        }
        
        completion!(cards, nil)
    }
}
