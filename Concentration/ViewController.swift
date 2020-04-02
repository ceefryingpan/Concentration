//
//  ViewController.swift
//  Concentration
//
//  Created by Charles Pan on 3/31/20.
//  Copyright © 2020 Charles Pan. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emoji.removeAll()
        emojiChoices = emojiThemes.randomElement()!
        usedEmoji = [Bool](repeating: false, count: emojiChoices.count)
        updateViewFromModel()
        flipCountLabel.text = "Welcome!"
    }
    
    func updateViewFromModel() {
        flipCountLabel.text = "Score: \(game.score)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.changed {
                if card.isFaceUp {
                    UIView.transition(with: button, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    UIView.transition(with: button, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 0) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
                }
            }
        }
        if game.isFinished {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                UIView.transition(with: button, duration: 0.5, options: [.transitionFlipFromRight], animations: nil, completion: nil)
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            newGameButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    var facesTheme = ["😎", "🤫", "😋", "😍", "🙄", "🤔", "😫", "😉"]
    var animalsTheme = ["🐶", "🦊", "🐼", "🐸", "🐮", "🦁", "🐥", "🐯"]
    var handsTheme = ["🙌", "👏", "👍", "✌️", "👌", "🤙", "💪", "🤝"]
    var foodTheme = ["🍎", "🍊", "🍌", "🍉", "🍑", "🍆", "🥑", "🥦"]
    var candyTheme = ["🍩", "🍭", "🍿", "🍪", "🍬", "🎂", "🧁", "🍦"]
    var sportsTheme = ["🏋️", "🏂", "⛹️‍♀️", "🏇", "🤽‍♀️", "🤺", "🏊", "🏌️"]
    
    lazy var emojiThemes = [facesTheme, animalsTheme, handsTheme, foodTheme, candyTheme, sportsTheme]
    lazy var emojiChoices = emojiThemes.randomElement()!
    
    var emoji = [Int:String]()
    lazy var usedEmoji = [Bool](repeating: false, count: emojiChoices.count)
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            var randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            while usedEmoji[randomIndex] {
                randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            }
            emoji[card.identifier] = emojiChoices[randomIndex]
            usedEmoji[randomIndex] = true
        }
        
        return emoji[card.identifier] ?? "?"
    }
}

