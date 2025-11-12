//
//  BuiisnessViewController.swift
//  EventPlannerApp
//

import UIKit

// MARK: - Cursor-free text field (no caret, no selection handles, no edit menu)
final class NoCaretTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect { .zero }
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool { false }
}

final class BuiisnessViewController: UIViewController {

    // MARK: - Data passed from SignUp
    var signupName: String?
    var signupEmail: String?

    // MARK: - IBOutlets
    @IBOutlet weak var businessTitle: UILabel!
    @IBOutlet weak var businessSubtitle: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessNameTextField: UITextField!

    // Use the subclass here so IB can connect directly if you set the class in storyboard
    @IBOutlet weak var buisnessAddressLabel: UILabel!
    @IBOutlet weak var buisnessAddressTextField: NoCaretTextField!

    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var aboutusLabel: UILabel!
    @IBOutlet weak var aboutusTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismiss()

        if let name = signupName, !name.isEmpty {
            navigationItem.title = "\(name)’s Business"
        } else {
            navigationItem.title = "Business Profile"
        }

        // Avoid any field auto-focusing on first show
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func nextButtons(_ sender: Any) {
        guard
            let name = businessNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty,
            let addr = buisnessAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !addr.isEmpty
        else {
            showAlert("Missing info", "Please enter Business Name and Address.")
            return
        }

        // TODO: Persist/send profile, then continue your flow
        showAlert("Saved", "Business profile captured.") { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }

    // MARK: - UI setup
    private func setupUI() {
        // Common styling for all text fields
        let fields: [UITextField?] = [
            businessNameTextField,
            buisnessAddressTextField, // subclass; still styles like a normal field
            websiteTextField,
            aboutusTextField
        ]

        for tf in fields.compactMap({ $0 }) {
            tf.borderStyle = .none
            tf.backgroundColor = .white
            tf.layer.cornerRadius = 10
            tf.layer.masksToBounds = false
            tf.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
            tf.layer.shadowOpacity = 0.18
            tf.layer.shadowRadius = 6
            tf.layer.shadowOffset = CGSize(width: 0, height: 3)

            // Left padding
            let pad = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
            tf.leftView = pad
            tf.leftViewMode = .always

            // Clean typing look
            tf.autocorrectionType = .no
            tf.spellCheckingType = .no
            tf.smartDashesType = .no
            tf.smartQuotesType = .no
            tf.smartInsertDeleteType = .no
        }

        // Website field config
        websiteTextField?.keyboardType = .URL
        websiteTextField?.autocapitalizationType = .none

        // If you also want NO visible caret on other fields, uncomment below:
        // [businessNameTextField, websiteTextField, aboutusTextField].forEach { $0?.tintColor = .clear }

        // Button style
        nextButton.layer.cornerRadius = 24
        nextButton.backgroundColor = .systemPurple
        nextButton.setTitle("Continue", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        nextButton.layer.shadowColor = UIColor.purple.withAlphaComponent(0.28).cgColor
        nextButton.layer.shadowOpacity = 0.9
        nextButton.layer.shadowRadius = 6
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingNow))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func endEditingNow() { view.endEditing(true) }

    // MARK: - Alerts
    private func showAlert(_ title: String, _ msg: String, onOK: (() -> Void)? = nil) {
        let a = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default) { _ in onOK?() })
        present(a, animated: true)
    }
}
