//
//  ViewController.swift
//  ConcentrationMemoryGame
//
//  Created by Yan's Mac on 3/18/25.
//

import UIKit

enum Difficulty: Int, CaseIterable {
    case Easy, Medium, Hard
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Menu Screen Setup
enum ButtonTitle: String {
    case easy = "EASY"
    case medium = "MEDIUM"
    case hard = "HARD"
}

enum ButtonColor {
    case emerald
    case sunFlower
    case alizarin
    
    var color: UIColor {
        switch self {
        case .alizarin:
            .alizarin()
        case .emerald:
            .emerald()
        case .sunFlower:
            .sunFlower()
        }
    }
}

private extension ViewController {
    private enum ButtonLayout {
        static let buttonWidth: CGFloat = 200
        static let buttonHeight: CGFloat = 50
        static let easyButtonCenterYMultiplier: CGFloat = 0.5
        static let mediumButtonCenterYMultiplier: CGFloat = 1.0
        static let hardButtonCenterYMultiplier: CGFloat = 1.5
    }
    func setup() {
        view.backgroundColor = .greenSea()
        createButton(title: .easy, color: ButtonColor.emerald.color, centerMultiplier: ButtonLayout.easyButtonCenterYMultiplier, difficulty: .Easy)
        createButton(title: .medium, color: ButtonColor.sunFlower.color, centerMultiplier: ButtonLayout.mediumButtonCenterYMultiplier, difficulty: .Medium)
        createButton(title: .hard, color: ButtonColor.alizarin.color, centerMultiplier: ButtonLayout.hardButtonCenterYMultiplier, difficulty: .Hard)
    }
    
    private func createButton(title: ButtonTitle, color: UIColor, centerMultiplier: CGFloat, difficulty: Difficulty) {
        let center = CGPoint(x: view.center.x, y: view.center.y * centerMultiplier)
        buildBtnWithCenter(center: center, title: title, color: color, difficulty: difficulty)
    }
    
    func buildBtnWithCenter(center: CGPoint, title: ButtonTitle, color:UIColor, difficulty: Difficulty) {
        // TODO: build button
        let button = UIButton()
        button.setTitle(title.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: ButtonLayout.buttonWidth, height: ButtonLayout.buttonHeight))
        button.center = center
        button.backgroundColor = color
        button.tag = difficulty.rawValue
        
        button.addTarget(self, action: #selector(onDifficultyTapped(sender:)), for: .touchUpInside)
        view.addSubview(button)
    }
}

// MARK: - Menu Button Actions
extension ViewController {
    @objc func onDifficultyTapped(sender: UIButton) {
        guard sender.tag < Difficulty.allCases.count else { return }
        newGameDifficulty(Difficulty.allCases[sender.tag])
    }
    
    func newGameDifficulty(_ difficulty: Difficulty) {
        let gameDifficultyViewController = MemoryViewController(difficulty: difficulty)
//        present(gameDifficultyViewController, animated: true, completion: nil)
        navigationController?.pushViewController(gameDifficultyViewController, animated: true)
    }
}

extension UIColor {
    class func greenSea() -> UIColor {
        return .colorComponents(components: (22, 160, 133))
    }
    
    class func emerald() -> UIColor {
        return .colorComponents(components: (46, 204, 113))
    }
    
    class func sunFlower() -> UIColor {
        return .colorComponents(components: (24, 196, 15))
    }
    
    class func alizarin() -> UIColor {
        return .colorComponents(components: (231, 76, 60))
    }
}

private extension UIColor {
    class func colorComponents(components: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        return UIColor(red: components.0/255, green: components.1/255, blue: components.2/255, alpha: 1)
    }
}
