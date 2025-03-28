//
//  Deck.swift
//  ConcentrationMemoryGame
//
//  Created by Yan's Mac on 3/20/25.
//

import Foundation

enum Suit: CustomStringConvertible {
    case Spades, Hearts, Diamonds, Clubs

    var description: String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

enum Rank: Int, CustomStringConvertible {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    var description: String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

struct Card: CustomStringConvertible, Equatable {
    // private is Type-based since Swift 3. in Swift 2 and before it was file-based
    private let rank: Rank
    private let suit: Suit

    // Custom init required IF using private on rank and suit.
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    var description: String {
        return "\(rank.description)_of_\(suit.description)"
    }
    
    static func ==(card1: Card, card2: Card) -> Bool {
        return card1.rank == card2.rank && card1.suit == card2.suit
    }
}

struct Deck {
    fileprivate var cards = [Card]()
    static func full() -> Deck {
        var deck = Deck()
        for i in Rank.Ace.rawValue...Rank.King.rawValue {
            for suit in [Suit.Spades, .Hearts, .Clubs, .Diamonds] {
                let card = Card(rank: Rank(rawValue: i)!, suit: suit)
                deck.cards.append(card)
            }
        }
        return deck
    }
    
    // Fisher-Yates (fast & uniform) Shuffle
    func shuffled() -> Deck {
        var list = cards
        for i in 0..<(list.count - 1) { // times to run = num of cards
            let j = Int(arc4random_uniform(UInt32(list.count - i))) /*random number between 0 and remaining cycles/times to run*/ + i // add i
            if i != j {
                list.swapAt(i, j)
            }
        }
        return Deck(cards: cards)
    }
    
    // Create subset of Deck
    func deckOfNumberOfCards(num: Int) -> Deck {
        return Deck(cards: Array(cards[0..<num]))
    }
    
    var count: Int {
        get {
            return cards.count
        }
    }
    
    subscript(index: Int) -> Card {
        get {
            return cards[index]
        }
    }

}

func +(deck1: Deck, deck2: Deck) -> Deck {
    return Deck(cards: deck1.cards + deck2.cards)
}

