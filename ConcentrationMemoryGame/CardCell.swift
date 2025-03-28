//
//  CardCell.swift
//  ConcentrationMemoryGame
//
//  Created by Yan's Mac on 3/20/25.
//

import UIKit

class CardCell: UICollectionViewCell {
    private let frontImageView: UIImageView!
    private var cardImageName: String!
    private var backImageName: String!
    
    override init(frame: CGRect) {
        frontImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: frame.size))
        super.init(frame: frame)
        contentView.addSubview(frontImageView)
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func renderCardName(_ cardImageName: String, backImageName: String) {
        self.cardImageName = cardImageName
        self.backImageName = backImageName
        frontImageView.image = UIImage(named: self.backImageName)
    }
    
    func upturn() {
        let newImage = UIImage(named: self.cardImageName)
        UIView.transition(with: contentView, duration: 1, options: [.transitionFlipFromRight], animations: {
            self.frontImageView.image = newImage
        }, completion: nil)
    }
    
    func downturn() {
        let newImage = UIImage(named: self.backImageName)
        UIView.transition(with: contentView, duration: 1, options: .transitionFlipFromLeft, animations: {
            self.frontImageView.image = newImage
        }, completion: nil)
    }
    
    func remove() {
        UIView.animate(withDuration: 1) {
            self.alpha = 0
        } completion: { completed in
            self.isHidden = true
        }

    }
}
