//
//  ViewController.swift
//  EventPlannerApp
//
//  Created by Varun on 02/11/25.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Bottom card IBOutlets (connect these in Interface Builder)
    @IBOutlet weak var bottomCardOuterView: UIView?
    @IBOutlet weak var bottomCardInnerView: UIView?
    @IBOutlet weak var bottomCardStackView: UIStackView?
    @IBOutlet weak var signUpButton: UIButton!

    // Connect this in Interface Builder
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet var googleStackView: UIStackView!
    @IBOutlet var appleStackView: UIStackView!
    // MARK: - IBOutlets (connect these in Interface Builder)
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var rememberMeButton: UIButton!
    @IBAction func rememberMeTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
            // configurationUpdateHandler will update the image for us
            sender.accessibilityValue = sender.isSelected ? "On" : "Off"
            UserDefaults.standard.set(sender.isSelected, forKey: "rememberMe")
    }
    
    @IBAction func forgotPasswordTyped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Forgot Password", message: "Password reset flow coming soon.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let signupVC = sb.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
            navigationController?.pushViewController(signupVC, animated: true)
    }
    // MARK: - Basic layout config
       private let textFieldVerticalPadding: CGFloat = 8
       private let textFieldHorizontalPadding: CGFloat = 12
       private let textFieldContainerCornerRadius: CGFloat = 8
       private let socialButtonHeight: CGFloat = 52

       // Keep references so we can adjust shadows/height
       private var emailContainer: UIView?
       private var passwordContainer: UIView?
       private var googleButtonHeightConstraint: NSLayoutConstraint?
       private var appleButtonHeightConstraint: NSLayoutConstraint?

       // MARK: - Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()

           // Safety: ensure required IBOutlets exist
           guard titleLabel != nil, stackView != nil else {
               print("⚠️ Missing required outlets (titleLabel/stackView). Connect them in Interface Builder.")
               return
           }

           // Wrap text fields into subtle shadow containers (if not already wrapped)
           emailContainer = wrapTextFieldInContainerIfNeeded(emailTextField)
           passwordContainer = wrapTextFieldInContainerIfNeeded(passwordTextField)

           stackView.spacing = 16

           // Visual configuration for text fields
           emailTextField.borderStyle = .none
           passwordTextField.borderStyle = .none
           emailTextField.backgroundColor = .clear
           passwordTextField.backgroundColor = .clear

           configureRememberMeButton()

           // Social rows
           applyOutlinedSocialStyle(googleStackView)
           applyOutlinedSocialStyle(appleStackView)
           setSocialStacksHeight(socialButtonHeight)
           addTapHandlerToStack(googleStackView, action: #selector(signInWithGoogleTapped(_:)))
           addTapHandlerToStack(appleStackView, action: #selector(signInWithAppleTapped(_:)))

           // Bottom card
           applyBottomCardStyle()
           styleSignUpButton()
       }

       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()

           // Update shadow paths for textfield containers if present
           if let c = emailContainer {
               c.layer.shadowPath = UIBezierPath(roundedRect: c.bounds, cornerRadius: c.layer.cornerRadius).cgPath
           }
           if let c = passwordContainer {
               c.layer.shadowPath = UIBezierPath(roundedRect: c.bounds, cornerRadius: c.layer.cornerRadius).cgPath
           }

           // Update outer card shadow path
           if let outer = bottomCardOuterView {
               outer.layer.shadowPath = UIBezierPath(roundedRect: outer.bounds, cornerRadius: outer.layer.cornerRadius).cgPath
           }
       }

       // MARK: - Text field container helper
       private func wrapTextFieldInContainerIfNeeded(_ textField: UITextField) -> UIView? {
           guard let parentStack = stackView else { return nil }

           // If already wrapped (superview is not the stack view), return that container
           if let superview = textField.superview, superview !== parentStack {
               return superview
           }

           // Create container view
           let container = UIView()
           container.translatesAutoresizingMaskIntoConstraints = false
           container.backgroundColor = UIColor(white: 0.96, alpha: 1)
           container.layer.cornerRadius = textFieldContainerCornerRadius

           // Shadow
           container.layer.masksToBounds = false
           container.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
           container.layer.shadowOpacity = 0.18
           container.layer.shadowRadius = 6
           container.layer.shadowOffset = CGSize(width: 0, height: 3)

           // Replace textField in stack with container
           if let index = parentStack.arrangedSubviews.firstIndex(of: textField) {
               parentStack.removeArrangedSubview(textField)
               textField.removeFromSuperview()
               parentStack.insertArrangedSubview(container, at: index)
           } else {
               parentStack.addArrangedSubview(container)
           }

           container.addSubview(textField)
           textField.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: textFieldHorizontalPadding),
               textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -textFieldHorizontalPadding),
               textField.topAnchor.constraint(equalTo: container.topAnchor, constant: textFieldVerticalPadding),
               textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -textFieldVerticalPadding),
               container.heightAnchor.constraint(equalToConstant: 44) // stable height for both fields
           ])

           return container
       }

       // MARK: - Remember me styling
       private func configureRememberMeButton() {
           guard let btn = rememberMeButton else { return }
           var config = UIButton.Configuration.plain()
           config.image = UIImage(systemName: "square")
           config.baseForegroundColor = .systemGray
           config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
           btn.configuration = config
           btn.configurationUpdateHandler = { button in
               var updated = button.configuration
               updated?.image = button.isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
               button.configuration = updated
           }
           btn.accessibilityLabel = "Remember Me"
           btn.accessibilityValue = btn.isSelected ? "On" : "Off"
       }

       // MARK: - Social row styling
       private func applyOutlinedSocialStyle(_ stack: UIStackView?) {
           guard let stack = stack else { return }
           stack.translatesAutoresizingMaskIntoConstraints = false
           stack.backgroundColor = .white
           stack.layer.borderWidth = 1
           stack.layer.borderColor = UIColor.black.withAlphaComponent(0.85).cgColor
           stack.layer.masksToBounds = true
           stack.alignment = .center
           stack.isLayoutMarginsRelativeArrangement = true
           stack.layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)

           for sub in stack.arrangedSubviews {
               if let iv = sub as? UIImageView {
                   iv.contentMode = .scaleAspectFit
                   iv.translatesAutoresizingMaskIntoConstraints = false
                   NSLayoutConstraint.activate([iv.widthAnchor.constraint(equalToConstant: 28),
                                                iv.heightAnchor.constraint(equalToConstant: 28)])
               } else if let btn = sub as? UIButton {
                   btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                   btn.setTitleColor(.black, for: .normal)
                   btn.contentHorizontalAlignment = .left
                   btn.isUserInteractionEnabled = false
               }
           }
       }

       private func setSocialStacksHeight(_ height: CGFloat) {
           if let google = googleStackView {
               googleButtonHeightConstraint?.isActive = false
               googleButtonHeightConstraint = google.heightAnchor.constraint(equalToConstant: height)
               googleButtonHeightConstraint?.isActive = true
               google.layer.cornerRadius = height / 2
           }
           if let apple = appleStackView {
               appleButtonHeightConstraint?.isActive = false
               appleButtonHeightConstraint = apple.heightAnchor.constraint(equalToConstant: height)
               appleButtonHeightConstraint?.isActive = true
               apple.layer.cornerRadius = height / 2
           }
       }

       // MARK: - Gesture helpers for social rows
       private func addTapHandlerToStack(_ stack: UIStackView?, action: Selector) {
           guard let stack = stack else { return }
           // remove existing UITapGestureRecognizer to avoid duplicates
           stack.gestureRecognizers?.forEach {
               if $0 is UITapGestureRecognizer { stack.removeGestureRecognizer($0) }
           }
           let t = UITapGestureRecognizer(target: self, action: action)
           stack.addGestureRecognizer(t)
       }

       @objc private func signInWithGoogleTapped(_ sender: UITapGestureRecognizer) {
           // feedback
           animateStackPress(googleStackView)
           let alert = UIAlertController(title: "Google Sign-In", message: "Google sign-in tapped.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default)); present(alert, animated: true)
       }

       @objc private func signInWithAppleTapped(_ sender: UITapGestureRecognizer) {
           animateStackPress(appleStackView)
           let alert = UIAlertController(title: "Apple Sign-In", message: "Apple sign-in tapped.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default)); present(alert, animated: true)
       }

       private func animateStackPress(_ stack: UIStackView?) {
           guard let s = stack else { return }
           UIView.animate(withDuration: 0.12, animations: {
               s.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
               s.alpha = 0.95
           }) { _ in
               UIView.animate(withDuration: 0.12) {
                   s.transform = .identity
                   s.alpha = 1.0
               }
           }
       }

       // MARK: - Bottom card styling (outer + inner view)
       private func applyBottomCardStyle() {
           guard let outer = bottomCardOuterView, let inner = bottomCardInnerView else { return }
           outer.layer.cornerRadius = 12
           outer.backgroundColor = .white
           outer.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
           outer.layer.shadowOpacity = 0.3
           outer.layer.shadowRadius = 8
           outer.layer.shadowOffset = CGSize(width: 0, height: 5)
           outer.layer.masksToBounds = false

           inner.layer.cornerRadius = 12
           inner.backgroundColor = UIColor(white: 0.99, alpha: 1)
           inner.layer.masksToBounds = true
       }

       private func styleSignUpButton() {
           guard let button = signUpButton else { return }
           button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
           button.setTitleColor(.systemBlue, for: .normal)
           button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
           button.layer.cornerRadius = 8
       }
}
