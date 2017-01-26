//
//  GameController.swift
//  Memory

import UIKit
import AFNetworking

class GameController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let game = MemoryGame()
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        APIClient.shared.getCardImages(success: { (cards) in
            self.cards = cards
            self.setupNewGame()
    
            
        }, failure: { (error) in
            print(error)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func setupNewGame() {
        cards = game.newGame(cardsArray: self.cards)
        collectionView.reloadData()
    }
    
    func resetGame() {
        game.stopGame()
        setupNewGame()
    }
}

// MARK: - CollectionView Delegate Methods
extension GameController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.showCard(false, animted: false)
        
        guard let card = game.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.shown { return }
        game.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
}

// MARK: - MemoryGameProtocol Methods
extension GameController: MemoryGameProtocol {
    
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }
    
    func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(true, animted: true)
        }
    }
    
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
            cell.showCard(false, animted: true)
        }
    }
    
    func memoryGameDidEnd(_ game: MemoryGame) {
        let alertController = UIAlertController(
            title: defaultAlertTitle,
            message: defaultAlertMessage,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] (action) in
            self?.resetGame()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) { }
    }
}

extension GameController {
    
    // Collection view flow layout setup
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let cellSquareSize: CGFloat = screenWidth / 4.0 - 30.0
        
        return CGSize(width: cellSquareSize, height: cellSquareSize);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0.0, 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
}
