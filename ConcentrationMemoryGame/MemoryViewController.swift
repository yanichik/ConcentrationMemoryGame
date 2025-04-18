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
    private var covHeight: CGFloat = 0
    private var covWidth: CGFloat = 0
    private var timerLabel = UILabel()
    private var timer: Timer?
    private var timerCount: Double = 0.00
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        deck = Deck()
        super.init(nibName: nil, bundle: nil)
        print("after super.init safe area insets: \(view.safeAreaInsets)")
        deck = createDeck(numCards: numCardsNeededDifficulty(difficult: difficulty))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    override func viewDidLoad() {
        print("viewDidLoad safe area insets: \(view.safeAreaInsets)")
        super.viewDidLoad()
        print("after super.viewDidLoad safe area insets: \(view.safeAreaInsets)")
        setupCollectionView()
        start()
        setupTimer()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear safe area insets: \(view.safeAreaInsets)")
        super.viewWillAppear(animated)
        print("after super.viewWillAppear safe area insets: \(view.safeAreaInsets)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear safe area insets: \(view.safeAreaInsets)")
        super.viewDidAppear(animated)
        print("after super.viewDidAppear safe area insets: \(view.safeAreaInsets)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        collectionView.collectionViewLayout.invalidateLayout()
//        let space: CGFloat = 5  // empty space between cards
//        let layout = layoutCardSize(cardSize: cardSize(difficulty: difficulty, space: space), space: space)
//        collectionView.setCollectionViewLayout(layout, animated: true)
//        collectionView.reloadData()
//    }
//    override func viewSafeAreaInsetsDidChange() {
//        super.viewSafeAreaInsetsDidChange()
//        collectionView.collectionViewLayout.invalidateLayout()
//        collectionView.reloadData()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
//    }


    
//    override func viewDidLayoutSubviews() {
//        setupCollectionView()
//        start()
//    }
    
    private func setupTimer() {
        navigationItem.titleView = timerLabel
    }
    
    private func startTimer() {
        /*
         config timer label
         start timer
         */
        timerLabel.text = "0.00"
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerLabel.widthAnchor.constraint(equalToConstant: 100),
            timerLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func fireTimer() {
        timerCount += 0.01
        timerLabel.text = String(format: "%.2f", timerCount)
        print(String(format: "%.2f", timerCount))
    }
    
    private func start() {
        deck = createDeck(numCards: numCardsNeededDifficulty(difficult: difficulty))
        collectionView.reloadData()
    }
    
    private func createDeck(numCards: Int) -> Deck{
        let fullDeck = Deck.full().shuffled()
        let halfDeck = fullDeck.deckOfNumberOfCards(num: numCards/2).shuffled()
        return (halfDeck + halfDeck)
    }
}

// MARK: - Collection View Setup
private extension MemoryViewController {
    func setupCollectionView() {
        if collectionView == nil {
            view.backgroundColor = .greenSea()
            
            let space: CGFloat = 5  // empty space between cards
            (covWidth, covHeight) = collectionViewSize(difficulty: difficulty, space: space)
            let layout = layoutCardSize(cardSize: cardSize(difficulty: difficulty, space: space), space: space)
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.center = view.center
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isScrollEnabled = false
            collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
            collectionView.backgroundColor = .clear
            self.edgesForExtendedLayout = .all
            
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
    
    func layoutCardSize(cardSize: (cardWidth: CGFloat, cardHeight: CGFloat), space: CGFloat) -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
//        layout.itemSize = CGSize(width: cardSize.cardWidth, height: cardSize.cardHeight)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        return layout
    }
    
    func collectionViewSize(difficulty: Difficulty, space: CGFloat) -> (CGFloat, CGFloat) {
        let (columns, rows) = sizeDifficulty(difficulty: difficulty)
        let (cardWidth, cardHeight) = cardSize(difficulty: difficulty, space: space)
        let covWidth = columns * (cardWidth + 2 * space)
        let covHeight = rows * (cardHeight + space)
        return (covWidth, covHeight)
        
    }
    
    func cardSize(difficulty: Difficulty, space: CGFloat) -> (CGFloat, CGFloat) {
        let lengthWidthRatio: CGFloat = 1.5
        let (_, rows) = sizeDifficulty(difficulty: difficulty)
        let safeAreaInsetsHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let cardHeight: CGFloat = (safeAreaInsetsHeight) / rows - 2 * space
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
            timer?.invalidate()
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

extension MemoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*
         safe size width and height
         interitem space
         line space
         */
        let space: CGFloat = 5
        let (cols, rows) = sizeDifficulty(difficulty: difficulty)
        let safeHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let safeWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let itemHeight = (safeHeight - rows * space * 2) / rows
        let itemWidgth = (safeWidth - cols * space * 2) / cols
        return CGSize(width: itemWidgth, height: itemHeight)
    }
}
