//
//  MemoryViewController.swift
//  ConcentrationMemoryGame
//
//  Created by Yan's Mac on 3/19/25.
//

import UIKit
 
class MemoryViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var deck: Deck!
    private let difficulty: Difficulty
    private var cardUp = false
    private var selectedIndexes = [IndexPath]()
    private var numberOfPairs = 0
    private var score = 0
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        deck = Deck()
        super.init(nibName: nil, bundle: nil)
        deck = createDeck(numCards: numCardsNeededDifficulty(difficult: difficulty))
        for i in 0..<deck.count {
            print("The card at index [\(i)] is [\(deck[i].description)]")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        start()
    }
    
    private func start() {
//        deck = [Int].init(repeating: 1, count: numCardsNeededDifficulty(difficult: difficulty))
        deck = createDeck(numCards: numCardsNeededDifficulty(difficult: difficulty))
        collectionView.reloadData()
    }
    
    private func createDeck(numCards: Int) -> Deck{
        let fullDeck = Deck.full().shuffled()
        let halfDeck = fullDeck.deckOfNumberOfCards(num: numCards/2)
        return (halfDeck + halfDeck).shuffled()
    }
}

// MARK: - Collection View Setup
private extension MemoryViewController {
    func setup() {
        view.backgroundColor = .greenSea()
        
        let space: CGFloat = 5  // empty space between cards
        let (covWidth, covHeight) = collectionViewSizeDifficulty(difficulty: difficulty, space: space)
        let layout = layoutCardSize(cardSize: cardSizeDifficulty(difficulty: difficulty, space: space), space: space)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: covWidth, height: covHeight), collectionViewLayout: layout)
        collectionView.center = view.center
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
    }
    
    func layoutCardSize(cardSize: (cardWidth: CGFloat, cardHeight: CGFloat), space: CGFloat) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.itemSize = CGSize(width: cardSize.cardWidth, height: cardSize.cardHeight)
        layout.minimumLineSpacing = space
        return layout
    }
    
    func collectionViewSizeDifficulty(difficulty: Difficulty, space: CGFloat) -> (CGFloat, CGFloat) {
        let (columns, rows) = sizeDifficulty(difficulty: difficulty)
        let (cardWidth, cardHeight) = cardSizeDifficulty(difficulty: difficulty, space: space)
        
        let covWidth = columns * (cardWidth + 2 * space)
        let covHeight = rows * (cardHeight + space)
//        let covHeight = rows * (cardHeight + 2 * space)
        return (covWidth, covHeight)
        
    }
    
    func cardSizeDifficulty(difficulty: Difficulty, space: CGFloat) -> (CGFloat, CGFloat) {
        let lengthWidthRatio: CGFloat = 1.5
        let (_, rows) = sizeDifficulty(difficulty: difficulty)
        let cardHeight: CGFloat = view.frame.height / rows - 2 * space
        let cardWidth: CGFloat = cardHeight / lengthWidthRatio
        return (cardWidth, cardHeight)
    }
    
    func sizeDifficulty(difficulty: Difficulty) -> (CGFloat, CGFloat) {
        switch difficulty {
        case .Easy:
            return (4,3)
        case .Medium:
            return (6,4)
        case .Hard:
            return (8,5)
        }
    }
    
    func numCardsNeededDifficulty(difficult: Difficulty) -> Int {
        let (columns, rows) = sizeDifficulty(difficulty: difficult)
        return Int(columns * rows)
    }
}

// MARK: - Collection View Data Source
extension MemoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
        let card = deck[indexPath.row]
        cell.renderCardName(card.description, backImageName: "back")
        return cell
    }
}

// MARK: - Collection View Data Source
extension MemoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexes.count == 2 || selectedIndexes.contains(indexPath) {
            return
        }
        selectedIndexes.append(indexPath)
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.upturn()
        
        if selectedIndexes.count < 2 {
            return
        }
        
        let card1 = deck[selectedIndexes[0].row]
        let card2 = deck[selectedIndexes[1].row]
        
        if card1 == card2 {
            numberOfPairs += 1
            checkIfFinished()
            removeCards()
        } else {
            score += 1
            turnCardsFaceDown()
        }
    }
}

// MARK: - Actions
extension MemoryViewController {
    func checkIfFinished() {
        if numberOfPairs == deck.count / 2 {
            showFinalPopUp()
        }
    }
    
    func showFinalPopUp() {
        let alert = UIAlertController(title: "Great!", message: "You have won with score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func removeCards() {
        removeCardsAtPlaces(places: selectedIndexes)
        selectedIndexes = []
    }
    
    func removeCardsAtPlaces(places: [IndexPath]) {
        for index in selectedIndexes {
            let cardCell = collectionView.cellForItem(at: index) as! CardCell
            cardCell.remove()
        }
    }
    
    func turnCardsFaceDown() {
        execAfter(delay: 2.0) {
            self.downturnCardsAtPlaces(places: self.selectedIndexes)
            self.selectedIndexes = []
        }
    }
    
    func downturnCardsAtPlaces(places: [IndexPath]) {
        for index in selectedIndexes {
            let cardCell = collectionView.cellForItem(at: index) as! CardCell
            cardCell.downturn()
        }
    }
}
