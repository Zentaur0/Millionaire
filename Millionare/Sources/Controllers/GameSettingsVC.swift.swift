//
//  GameSettingsVC.swift.swift
//  Millionare
//
//  Created by Антон Сивцов on 31.10.2021.
//

import UIKit

private enum SettingsType: Int {
    case level
}

final class GameSettingsVC: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private let settings: [String] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - ViewControllerMethods

extension GameSettingsVC: ViewControllerMethods {
    
    func setupVC() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupLevelCell(cell: UITableViewCell) {
        let switchcontr = UISwitch()
        
        
        
    }
    
}

// MARK: - UITableViewDataSource

extension GameSettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        let type = SettingsType(rawValue: indexPath.row)
//
//        switch type {
//        case .level:
//            <#code#>
//        case .none:
            return cell
//        }
    }
    
}

// MARK: - UITableViewDelegate

extension GameSettingsVC: UITableViewDelegate {}

final class LevelCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let switchControl = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(switchControl)
        
        switchControl.addTarget(self, action: #selector(switchControlAction), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        
    }
    
    private func setupSwitch() {
        if switchControl.isOn {
            
        } else {
            
        }
        
        
//        let randomStrategyAction = UIAlertAction(
//            title: "Случайные вопросы",
//            style: .default) { [weak self] _ in
//                let randomStrategyProvider = RandomQuestionsStrategy()
//                let questions = randomStrategyProvider.provideQuestions(from: storage)
//                let vc = GameVC(questions: questions)
//                vc.gameSession = session
//                self?.dismiss(animated: true, completion: { [weak self] in
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                })
//            }
//        let orderedStrategyAction = UIAlertAction(
//            title: "Упорядочные вопросы",
//            style: .default) { [weak self] _ in
//                let orderedStrategyProvider = OrderedQuestionsStrategy()
//                let questions = orderedStrategyProvider.provideQuestions(from: storage)
//                let vc = GameVC(questions: questions)
//                vc.gameSession = session
//                self?.dismiss(animated: true, completion: { [weak self] in
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                })
//            }
    }
    
    @objc private func switchControlAction() {
        let userQuestionsCaretaker = UserQuestionsCaretaker()
        let userQuestions = userQuestionsCaretaker.loadQuestion()
        
        let storage = QuestionsStorage.questions + userQuestions
        let session = GameSession()
        Game.shared.session = session
        if switchControl.isOn {
            let randomStrategyProvider = RandomQuestionsStrategy()
            let questions = randomStrategyProvider.provideQuestions(from: storage)
        } else {
            let orderedStrategyProvider = OrderedQuestionsStrategy()
            let questions = orderedStrategyProvider.provideQuestions(from: storage)
        }
    }
    
}
