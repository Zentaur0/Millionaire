//
//  Game.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import Foundation

// MARK: - Game

class Game {
    
    // MARK: - Static
    
    static let shared = Game()
    
    // MARK: - Properties
    
    var session: GameSession?
    var results: [Result] = []
    private let careTaker = GameCaretaker()
    
    // MARK: - Init
    
    private init() {
        self.results = careTaker.loadResults()
    }
    
    // MARK: - Methods
    
    func saveResults() {
        let result = Result(
            rightAnswers: session?.rightAnswersCount.value ?? 0,
            moneyWon: session?.moneyWon ?? 0,
            tipsUsed: session?.tipsLeft ?? 0
        )
        results.append(result)
        careTaker.saveResults(results)
        session = nil
    }
    
}
