//
//  ViewController+Extras.swift
//  ConcentrationMemoryGame
//
//  Created by Yan's Mac on 3/25/25.
//

import UIKit

extension UIViewController {
    func execAfter(delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
}
