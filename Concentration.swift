//
//  Concentration.swift
//  Concentration
//
//  Created by Charles Pan on 3/31/20.
//  Copyright © 2020 Charles Pan. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]()
    
    var indexOfFaceUp: Int?
    
    var score = 0
    
    var seenIdentifiers = [Int]()
    
    var isFinished = false
    
    func chooseCard(at index: Int) {
        for cardIndex in cards.indices {
            cards[cardIndex].changed = false
        }
        
        if !cards[index].isMatched {  // if chosen card isn't already matched
            if let matchIndex = indexOfFaceUp {  // if there's already a faceup card
                if matchIndex != index {  // the chosen card is not that faceup card
                    if cards[matchIndex].identifier == cards[index].identifier {  // check if cards match
                        score += 2
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                    } else {
                        if seenIdentifiers.contains(cards[index].identifier) {
                            score -= 1
                        } else {
                            seenIdentifiers.append(cards[index].identifier)
                        }
                        
                        if seenIdentifiers.contains(cards[matchIndex].identifier) {
                            score -= 1
                        } else {
                            seenIdentifiers.append(cards[matchIndex].identifier)
                        }
                    }
                    cards[index].isFaceUp = true
                    cards[index].changed = true
                    indexOfFaceUp = nil
                }
            } else {  // if there's no faceup card already
                for flipDownIndex in cards.indices {
                    if cards[flipDownIndex].isFaceUp {
                        cards[flipDownIndex].changed = true
                    }
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                cards[index].changed = true
                indexOfFaceUp = index
            }
        }
        
        isFinished = true
        for cardIndex in cards.indices {
            if !cards[cardIndex].isMatched {
                isFinished = false
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
