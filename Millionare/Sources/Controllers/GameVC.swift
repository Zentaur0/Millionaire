//
//  GameVC.swift
//  Millionare
//
//  Created by Антон Сивцов on 30.10.2021.
//

import UIKit

protocol GameDelegate: AnyObject {
    func saveData(_ rightCount: Int, _ moneyWon: Int, _ tipsLeft: Int)
}

// MARK: - GameVC

final class GameVC: UIViewController {
    
    // MARK: - Properties
    
    weak var gameSession: GameSession?
    private var answersContainer: UIStackView?
    private var questionCount = 0
    private var rightAnswersCount = 0
    private var money = 0
    private var tipsUsed = 0
    private let questionLabel = UILabel()
    private let resultLabel = UILabel()
    private let rightAnswersLabel = UILabel()
    private let tipsStackView = UIStackView()
    private let questions: [Question]
    
    // MARK: - Init
    
    init(questions: [Question]) {
        self.questions = questions
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupConstraints()
        setupQuestions()
    }
    
}

// MARK: - ViewControllerMethods

extension GameVC: ViewControllerMethods {
    
    func setupVC() {
        gameSession?.delegate = self
        
        navigationController?.navigationBar.isHidden = false
        title = "Игра"
        view.backgroundColor = .white
        
        view.addSubview(questionLabel)
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.textColor = .black
        
        view.addSubview(rightAnswersLabel)
        rightAnswersLabel.font = .systemFont(ofSize: 17)
        rightAnswersLabel.textAlignment = .center
        rightAnswersLabel.textColor = .black
        rightAnswersLabel.text = "Правильных ответов: 0"
        
        view.addSubview(resultLabel)
        resultLabel.font = .boldSystemFont(ofSize: 20)
        resultLabel.textAlignment = .center
        
        setupTipsContainer()
    }
    
    func setupConstraints() {
        questionLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        resultLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(70)
            $0.bottom.equalTo(rightAnswersLabel.snp.top).inset(-15)
        }
        
        rightAnswersLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(70)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        tipsStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.bottom.equalTo(rightAnswersLabel.snp.top).offset(-80)
            $0.height.equalTo(40)
        }
    }
    
}

// MARK: - Methods

extension GameVC {
    
    private func setupResultLabel(isRight: Bool) {
        if isRight {
            let attrStr = NSAttributedString(string: "Верно!",
                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
            resultLabel.attributedText = attrStr
        } else {
            let attrStr = NSAttributedString(string: "Ошибка!",
                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
            resultLabel.attributedText = attrStr
        }
    }
    
    private func setupTipsContainer() {
        view.addSubview(tipsStackView)
        tipsStackView.axis = .horizontal
        tipsStackView.spacing = 5
        tipsStackView.distribution = .fillEqually
        
        let callFriendTip: Tip = .callFriend
        let hallHelpTip: Tip = .hallHelp
//        let tip50to50: Tip = .tip50to50
        
        let tips = [callFriendTip, hallHelpTip]
        
        tips.forEach { tip in
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 10
            button.setTitleColor(.white, for: .normal)
            button.setTitle(tip.rawValue, for: .normal)
            button.addTarget(self, action: #selector(takeTipAction), for: .touchUpInside)
            switch tip {
            case .callFriend:
                button.backgroundColor = .systemPink
                button.tag = 1
            case .hallHelp:
                button.backgroundColor = .systemIndigo
                button.tag = 2
            case .tip50to50:
                button.backgroundColor = .systemTeal
            }
            tipsStackView.addArrangedSubview(button)
        }
    }
    
    private func setupQuestions(_ index: Int = 0) {
        guard index < questions.count else {
            endGame(true)
            return
        }
        
        answersContainer?.removeFromSuperview()
        answersContainer = nil
        resultLabel.text = ""
        
        answersContainer = UIStackView()
        questionLabel.text = questions[index].question
        
        questions[index].answers.shuffled().forEach { text in
            setupAnswersContainer()
            setupAnswerButton(text, index)
        }
        
    }
    
    private func setupAnswersContainer() {
        guard let answersContainer = answersContainer else { return }
        
        view.addSubview(answersContainer)
        answersContainer.axis = .vertical
        answersContainer.distribution = .fillEqually
        answersContainer.spacing = 10
        
        answersContainer.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(200)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    private func setupAnswerButton(_ text: String, _ index: Int) {
        guard let answersContainer = answersContainer else { return }
        
        let answerButton = UIButton(type: .system)
        answerButton.setTitle(text, for: .normal)
        answerButton.layer.cornerRadius = 8
        answerButton.backgroundColor = .blue
        answerButton.setTitleColor(.white, for: .normal)
        answersContainer.addArrangedSubview(answerButton)
        
        if questions[index].correctAnswer == text {
            answerButton.tag = 1
        }
        
        answerButton.addTarget(self, action: #selector(chooseRightAnswer(_:)), for: .touchUpInside)
    }
    
    private func endGame(_ success: Bool) {
        let message = success ? "Вы выиграли" : "Вы проиграли"
        let alertController = UIAlertController(
            title: "Игра закончена",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .cancel) { [weak self] _ in
                self?.saveData(
                    self?.rightAnswersCount ?? 0,
                    self?.money ?? 0,
                    self?.tipsUsed ?? 0
                )
                Game.shared.saveResults()
                Game.shared.session = nil
                self?.navigationController?.popViewController(animated: true)
            }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
}

// MARK: - Actions

extension GameVC {
    
    @objc private func chooseRightAnswer(_ button: UIButton) {
        if button.tag == 1 {
            button.backgroundColor = .systemGreen
            setupResultLabel(isRight: true)
            rightAnswersCount += 1
        } else {
            button.backgroundColor = .systemRed
            setupResultLabel(isRight: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.endGame(false)
            }
            return
        }
        
        answersContainer?.isUserInteractionEnabled = false
        questionCount += 1
        money += 1000
        
        let rightAnswerText = String(format: "Правильных ответов: %@", String(rightAnswersCount))
        rightAnswersLabel.text = rightAnswerText
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.setupQuestions(self.questionCount)
        }
    }
    
    @objc private func takeTipAction(_ button: UIButton) {
        switch button.titleLabel?.text {
        case "Call a friend":
            createRandomTipAlert(button: button)
        case "Ask Hall":
            createRandomTipAlert(button: button)
        case "50/50":
            activate50to50()
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    private func createRandomTipAlert(button: UIButton) {
        guard let answerButton = answersContainer?.arrangedSubviews.randomElement() as? UIButton,
              let answer = answerButton.titleLabel?.text else {
                  return
              }
        
        var message = ""
        if button.tag == 1 {
            message = String(format: "Ваш друг считает, что верный ответ: %@", answer)
        } else if button.tag == 2 {
            message = String(format: "Зал подсказывает, что верный ответ: %@", answer)
        }
        button.backgroundColor = .systemGray
        button.isUserInteractionEnabled = false
        tipsUsed += 1
        
        let alertController = UIAlertController(
            title: "Подсказка",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func activate50to50() {
        
    }
    
}

// MARK: - GameDelegate

extension GameVC: GameDelegate {
    
    func saveData(_ rightCount: Int, _ moneyWon: Int, _ tipsLeft: Int) {
        gameSession?.saveData(rightCount, moneyWon, tipsLeft)
    }
    
}
