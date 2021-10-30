//
//  GameCaretaker.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import Foundation

// MARK: - GameCaretaker

final class GameCaretaker {
    
    // MARK: - Properties
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let key = "results"
    
    // MARK: - Methods
    
    func saveResults(_ results: [Result]) {
        do {
            let data: Data = try encoder.encode(results)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadResults() -> [Result] {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data,
              let results = try? decoder.decode([Result].self, from: data) else {
                  return []
              }
        return results
    }
    
    func removeResult(_ result: Result) {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data,
              var results = try? decoder.decode([Result].self, from: data),
              let index = results.firstIndex(where: { $0.date == result.date }) else {
                  return
              }
        
        results.remove(at: index)
        self.saveResults(results)
    }
    
}
