//
//  RandomQuestionStrategy.swift
//  Millionare
//
//  Created by Антон Сивцов on 31.10.2021.
//

import Foundation

protocol QuestionStrategy {
    func provideQuestions(from questions: [Question]) -> [Question]
}

final class RandomQuestionsStrategy: QuestionStrategy {
    
    func provideQuestions(from questions: [Question]) -> [Question] {
        questions.shuffled()
    }
    
}

final class OrderedQuestionsStrategy: QuestionStrategy {
    
    func provideQuestions(from questions: [Question]) -> [Question] {
        questions
    }
    
}
