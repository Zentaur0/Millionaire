//
//  UserQuestionSegmentedCell.swift
//  Millionare
//
//  Created by Антон Сивцов on 07.11.2021.
//

import UIKit

// MARK: - UserQuestionSegmentedCell

final class UserQuestionSegmentedCell: UITableViewCell {
    
    // MARK: - Static
    
    static let reuseIdentifier = "UserQuestionSegmentedCell"
    
    // MARK: - Properties
    
    var onIndexSelected: ((Int) -> Void)?
    private let cellLabel = UILabel()
    let rightAnswerControl = UISegmentedControl(items: ["1", "2", "3", "4"])
    
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

// MARK: Methods

extension UserQuestionSegmentedCell {
    
    func configureCell(text: String) {
        self.cellLabel.text = text
    }
    
    private func setupCell() {
        contentView.addSubview(cellLabel)
        contentView.addSubview(rightAnswerControl)
        selectionStyle = .none
        
        rightAnswerControl.addTarget(self, action: #selector(returnAnswerControlIndex), for: .valueChanged)
    }
    
    private func setupConstraints() {
        cellLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(10)
        }
        
        rightAnswerControl.snp.makeConstraints {
            $0.top.equalTo(cellLabel.snp.bottom).inset(-10)
            $0.trailing.leading.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func returnAnswerControlIndex(_ control: UISegmentedControl) {
        onIndexSelected?(control.selectedSegmentIndex)
    }
    
}
