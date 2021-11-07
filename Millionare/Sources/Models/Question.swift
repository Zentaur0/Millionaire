//
//  Question.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

enum Tip: String {
    case callFriend = "Звонок другу"
    case hallHelp = "Помощь зала"
    case tip50to50 = "50/50"
}

struct Question: Codable {
    let question: String
    let answers: [String]
    let correctAnswer: String
}
