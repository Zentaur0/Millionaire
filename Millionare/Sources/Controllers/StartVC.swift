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
        setupGameTitleLabel()
    }
    
    func setupConstraints() {
        playButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
        
        resultButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(70)
            $0.width.equalTo(200)
            $0.height.equalTo(60)
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
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = 8
        playButton.backgroundColor = .systemPurple
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    }
    
    private func setupResultButton() {
        view.addSubview(resultButton)
        resultButton.setTitle("Results", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.layer.cornerRadius = 8
        resultButton.backgroundColor = .black
        resultButton.addTarget(self, action: #selector(resultButtonAction), for: .touchUpInside)
    }
    
    private func setupGameTitleLabel() {
        view.addSubview(gameTitleLabel)
        gameTitleLabel.text = "Who Wants to Be a Millionaire?"
        gameTitleLabel.textColor = .black
        gameTitleLabel.textAlignment = .center
        gameTitleLabel.numberOfLines = 0
        gameTitleLabel.font = .boldSystemFont(ofSize: 27)
    }
    
}

// MARK: - Actions

extension StartVC {
    
    @objc private func playButtonAction() {
        let session = GameSession()
        Game.shared.session = session
        let vc = GameVC()
        vc.gameSession = session
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func resultButtonAction() {
        let vc = ResultsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
