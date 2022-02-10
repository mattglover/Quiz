//
//  MainViewController.swift
//  Quiz
//
//  Created by Megan Wynn on 29/09/2021.
//

import UIKit

class MainViewController: UIViewController {

    var quizRoundManager: QuizRoundResultsManager!
    
    // MARK: - Properties
    private var collectionView: UICollectionView?
    private var identifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(quizRoundManager != nil)
        view.backgroundColor = .backgroundColor
        title = "Categories"
        setUpNavigationView()
        setupCollectionView()
    }

    // MARK: - Setup
    private func setUpNavigationView() {
        navigationController?.navigationBar.barTintColor = .backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.titleColor]

        let settingsButton = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(settingsButtonTapped(_:)))
        settingsButton.tintColor = .titleColor
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width-60, height: 70)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        guard let collectionView = collectionView else { return }
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .backgroundColor

        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)
    }

    private func category(forIndexPath indexPath: IndexPath) -> QuizCategory? {
        let quizCategory = QuizCategory(rawValue: indexPath.row)
        return quizCategory
    }

    @objc func settingsButtonTapped(_ sender: UIBarButtonItem) {
        let viewController = SettingsViewController()
        let settingsNavigationController = UINavigationController(rootViewController: viewController)
        settingsNavigationController.isModalInPresentation = true
        present(settingsNavigationController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = category(forIndexPath: indexPath) else {
            print("Unable to find category for index path: \(indexPath)")
            return
        }
        let viewController = QuizViewController()
        viewController.quizRoundManager = quizRoundManager
        viewController.category = category
        let quizNavigationController = UINavigationController(rootViewController: viewController)
        quizNavigationController.isModalInPresentation = true
        present(quizNavigationController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuizCategory.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCell
        let values: [String] = QuizCategory.allCases.map { $0.title }
        cell.label.text = values[indexPath.item]
        return cell
    }
}

