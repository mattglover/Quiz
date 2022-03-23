//
//  SettingsViewController.swift
//  Kwiz
//
//  Created by Megan Wynn on 21/10/2021.
//

import UIKit
import MessageUI
import StoreKit

class SettingsViewController: UIViewController {

    // MARK: - Private Properties
    private let defaults: UserDefaults = .standard
    private var quizRoundManager: QuizRoundResultsManager!

    // MARK: - UI Elements
    private var difficultyStackView = UIStackView()
    private var difficultyLabel = UILabel()
    private var difficultyControl = UISegmentedControl()
    private var additionalSettingsLabel = UILabel()
    private var rateMyAppButtonView = SettingsButtonView()
    private var clearDataButtonView = SettingsButtonView()
    private var emailButtonView = SettingsButtonView()
    private var additionalSettingsStackView = UIStackView()
    private var creditsStackView = UIStackView()
    private var creditsLabel = UILabel()
    private var creditsText = UILabel()
    private var versionLabel = UILabel()

    private var separator: UIView! {
        didSet {
            separator.layer.borderWidth = 1.0
            separator.layer.borderColor = UIColor.gray.cgColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .settingsBackgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.titleColor]
        let updateButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped(_:)))
        updateButton.tintColor = .titleColor
        navigationItem.rightBarButtonItem = updateButton

        let quizRoundPersistanceService = QuizRoundCoreDataPersistanceService()
        quizRoundManager = QuizRoundResultsManager(persistanceService: quizRoundPersistanceService)

        let tapClear = UITapGestureRecognizer(target: self, action: #selector(self.handleClearLeaderboard(_:)))
        let tapRate = UITapGestureRecognizer(target: self, action: #selector(self.handleRateApp(_:)))
        let tapEmail = UITapGestureRecognizer(target: self, action: #selector(self.handleEmailFeedback(_:)))
        rateMyAppButtonView.addGestureRecognizer(tapRate)
        clearDataButtonView.addGestureRecognizer(tapClear)
        emailButtonView.addGestureRecognizer(tapEmail)

        setupDifficultyStack()
        setupDifficultyControl()
        setupAdditionalSettingsStack()
        setupCreditsStack()
        setupVersionsLabel()
    }

    // MARK: - Setup
    private func setupDifficultyStack() {
        difficultyStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(difficultyStackView)

        difficultyLabel.text = "Difficulty"
        setupGenericLabel(label: difficultyLabel)
        difficultyStackView.addArrangedSubview(difficultyLabel)

        NSLayoutConstraint.activate([
            difficultyStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            difficultyStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width / 8),
            difficultyStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(view.frame.width / 8)),

            difficultyLabel.topAnchor.constraint(equalTo: difficultyStackView.topAnchor),
            difficultyLabel.leadingAnchor.constraint(equalTo: difficultyStackView.leadingAnchor),
            difficultyLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupDifficultyControl() {
        difficultyControl.insertSegment(withTitle: "Easy", at: 0, animated: false)
        difficultyControl.insertSegment(withTitle: "Medium", at: 1, animated: false)
        difficultyControl.insertSegment(withTitle: "Hard", at: 2, animated: false)
        difficultyControl.frame = CGRect(x: (view.frame.width - 300) / 2, y: 130, width: 300, height: 50)
        difficultyControl.selectedSegmentIndex = defaults.integer(forKey: "difficulty")
        difficultyControl.selectedSegmentTintColor = .primaryColor
        difficultyControl.backgroundColor = .secondaryColor
        difficultyControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        view.addSubview(difficultyControl)
    }

    private func setupAdditionalSettingsStack() {
        additionalSettingsStackView.translatesAutoresizingMaskIntoConstraints = false
        additionalSettingsStackView.axis = .vertical
        additionalSettingsStackView.spacing = 10
        view.addSubview(additionalSettingsStackView)

        separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        additionalSettingsStackView.addArrangedSubview(separator)

        additionalSettingsLabel.text = "Additional Settings"
        setupGenericLabel(label: additionalSettingsLabel)
        additionalSettingsStackView.addArrangedSubview(additionalSettingsLabel)

        rateMyAppButtonView.titleLabel.text = AdditionalSettings.rateApplication.title
        rateMyAppButtonView.imageView.image = .star
        clearDataButtonView.titleLabel.text = AdditionalSettings.clearLeaderboard.title
        clearDataButtonView.imageView.image = .bin
        emailButtonView.titleLabel.text = AdditionalSettings.emailFeedback.title
        emailButtonView.imageView.image = .email

        additionalSettingsStackView.addArrangedSubview(rateMyAppButtonView)
        additionalSettingsStackView.addArrangedSubview(emailButtonView)
        additionalSettingsStackView.addArrangedSubview(clearDataButtonView)

        NSLayoutConstraint.activate([
            additionalSettingsStackView.topAnchor.constraint(equalTo: difficultyControl.bottomAnchor, constant: 20),
            additionalSettingsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width / 8),
            additionalSettingsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(view.frame.width / 8)),

            separator.heightAnchor.constraint(equalToConstant: 1),

            additionalSettingsLabel.heightAnchor.constraint(equalToConstant: 40),
            rateMyAppButtonView.heightAnchor.constraint(equalToConstant: 50),
            emailButtonView.heightAnchor.constraint(equalToConstant: 50),
            clearDataButtonView.heightAnchor.constraint(equalToConstant: 50)
        ])

    }

    private func setupCreditsStack() {
        creditsStackView.translatesAutoresizingMaskIntoConstraints = false
        creditsStackView.axis = .vertical
        creditsStackView.spacing = 10
        view.addSubview(creditsStackView)

        separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        creditsStackView.addArrangedSubview(separator)

        creditsLabel.text = "Credits"
        setupGenericLabel(label: creditsLabel)
        creditsStackView.addArrangedSubview(creditsLabel)

        creditsText.text = "Kwiz was developed by Megan Wynn, an iOS developer based in the UK. \nI would like to thank willfry.co.uk for the kind permission in allowing me to use their quiz API. Please go and check it out - https://willfry.co.uk"
        creditsText.numberOfLines = 0
        creditsText.textColor = .titleColor
        creditsText.font = UIFont.systemFont(ofSize: 16)
        creditsStackView.addArrangedSubview(creditsText)

        NSLayoutConstraint.activate([
            creditsStackView.topAnchor.constraint(equalTo: clearDataButtonView.bottomAnchor, constant: 40),
            creditsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: view.frame.width / 8),
            creditsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(view.frame.width / 8)),

            separator.heightAnchor.constraint(equalToConstant: 1),
            creditsLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupVersionsLabel() {
        versionLabel.text = "v1.0.0"
        versionLabel.textColor = .lightGray
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(versionLabel)

        NSLayoutConstraint.activate([
            versionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.heightAnchor.constraint(equalToConstant: 50),
            versionLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupGenericLabel(label: UILabel) {
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .titleColor
    }

    // MARK: Objective C Functions
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        defaults.set(difficultyControl.selectedSegmentIndex, forKey: "difficulty")
        defaults.set(difficultyControl.titleForSegment(at: difficultyControl.selectedSegmentIndex)?.lowercased(), forKey: "difficultyTitle")
        dismiss(animated: true, completion: nil)
    }

    @objc func handleClearLeaderboard(_ sender: UITapGestureRecognizer? = nil) {
        quizRoundManager.clearAllData()
    }

    @objc func handleRateApp(_ sender: UITapGestureRecognizer? = nil) {
        rateApp()
    }

    @objc func handleEmailFeedback(_ sender: UITapGestureRecognizer? = nil) {
        presentEmailFeedback()
    }

    private func presentEmailFeedback() {
        let subject = "App Feedback - Kwiz"
        let replyAddress = "meg1207@hotmail.co.uk"

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([replyAddress])
            mail.setSubject(subject)
            present(mail, animated: true)
        } else {
            let alertController = UIAlertController(title: "Email Error", message: "Email not configured for this device", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }

    private func rateApp() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}