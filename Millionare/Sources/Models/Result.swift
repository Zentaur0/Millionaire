//
//  Result.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import Foundation

struct Result: Codable, Equatable {
    let rightAnswers: Int
    let moneyWon: Int
    let tipsUsed: Int
    
    var winProcentage: Double {
        100 * Double(rightAnswers) / Double(QuestionsStorage.questions.count)
    }
    
    var date: Date {
        Date()
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.date == rhs.date
    }
}
