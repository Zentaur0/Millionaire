//
//  UserQuestionsCaretaker.swift.swift
//  Millionare
//
//  Created by Антон Сивцов on 04.11.2021.
//

import Foundation

final class UserQuestionsCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "newQuestion"
    
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
