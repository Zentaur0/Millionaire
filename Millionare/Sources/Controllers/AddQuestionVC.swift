//
//  AddQuestionVC.swift
//  Millionare
//
//  Created by Антон Сивцов on 31.10.2021.
//

import UIKit
import SnapKit

// MARK: - NewQuestionCellType

private enum NewQuestionCellType: Int {
    case textFieldType
    case segmentedControlType
}

// MARK: - AddQuestionVC

final class AddQuestionVC: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private let addNewFieldButton = UIButton(type: .system)
    private let userQuestionsBuilder = UserQuestionBuilder()
    private var numberOfRows = 1
    private var numberOfSections = 1
    private let titles = [
        ["Новый вопрос:",
        "Ответ №1:",
        "Ответ №2:",
        "Ответ №3:",
        "Ответ №4:"],
        ["Правильный ответ:"]
    ]
    
    private var textFieldsTexts = [String]()
    private var isTextFieldIsEmpty = true
    private var selectedSegmentIndex = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupConstraints()
    }
    
}

// MARK: - UIViewControllerMethods

extension AddQuestionVC: ViewControllerMethods {
    
    func setupVC() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserQuestionCell.self,
                           forCellReuseIdentifier: UserQuestionCell.reuseIdentifier)
        tableView.register(UserQuestionSegmentedCell.self,
                           forCellReuseIdentifier: UserQuestionSegmentedCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        
        view.addSubview(addNewFieldButton)
        addNewFieldButton.backgroundColor = .systemYellow
        addNewFieldButton.layer.cornerRadius = 8
        addNewFieldButton.layer.borderWidth = 0.5
        addNewFieldButton.layer.borderColor = UIColor.lightGray.cgColor
        addNewFieldButton.setTitle("Сохранить", for: .normal)
        addNewFieldButton.addTarget(self, action: #selector(addNewFieldAction), for: .touchUpInside)
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalTo(addNewFieldButton.snp.top).inset(-10)
        }
        
        addNewFieldButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(150)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
}

// MARK: - Methods {

extension AddQuestionVC {
    
    private func ifNotAllFieldsIsFilledAlert() {
        let alert = UIAlertController(
            title: "Упс",
            message: "Пожалуйста, заполните все поля",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        )
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func prepareNewQuestion() -> Question? {
        print(textFieldsTexts)
        let question = textFieldsTexts[0]
        let firstOption = textFieldsTexts[1]
        let secondOption = textFieldsTexts[2]
        let thirdOption = textFieldsTexts[3]
        let fourthOption = textFieldsTexts[4]
        
        var correctAnswer: String

        if selectedSegmentIndex == 0 {
            correctAnswer = firstOption
        } else if selectedSegmentIndex == 1 {
            correctAnswer = secondOption
        } else if selectedSegmentIndex == 2 {
            correctAnswer = thirdOption
        } else if selectedSegmentIndex == 3 {
            correctAnswer = fourthOption
        } else {
            correctAnswer = ""
        }

        guard correctAnswer != "" else {
            ifNotAllFieldsIsFilledAlert()
            return nil
        }
        
        let newQuestion = userQuestionsBuilder
            .addQuestion(question)
            .addFirstOption(firstOption)
            .addSecondOption(secondOption)
            .addThirdOption(thirdOption)
            .addFourthOption(fourthOption)
            .addCorrectAnswer(correctAnswer)
            .build()
        
        return newQuestion
    }
    
    private func configureCellType(indexPath: IndexPath) -> UITableViewCell {
        let type = NewQuestionCellType(rawValue: indexPath.section)
        let title = titles[indexPath.section][indexPath.row]
        
        switch type {
        case .textFieldType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserQuestionCell.reuseIdentifier,
                                                           for: indexPath) as? UserQuestionCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(text: title)
            cell.cellTextField.delegate = self
            
            return cell
        case .segmentedControlType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserQuestionSegmentedCell.reuseIdentifier,
                                                           for: indexPath) as? UserQuestionSegmentedCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(text: title)
            cell.onIndexSelected = { [weak self] selectedNumber in
                self?.selectedSegmentIndex = selectedNumber
            }
            
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
}

// MARK: - Actions

extension AddQuestionVC {
    
    @objc private func saveAction() {
        guard let newQuestion = prepareNewQuestion() else { return }
        
        userQuestionsBuilder.saveQuestion(newQuestion)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addNewFieldAction() {
        if !isTextFieldIsEmpty {
            guard numberOfSections != 2 else { return }
            guard numberOfRows != 5 else {
                numberOfSections += 1
                numberOfRows += 1
                tableView.reloadData()
                addNewFieldButton.isHidden = true
                return
            }
            if numberOfSections == 1 {
                numberOfRows += 1
                tableView.reloadData()
            }
        }
        isTextFieldIsEmpty = true
    }
    
}

// MARK: - UITableViewDataSource

extension AddQuestionVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfRows == 6 {
            let type = NewQuestionCellType(rawValue: section)
            switch type {
            case .textFieldType:
                return 5
            case .segmentedControlType:
                return 1
            case .none:
                return 0
            }
        } else {
            return numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureCellType(indexPath: indexPath)
    }
    
}

// MARK: - UITableViewDelegate

extension AddQuestionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
}

extension AddQuestionVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text,
              !text.isEmpty,
              !textFieldsTexts.contains(text) else { return }
        isTextFieldIsEmpty = false
        textField.isUserInteractionEnabled = false
        textFieldsTexts.append(text)
    }
    
}
