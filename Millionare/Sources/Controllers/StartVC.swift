//
//  ViewController.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import UIKit

// MARK: - StartVC

final class StartVC: UIViewController {
    
    // MARK: - Properties
    
    private let playButton = UIButton(type: .system)
    private let resultButton = UIButton(type: .system)
    private let addQuestionButton = UIButton(type: .system)
    private let gameTitleLabel = UILabel()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

}

// MARK: - ViewControllerMethods

extension StartVC: ViewControllerMethods {
    
    func setupVC() {
        view.backgroundColor = .white
        setupPlayButton()
        setupResultButton()
        setupAddQuestionButton()
        setupGameTitleLabel()
    }
    
    func setupConstraints() {
        playButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(addQuestionButton.snp.top).offset(-10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.height.equalTo(40)
        }
        
        addQuestionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(resultButton.snp.top).offset(-10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.height.equalTo(40)
        }
        
        resultButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.height.equalTo(40)
        }
        
        gameTitleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
    }
    
}

// MARK: - Methods

extension StartVC {
    
    private func setupPlayButton() {
        view.addSubview(playButton)
        playButton.setTitle("Играть", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = 8
        playButton.backgroundColor = .systemPurple
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    }
    
    private func setupResultButton() {
        view.addSubview(resultButton)
        resultButton.setTitle("Результаты", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.layer.cornerRadius = 8
        resultButton.backgroundColor = .black
        resultButton.addTarget(self, action: #selector(resultButtonAction), for: .touchUpInside)
    }
    
    private func setupAddQuestionButton() {
        view.addSubview(addQuestionButton)
        addQuestionButton.setTitle("Добавить вопрос", for: .normal)
        addQuestionButton.setTitleColor(.white, for: .normal)
        addQuestionButton.layer.cornerRadius = 8
        addQuestionButton.backgroundColor = .systemOrange
        addQuestionButton.addTarget(self, action: #selector(addQuestionButtonAction), for: .touchUpInside)
    }
    
    private func setupGameTitleLabel() {
        view.addSubview(gameTitleLabel)
        gameTitleLabel.text = "Кто хочет стать миллионером?"
        gameTitleLabel.textColor = .black
        gameTitleLabel.textAlignment = .center
        gameTitleLabel.numberOfLines = 0
        gameTitleLabel.font = .boldSystemFont(ofSize: 27)
    }
    
    private func makeAlertToChooseStrategy() {
        let userQuestionsCaretaker = UserQuestionsCaretaker()
        let userQuestions = userQuestionsCaretaker.loadQuestion()
        
        let storage = QuestionsStorage.questions + userQuestions
        let session = GameSession()
        Game.shared.session = session
        
        let alertController = UIAlertController(
            title: "Выбор уровня",
            message: "Пожалуйста, выберете уровень сложности из предложенных",
            preferredStyle: .actionSheet
        )
        let randomStrategyAction = UIAlertAction(
            title: "Случайные вопросы",
            style: .default) { [weak self] _ in
                let randomStrategyProvider = RandomQuestionsStrategy()
                let questions = randomStrategyProvider.provideQuestions(from: storage)
                let vc = GameVC(questions: questions)
                vc.gameSession = session
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.navigationController?.pushViewController(vc, animated: true)
                })
            }
        let orderedStrategyAction = UIAlertAction(
            title: "Упорядочные вопросы",
            style: .default) { [weak self] _ in
                let orderedStrategyProvider = OrderedQuestionsStrategy()
                let questions = orderedStrategyProvider.provideQuestions(from: storage)
                let vc = GameVC(questions: questions)
                vc.gameSession = session
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.navigationController?.pushViewController(vc, animated: true)
                })
            }
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(randomStrategyAction)
        alertController.addAction(orderedStrategyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

// MARK: - Actions

extension StartVC {
    
    @objc private func playButtonAction() {
        makeAlertToChooseStrategy()
    }
    
    @objc private func resultButtonAction() {
        let vc = ResultsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addQuestionButtonAction() {
        let vc = AddQuestionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
