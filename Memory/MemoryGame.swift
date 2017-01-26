//
//  MemoryGame.swift
//  Memory

import Foundation
import UIKit

// MARK: - MemoryGameProtocol
protocol MemoryGameProtocol {

    func memoryGameDidStart(_ game: MemoryGame)
    func memoryGameDidEnd(_ game: MemoryGame)
    func memoryGame(_ game: MemoryGame, showCards cards: [Card])
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card])
}
    
// MARK: - MemoryGame
class MemoryGame {
    
    // MARK: - Properties
    
    var delegate: MemoryGameProtocol?
    var cards:[Card] = [Card]()
    var cardsShown:[Card] = [Card]()
    var isPlaying: Bool = false
    
    // MARK: - Methods
    
    func newGame(cardsArray:[Card]) -> [Card] {
        cards = shuffleCards(cards: cardsArray)
        isPlaying = true

        delegate?.memoryGameDidStart(self)
        
        return cards
    }
    
    func stopGame() {
        isPlaying = false
        
        cards.removeAll()
        cardsShown.removeAll()
    }

    func cardAtIndex(_ index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }

    func indexForCard(_ card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }

    func didSelectCard(_ card: Card?) {
        guard let card = card else { return }
        
        delegate?.memoryGame(self, showCards: [card])
        
        if unmatchedCardShown() {
            let unmatched = unmatchedCard()!
            
            if card.equals(unmatched) {
                cardsShown.append(card)
            } else {
                let secondCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.memoryGame(self, hideCards:[card, secondCard])
                }
            }
            
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            endGame()
        }
    }
    
    fileprivate func endGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self)
    }
    
    /**
     Indicates if the card selected is unmatched 
     (the first one selected in the current turn).
     - Returns: An array of shuffled cards.
     */
    fileprivate func unmatchedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    /**
     Reads the last element in **cardsShown** array.
     - Returns: An unmatched card.
     */
    fileprivate func unmatchedCard() -> Card? {
        let unmatchedCard = cardsShown.last
        return unmatchedCard
    }

    fileprivate func shuffleCards(cards:[Card]) -> [Card] {
        var randomCards = cards
        randomCards.shuffle()
        
        return randomCards
    }
}
