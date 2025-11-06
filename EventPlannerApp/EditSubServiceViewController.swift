
import UIKit

final class EditSubserviceViewController: UIViewController {

    @IBOutlet weak var subcategoryField: UITextField!
    @IBOutlet weak var serviceField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
    }

    private func styleUI() {
        // round textfields
        [subcategoryField, serviceField, priceField].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.systemGray5.cgColor
            $0?.backgroundColor = .white
            $0?.setLeftPaddingPoints(12)
        }

        // save button style
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(red: 0.61, green: 0.30, blue: 1.0, alpha: 1.0)
        saveButton.setTitleColor(.white, for: .normal)
    }

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func saveTapped(_ sender: Any) {
        print("Save tapped")
        dismiss(animated: true)
    }
}

private extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
