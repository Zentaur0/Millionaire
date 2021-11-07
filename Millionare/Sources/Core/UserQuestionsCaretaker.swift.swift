//
//  UserQuestionsCaretaker.swift.swift
//  Millionare
//
//  Created by Антон Сивцов on 04.11.2021.
//

import Foundation

// MARK: - UserQuestionBuilder

final class UserQuestionBuilder {
    
    // MARK: - Properties
    
    private var question: String = ""
    private var firstOption: String = ""
    private var secondOption: String = ""
    private var thirdOption: String = ""
    private var fourthOption: String = ""
    private var correctAnswer: String = ""
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "newQuestion"
    
    // MARK: - Methods
    
    func build() -> Question {
        let answers = [firstOption, secondOption, thirdOption, fourthOption]
        let newQuestion = Question(
            question: question,
            answers: answers,
            correctAnswer: correctAnswer
        )
        return newQuestion
    }
    
    func addQuestion(_ question: String) -> Self {
        self.question = question
        return self
    }
    
    func addFirstOption(_ first: String) -> Self {
        self.firstOption = first
        return self
    }
    
    func addSecondOption(_ second: String) -> Self {
        self.secondOption = second
        return self
    }
    
    func addThirdOption(_ third: String) -> Self {
        self.thirdOption = third
        return self
    }
    
    func addFourthOption(_ fourth: String) -> Self {
        self.fourthOption = fourth
        return self
    }
    
    func addCorrectAnswer(_ right: String) -> Self {
        self.correctAnswer = right
        return self
    }
    
    func saveQuestion(_ question: Question) {
        do {
            var questions = self.loadQuestion()
            questions.append(question)
            let data = try encoder.encode(questions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadQuestion() -> [Question] {
        do {
            guard let data = UserDefaults.standard.value(forKey: key) as? Data,
                  let questions = try? decoder.decode([Question].self, from: data) else { return [] }
            return questions
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

