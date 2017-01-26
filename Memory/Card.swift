//
//  Card.swift
//  Memory

import UIKit

class Card {

    // MARK: - Properties
    
    var id: Int
    var shown: Bool = false
    var artworkURL = String()
    
    static var allCards = [Card]()
    
    init(ID: Int, artworkURL: String) {
        self.id = ID
        self.artworkURL = artworkURL
    }

    init(card: Card) {
        self.id = card.id
        self.shown = card.shown
        self.artworkURL = card.artworkURL
    }
    
    // MARK: - Methods
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    /**
     Parse response from API to get the artworks for a set of tracks.
     - Parameter dictionary: response dictionary from API.
     - Returns: An array of **Card** instances.
     */
    class func cardsWithArray(dictionary: [[String:Any]]) -> [Card] {
        var cards = [Card]()
        
        for dict in dictionary {
            if cards.count < defaultGridSize {
                guard let artworkURL = dict[keyArtworkURL] as? String else { return cards }
                guard let cardID = dict[keyID] as? Int else { return cards }
                
                let card = Card(ID: cardID, artworkURL: artworkURL)
                let copy = Card(ID: cardID, artworkURL: artworkURL)
        
                cards.append(card)
                cards.append(copy)
            }
        }
        
        allCards = cards
        return cards
    }
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
