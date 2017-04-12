//
//  Card.swift
//  Memory

import UIKit
import SwiftyJSON

class Card {

    // MARK: - Properties
    
    var id: String
    var shown: Bool = false
    var artworkURL: UIImage!
    
    static var allCards = [Card]()

    init(card: Card) {
        self.id = card.id
        self.shown = card.shown
        self.artworkURL = card.artworkURL
    }
    
    init(image: UIImage) {
        self.artworkURL = image
        self.shown = false
        self.id = NSUUID().uuidString
    }
    
    // MARK: - Methods
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
