//
//  ResultsVC.swift.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import UIKit

final class ResultsVC: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var savedGames = Game.shared.results.sorted(by: { $0.rightAnswers > $1.rightAnswers })
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupConstraints()
    }
    
}

// MARK: - ViewControllerMethods

extension ResultsVC: ViewControllerMethods {
    
    func setupVC() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension ResultsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.reuseID,
                                                       for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        
        let game = savedGames[indexPath.row]
        let money = game.moneyWon
        let usedTips = game.tipsUsed
        let winProcentageString = String(format: "процент выигрыша: %.1f", game.winProcentage)

        let title = "Выигрыш: \(money)₽ \nиспользовано подсказок: \(usedTips) \n\(winProcentageString)%"

        cell.configure(text: title)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ResultsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gameCaretacer = GameCaretaker()
            gameCaretacer.removeResult(savedGames[indexPath.row])
            savedGames.remove(at: indexPath.row)
            gameCaretacer.saveResults(savedGames)
            tableView.reloadData()
        }
    }
}
