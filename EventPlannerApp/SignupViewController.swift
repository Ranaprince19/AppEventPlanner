import UIKit

final class SignUpViewController: UIViewController {

    // MARK: - IBOutlets
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

    // MARK: - Actions
    @IBAction func nextTapped(_ sender: UIButton) {
        // Validation
        guard
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
            let pass  = passwordTextField.text, !pass.isEmpty,
            let cpass = confirmPasswordTextField.text, !cpass.isEmpty,
            let name  = fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty
        else {
            showAlert("Missing info", "Please fill all fields.")
            return
        }

        guard pass == cpass else {
            showAlert("Passwords mismatch", "Please make sure passwords match.")
            return
        }

        // Instantiate and push Business VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BuiisnessViewController") as? BuiisnessViewController else {
            assertionFailure("Storyboard ID not set correctly on BuiisnessViewController")
            return
        }

        vc.signupName = name
        vc.signupEmail = email

        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            present(vc, animated: true)
        }
    }

    // MARK: - Helpers
    private func showAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func styleTextFields() {
        let tfs: [UITextField] = [emailTextField, passwordTextField, confirmPasswordTextField, fullNameTextField]
        for tf in tfs {
            tf.borderStyle = .none
            tf.backgroundColor = .white
            tf.layer.cornerRadius = 10
            tf.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
            tf.layer.shadowOpacity = 0.18
            tf.layer.shadowRadius = 6
            tf.layer.shadowOffset = CGSize(width: 0, height: 3)
            tf.tintColor = .systemPurple // change cursor color
            let pad = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
            tf.leftView = pad
            tf.leftViewMode = .always
        }

        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
    }

    private func styleNextButton() {
        nextButton.layer.cornerRadius = 24
        nextButton.backgroundColor = .systemPurple
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

    @objc private func endEditingNow() {
        view.endEditing(true)
    }
}
