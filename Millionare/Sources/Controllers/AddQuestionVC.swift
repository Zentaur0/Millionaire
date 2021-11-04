//
//  AddQuestionVC.swift
//  Millionare
//
//  Created by Антон Сивцов on 31.10.2021.
//

import UIKit
import SnapKit

// MARK: - AddQuestionVC

final class AddQuestionVC: UIViewController {
    
    // MARK: - Properties
    
    private let newQuestionLabel = UILabel()
    private let firstAnswerLabel = UILabel()
    private let secondAnswerLabel = UILabel()
    private let thirdAnswerLabel = UILabel()
    private let fourthAnswerLabel = UILabel()
    private let rightAnswerLabel = UILabel()
    
    private let newQuestionTextField = UITextField()
    private let firstAnswerTextField = UITextField()
    private let secondAnswerTextField = UITextField()
    private let thirdAnswerTextField = UITextField()
    private let fourthAnswerTextField = UITextField()
    
    private let rightAnswerControl = UISegmentedControl(items: ["1", "2", "3", "4"])
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let containerView = UIStackView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupConstraints()
        setupKeyboardObservers()
    }
    
    // MARK: - Deinit
    
    deinit {
        removeKeyboardObservers()
    }
    
}

// MARK: - UIViewControllerMethods

extension AddQuestionVC: ViewControllerMethods {
    
    func setupVC() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        
        scrollView.keyboardDismissMode = .onDrag
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerView)
        
        containerView.addArrangedSubview(newQuestionLabel)
        containerView.addArrangedSubview(newQuestionTextField)
        containerView.addArrangedSubview(firstAnswerLabel)
        containerView.addArrangedSubview(firstAnswerTextField)
        containerView.addArrangedSubview(secondAnswerLabel)
        containerView.addArrangedSubview(secondAnswerTextField)
        containerView.addArrangedSubview(thirdAnswerLabel)
        containerView.addArrangedSubview(thirdAnswerTextField)
        containerView.addArrangedSubview(fourthAnswerLabel)
        containerView.addArrangedSubview(fourthAnswerTextField)
        containerView.addArrangedSubview(rightAnswerLabel)
        containerView.addArrangedSubview(rightAnswerControl)
        
        containerView.spacing = 5
        containerView.axis = .vertical
        containerView.distribution = .fillEqually
        
        newQuestionLabel.text = "Новый вопрос:"
        firstAnswerLabel.text = "Ответ №1:"
        secondAnswerLabel.text = "Ответ №2:"
        thirdAnswerLabel.text = "Ответ №3:"
        fourthAnswerLabel.text = "Ответ №4:"
        rightAnswerLabel.text = "Правильный ответ:"
        
        newQuestionTextField.layer.cornerRadius = 5
        newQuestionTextField.layer.borderColor = UIColor.systemGray2.cgColor
        newQuestionTextField.layer.borderWidth = 0.5
        
        firstAnswerTextField.layer.cornerRadius = 5
        firstAnswerTextField.layer.borderColor = UIColor.systemGray2.cgColor
        firstAnswerTextField.layer.borderWidth = 0.5
        
        secondAnswerTextField.layer.cornerRadius = 5
        secondAnswerTextField.layer.borderColor = UIColor.systemGray2.cgColor
        secondAnswerTextField.layer.borderWidth = 0.5
        
        thirdAnswerTextField.layer.cornerRadius = 5
        thirdAnswerTextField.layer.borderColor = UIColor.systemGray2.cgColor
        thirdAnswerTextField.layer.borderWidth = 0.5
        
        fourthAnswerTextField.layer.cornerRadius = 5
        fourthAnswerTextField.layer.borderColor = UIColor.systemGray2.cgColor
        fourthAnswerTextField.layer.borderWidth = 0.5
        
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(saveAction))
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
            $0.height.equalToSuperview().priority(.low)
        }
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        newQuestionTextField.snp.makeConstraints {
            $0.height.equalTo(35)
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
        guard let question = newQuestionTextField.text,
              let firstOption = firstAnswerTextField.text,
              let secondOption = secondAnswerTextField.text,
              let thirdOption = thirdAnswerTextField.text,
              let fourthOption = fourthAnswerTextField.text else {
                  ifNotAllFieldsIsFilledAlert()
                  return nil
              }
        
        let selectedIndex = rightAnswerControl.selectedSegmentIndex
        
        var correctAnswer: String
        
        if selectedIndex == 0 {
            correctAnswer = firstOption
        } else if selectedIndex == 1 {
            correctAnswer = secondOption
        } else if selectedIndex == 2 {
            correctAnswer = thirdOption
        } else if selectedIndex == 3 {
            correctAnswer = fourthOption
        } else {
            correctAnswer = ""
        }
        
        guard correctAnswer != "" else {
            ifNotAllFieldsIsFilledAlert()
            return nil
        }
        
        let newQuestion = Question(
            question: question,
            answers: [
                firstOption,
                secondOption,
                thirdOption,
                fourthOption
            ],
            correctAnswer: correctAnswer
        )
        
        return newQuestion
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
}

// MARK: - Actions

extension AddQuestionVC {
    
    @objc private func saveAction() {
        guard let newQuestion = prepareNewQuestion() else { return }
        
        let userQuestionsCaretaker = UserQuestionsCaretaker()
        userQuestionsCaretaker.saveQuestion(newQuestion)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150
    }

    @objc private func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0
    }
    
}
