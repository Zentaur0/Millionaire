//
//  Question.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

enum Tip: String {
    case callFriend = "Call a friend"
    case hallHelp = "Ask Hall"
    case tip50to50 = "50/50"
}

struct Question {
    let question: String
    let answers: [String]
    let correctAnswer: String
}
