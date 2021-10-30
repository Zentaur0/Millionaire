//
//  GameSession.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import Foundation

// MARK: - GameSession

final class GameSession {
    
    // MARK: - Properties
    
    weak var delegate: GameDelegate?
    var rightAnswersCount = 0
    var tipsLeft = 0
    var moneyWon = 0
    
}

// MARK: - GameDelegate

extension GameSession: GameDelegate {
    
    func saveData(_ rightCount: Int, _ moneyWon: Int, _ tipsLeft: Int) {
        self.rightAnswersCount = rightCount
        self.moneyWon = moneyWon
        self.tipsLeft = tipsLeft
    }
    
}
