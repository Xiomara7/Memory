//
//  MemoryCell.swift
//  Memory

import UIKit
import AFNetworking

class CardCell: UICollectionViewCell {

    // MARK: - Properties
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card? {
        didSet {
            guard let card = card else { return }
            frontImageView.setImageWith(URL(string: card.artworkURL)!)
        }
    }
    
    var shown: Bool = false
    
    // MARK: - Methods
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func showCard(_ show: Bool, animted: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        shown = show
        
        if animted {
            if show {
                UIView.transition(from: backImageView,
                                  to: frontImageView,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transition(from: frontImageView,
                                  to: backImageView,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubview(toFront: frontImageView)
                backImageView.isHidden = true
            } else {
                bringSubview(toFront: backImageView)
                frontImageView.isHidden = true
            }
        }
    }
}


