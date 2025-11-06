import UIKit
import PhotosUI // remove if you don't want image picker; also remove related code below

final class AddSubserviceViewController: UIViewController {

    // MARK: - IBOutlets (connect these)
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rateField: UITextField!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Callback to parent
    var onSave: ((Subservice) -> Void)?

    // MARK: - State
    private var selectedUnit: String = "per event"
    private var pickedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureUnitMenu()
        configureImagePicker()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground

        [nameField, rateField].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.systemGray5.cgColor
            $0?.backgroundColor = .white
            $0?.setLeftPadding(12)
            $0?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        rateField.keyboardType = .decimalPad

        unitButton.layer.cornerRadius = 10
        unitButton.layer.borderWidth = 1
        unitButton.layer.borderColor = UIColor.systemGray5.cgColor
        unitButton.setTitle(selectedUnit, for: .normal)

        imagePreview.contentMode = .scaleAspectFill
        imagePreview.layer.cornerRadius = 12
        imagePreview.clipsToBounds = true
        imagePreview.image = UIImage(systemName: "photo")

        cancelButton.layer.cornerRadius = 24
        cancelButton.backgroundColor = UIColor(red: 0.83, green: 0.18, blue: 0.18, alpha: 1)
        cancelButton.setTitleColor(.white, for: .normal)

        saveButton.layer.cornerRadius = 24
        saveButton.backgroundColor = UIColor(red: 0.61, green: 0.30, blue: 1.0, alpha: 1)
        saveButton.setTitleColor(.white, for: .normal)
    }

    private func configureUnitMenu() {
        let items = ["per event", "per hour", "per day"]
        unitButton.showsMenuAsPrimaryAction = true
        unitButton.menu = UIMenu(children: items.map { title in
            UIAction(title: title) { [weak self] _ in
                self?.selectedUnit = title
                self?.unitButton.setTitle(title, for: .normal)
            }
        })
    }

    private func configureImagePicker() {
        imagePreview.isUserInteractionEnabled = true
        imagePreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
    }

    @objc private func pickImage() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    // MARK: - IBActions
    @IBAction func cancelTapped(_ sender: Any) { dismiss(animated: true) }

    @IBAction func saveTapped(_ sender: Any) {
        let name = (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let rate = Double(rateField.text ?? "") ?? 0
            let unit = unitButton.title(for: .normal) ?? "per event"

            guard !name.isEmpty else {
                print("⚠️ Please enter a sub-service name")
                return
            }

            // Create a new Subservice object
            let newSub = Subservice(name: name, rate: rate, unit: unit)

            // Call the callback closure
            onSave?(newSub)

            // Dismiss this screen
            dismiss(animated: true)
    }

    private func shake(_ v: UIView) {
        let a = CAKeyframeAnimation(keyPath: "transform.translation.x")
        a.values = [0, -8, 8, -6, 6, -3, 3, 0]; a.duration = 0.3
        v.layer.add(a, forKey: "shake")
    }
}

// MARK: - PHPicker delegate
extension AddSubserviceViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let r = results.first else { return }
        r.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] obj, _ in
            DispatchQueue.main.async {
                self?.pickedImage = obj as? UIImage
                self?.imagePreview.image = self?.pickedImage
            }
        }
    }
}

// MARK: - padding helper
private extension UITextField {
    func setLeftPadding(_ value: CGFloat) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 1))
        leftView = v; leftViewMode = .always
    }
}

