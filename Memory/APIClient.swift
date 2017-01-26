//
//  APIClient.swift
//  Memory

import Foundation
import BDBOAuth1Manager

class APIClient: BDBOAuth1SessionManager {
    
    struct URLHosts {
        static let prod = "http://api.soundcloud.com/"
        static let dev = "http://api.soundcloud.com/playlists/79670980?client_id=\(Config.clientID)"
    }
    
    struct Config {
        static let clientID = "aa45989bb0c262788e2d11f1ea041b65"
        
        #if DEBUG
            static let URLString = URLHosts.dev
        #else
            static let URLString = URLHosts.prod
        #endif
    }
    
    static let shared = APIClient()
    
    /**
     
     - Returns: One of two completion blocks: sucess or failure.
     - success: If successful, returns a list of cards.
     - failure: If it fails, returns the error.
     */
    func getCardImages(success:@escaping ([Card]) -> (), failure:@escaping (Error) ->()) {
        get(Config.URLString, parameters: nil, progress: nil, success: {(_, response) in
            
            let dict = response as! [String:Any]
            let cards = Card.cardsWithArray(dictionary: dict[keyTracks] as! [[String : Any]])
            
            success(cards)
            
        }) {(_, error) in
            failure(error)
        }
    }
}
