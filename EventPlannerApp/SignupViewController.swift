//
//  SignupViewController.swift
//  EventPlannerApp
//
//  Created by Varun on 03/11/25.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets (connect these in Storyboard)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Create your Account"
        styleTextFields()
        styleNextButton()
        setupKeyboardDismiss()
    }

    // MARK: - Styling Helpers
    private func styleTextFields() {
        let textFields: [UITextField?] = [emailTextField, passwordTextField, confirmPasswordTextField, fullNameTextField]

        for tfOpt in textFields {
            guard let tf = tfOpt else { continue }
            tf.borderStyle = .none
            tf.backgroundColor = .white
            tf.layer.cornerRadius = 10
            tf.layer.masksToBounds = false
            tf.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
            tf.layer.shadowOpacity = 0.18
            tf.layer.shadowRadius = 6
            tf.layer.shadowOffset = CGSize(width: 0, height: 3)

            // left padding
            let pad = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
            tf.leftView = pad
            tf.leftViewMode = .always

            // secure text for password fields
            if tf == passwordTextField || tf == confirmPasswordTextField {
                tf.isSecureTextEntry = true
            }
        }
    }

    private func styleNextButton() {
        nextButton.layer.cornerRadius = 24
        nextButton.backgroundColor = UIColor.systemPurple
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        nextButton.layer.shadowColor = UIColor.purple.withAlphaComponent(0.28).cgColor
        nextButton.layer.shadowOpacity = 0.9
        nextButton.layer.shadowRadius = 6
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    // Dismiss keyboard when tapping outside
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func nextTapped(_ sender: UIButton) {
        // Simple validation example
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirm = confirmPasswordTextField.text, !confirm.isEmpty,
              let name = fullNameTextField.text, !name.isEmpty else {
            showAlert(title: "Missing info", message: "Please fill all fields.")
            return
        }

        guard password == confirm else {
            showAlert(title: "Passwords mismatch", message: "Please make sure passwords match.")
            return
        }

        // TODO: call your API / store account / go next
        showAlert(title: "Success", message: "Account created (demo).") { [weak self] in
            // If you presented modally, dismiss or pop
            self?.dismiss(animated: true)
        }
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(a, animated: true)
    }
}
