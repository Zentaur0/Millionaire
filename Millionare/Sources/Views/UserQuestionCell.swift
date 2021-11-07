//
//  UserQuestionCell.swift
//  Millionare
//
//  Created by Антон Сивцов on 06.11.2021.
//

import UIKit

// MARK: - UserQuestionCell

final class UserQuestionCell: UITableViewCell {
    
    // MARK: - Static
    
    static let reuseIdentifier = "UserQuestionCell"
    
    // MARK: - Properties
    
    private let cellLabel = UILabel()
    let cellTextField = UITextField()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension UserQuestionCell {
    
    func configureCell(text: String) {
        cellLabel.text = text
    }
    
    private func setupCell() {
        selectionStyle = .none
        separatorInset = .zero
        contentView.addSubview(cellLabel)
        
        contentView.addSubview(cellTextField)
        cellTextField.layer.cornerRadius = 5
        cellTextField.layer.borderColor = UIColor.systemGray2.cgColor
        cellTextField.layer.borderWidth = 0.5
    }
    
    private func setupConstraints() {
        cellLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(10)
        }
        
        cellTextField.snp.makeConstraints {
            $0.top.equalTo(cellLabel.snp.bottom).inset(-10)
            $0.trailing.leading.bottom.equalToSuperview().inset(10)
        }
    }
    
}
