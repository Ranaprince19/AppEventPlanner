import UIKit

final class EventDetailsViewController: UIViewController {

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let eventNameCard = UIView()
    private let clientNameCard = UIView()
    private let locationCard = UIView()
    private let guestCountCard = UIView()
    private let budgetCard = UIView()

    private let startDateCard = UIView()
    private let endDateCard = UIView()
    private let dateRow = UIStackView()

    private let eventNameLabel = UILabel()
    private let clientNameLabel = UILabel()
    private let locationLabel = UILabel()
    private let guestCountLabel = UILabel()
    private let budgetLabel = UILabel()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()

    private let eventNameTextField = UITextField()
    private let clientNameTextField = UITextField()
    private let locationTextField = UITextField()
    private let guestCountTextField = UITextField()
    private let budgetTextField = UITextField()
    private let startDateTextField = UITextField()
    private let endDateTextField = UITextField()

    private let continueButton = UIButton(type: .system)

    private let startPicker = UIDatePicker()
    private let endPicker = UIDatePicker()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Event Details"

        setupScrollView()
        setupAllCards()
        setupDatePickers()
        setupContinueButton()

        // Prefill when the picker opens (nice UX)
        startDateTextField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
        endDateTextField.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
    }

    // MARK: - ScrollView
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.keyboardDismissMode = .interactive

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
    }

    // MARK: - Cards
    private func setupAllCards() {
        setupCard(card: eventNameCard, label: eventNameLabel, labelText: "Event Name",
                  textField: eventNameTextField, placeholder: "Enter The Event Name",
                  topAnchor: contentView.topAnchor, topConstant: 16)

        setupCard(card: clientNameCard, label: clientNameLabel, labelText: "Client Name",
                  textField: clientNameTextField, placeholder: "Enter the Client Name",
                  topAnchor: eventNameCard.bottomAnchor, topConstant: 16)

        setupCardWithTrailingButton(card: locationCard, label: locationLabel, labelText: "Location",
                                    textField: locationTextField, placeholder: "Search for Location",
                                    systemImage: "paperplane.fill",
                                    action: #selector(locationTapped),
                                    topAnchor: clientNameCard.bottomAnchor, topConstant: 16)

        setupCard(card: guestCountCard, label: guestCountLabel, labelText: "Guest Count",
                  textField: guestCountTextField, placeholder: "Enter the Number of Guests",
                  topAnchor: locationCard.bottomAnchor, topConstant: 16)

        setupCard(card: budgetCard, label: budgetLabel, labelText: "Budget",
                  textField: budgetTextField, placeholder: "₹1,00,000",
                  topAnchor: guestCountCard.bottomAnchor, topConstant: 16)

        // keyboards + delegate filters
        guestCountTextField.keyboardType = .numberPad
        budgetTextField.keyboardType = .numberPad
        guestCountTextField.delegate = self
        budgetTextField.delegate = self

        startDateTextField.delegate = self
        endDateTextField.delegate = self

        setupDateCards()
    }

    // Generic card
    private func setupCard(card: UIView, label: UILabel, labelText: String,
                           textField: UITextField, placeholder: String,
                           topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) {

        styleCard(card)
        contentView.addSubview(card)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        styleLabel(label, text: labelText)
        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16)
        ])

        styleTextField(textField, placeholder: placeholder)
        card.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        card.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12).isActive = true
    }

    // Card with interactive trailing button
    private func setupCardWithTrailingButton(card: UIView, label: UILabel, labelText: String,
                                             textField: UITextField, placeholder: String,
                                             systemImage: String, action: Selector,
                                             topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) {
        styleCard(card)
        contentView.addSubview(card)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        styleLabel(label, text: labelText)
        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16)
        ])

        styleTextField(textField, placeholder: placeholder)

        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 44))
        rightContainer.isUserInteractionEnabled = true
        let button = HitTestButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: systemImage), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = UIColor(white: 0.6, alpha: 1)
        // expand tap target
        button.hitTestPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        rightContainer.addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor, constant: -10),
            button.centerYAnchor.constraint(equalTo: rightContainer.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 22),
            button.heightAnchor.constraint(equalToConstant: 22)
        ])

        textField.rightView = rightContainer
        textField.rightViewMode = .always

        card.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        card.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12).isActive = true
    }

    private func styleCard(_ v: UIView) {
        v.backgroundColor = UIColor(white: 0.97, alpha: 1)
        v.layer.cornerRadius = 12
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.08
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.translatesAutoresizingMaskIntoConstraints = false
    }

    private func styleLabel(_ l: UILabel, text: String) {
        l.text = text
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .black
        l.translatesAutoresizingMaskIntoConstraints = false
    }

    private func styleTextField(_ tf: UITextField, placeholder: String) {
        tf.placeholder = placeholder
        tf.borderStyle = .none
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
        tf.font = .systemFont(ofSize: 15, weight: .regular)
        tf.textColor = UIColor(white: 0.4, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        tf.leftView = paddingView
        tf.leftViewMode = .always
    }

    // MARK: - Date row
    private func setupDateCards() {
        styleCard(startDateCard)
        styleCard(endDateCard)

        dateRow.axis = .horizontal
        dateRow.alignment = .fill
        dateRow.distribution = .fillEqually
        dateRow.spacing = 12
        dateRow.translatesAutoresizingMaskIntoConstraints = false

        dateRow.addArrangedSubview(startDateCard)
        dateRow.addArrangedSubview(endDateCard)

        contentView.addSubview(dateRow)
        NSLayoutConstraint.activate([
            dateRow.topAnchor.constraint(equalTo: budgetCard.bottomAnchor, constant: 16),
            dateRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        setupDateField(card: startDateCard, label: startDateLabel, labelText: "Start Date",
                       textField: startDateTextField, placeholder: "Select Date",
                       buttonAction: #selector(startIconTapped))

        setupDateField(card: endDateCard, label: endDateLabel, labelText: "End Date",
                       textField: endDateTextField, placeholder: "Select Date",
                       buttonAction: #selector(endIconTapped))

        startDateCard.bottomAnchor.constraint(equalTo: startDateTextField.bottomAnchor, constant: 12).isActive = true
        endDateCard.bottomAnchor.constraint(equalTo: endDateTextField.bottomAnchor, constant: 12).isActive = true

        dateRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
    }

    private func setupDateField(card: UIView, label: UILabel, labelText: String,
                                textField: UITextField, placeholder: String,
                                buttonAction: Selector) {
        styleLabel(label, text: labelText)
        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12)
        ])

        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
        textField.font = .systemFont(ofSize: 13, weight: .regular)
        textField.textColor = .systemPurple
        textField.translatesAutoresizingMaskIntoConstraints = false

        // left padding
        let left = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 36))
        textField.leftView = left
        textField.leftViewMode = .always

        // tappable calendar rightView
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 36))
        rightContainer.isUserInteractionEnabled = true
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "calendar"), for: .normal)
        btn.addTarget(self, action: buttonAction, for: .touchUpInside)
        btn.tintColor = UIColor(white: 0.6, alpha: 1)
        rightContainer.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor, constant: -8),
            btn.centerYAnchor.constraint(equalTo: rightContainer.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 18),
            btn.heightAnchor.constraint(equalToConstant: 18)
        ])
        textField.rightView = rightContainer
        textField.rightViewMode = .always

        card.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            textField.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    // MARK: - Pickers (simple & reliable)
    private func setupDatePickers() {
        startPicker.tag = 1
        endPicker.tag  = 2
        startPicker.datePickerMode = .date
        endPicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startPicker.preferredDatePickerStyle = .wheels
            endPicker.preferredDatePickerStyle = .wheels
        }
        startPicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        endPicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        startDateTextField.inputView = startPicker
        endDateTextField.inputView = endPicker

        // Toolbar with Cancel / Done
        startDateTextField.inputAccessoryView = makePickerToolbar(doneSelector: #selector(doneStart))
        endDateTextField.inputAccessoryView   = makePickerToolbar(doneSelector: #selector(doneEnd))
    }

    private func makePickerToolbar(doneSelector: Selector) -> UIToolbar {
        let t = UIToolbar()
        t.sizeToFit()
        t.items = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneSelector)
        ]
        return t
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        let f = DateFormatter(); f.dateStyle = .medium
        if sender.tag == 1 {
            startDateTextField.text = f.string(from: sender.date)
            startDateTextField.textColor = .systemPurple
        } else {
            endDateTextField.text = f.string(from: sender.date)
            endDateTextField.textColor = .systemPurple
        }
    }

    @objc private func cancelPicker() { view.endEditing(true) }

    @objc private func doneStart() {
        dateChanged(startPicker) // ensures update even if user didn't scroll
        view.endEditing(true)
    }

    @objc private func doneEnd() {
        dateChanged(endPicker)
        view.endEditing(true)
    }

    // Prefill when picker just opened
    @objc private func editingBegan(_ tf: UITextField) {
        let f = DateFormatter(); f.dateStyle = .medium
        if tf === startDateTextField {
            startDateTextField.text = f.string(from: startPicker.date)
            startDateTextField.textColor = .systemPurple
        } else if tf === endDateTextField {
            endDateTextField.text = f.string(from: endPicker.date)
            endDateTextField.textColor = .systemPurple
        }
    }

    // MARK: - Button Actions
    @objc private func locationTapped() {
        let alert = UIAlertController(title: "Set Location", message: "Type a place or address", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Search…"
            tf.text = self.locationTextField.text
            tf.autocapitalizationType = .words
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Use", style: .default, handler: { _ in
            let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.locationTextField.text = text
            self.locationTextField.becomeFirstResponder()
        }))
        present(alert, animated: true)
    }

    @objc private func startIconTapped() {
        startDateTextField.becomeFirstResponder()
        dateChanged(startPicker) // optional prefill/update
    }

    @objc private func endIconTapped() {
        endDateTextField.becomeFirstResponder()
        dateChanged(endPicker) // optional prefill/update
    }

    // MARK: - Continue
    private func setupContinueButton() {
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        continueButton.layer.cornerRadius = 28
        continueButton.clipsToBounds = true
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let g = CAGradientLayer()
        g.colors = [
            UIColor(red: 0.58, green: 0.27, blue: 0.93, alpha: 1).cgColor,
            UIColor(red: 0.48, green: 0.20, blue: 0.88, alpha: 1).cgColor
        ]
        g.startPoint = CGPoint(x: 0, y: 0.5)
        g.endPoint = CGPoint(x: 1, y: 0.5)
        g.frame = continueButton.bounds
        g.cornerRadius = 28
        continueButton.layer.insertSublayer(g, at: 0)
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let bottomPadding = view.safeAreaInsets.bottom + 80
        scrollView.contentInset.bottom = bottomPadding
        scrollView.verticalScrollIndicatorInsets.bottom = bottomPadding
    }

    @objc private func continueTapped() {
        let vc = ConfirmationViewController()
        vc.eventTitle = eventNameTextField.text ?? ""
        vc.eventDate = startPicker.date
        vc.eventLocation = locationTextField.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Delegates / Validators
extension EventDetailsViewController: UITextFieldDelegate {

    // IMPORTANT: no recursive calls here
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Date fields: just prefill (if empty) and allow editing
        if textField === startDateTextField || textField === endDateTextField {
            let f = DateFormatter(); f.dateStyle = .medium
            if textField === startDateTextField {
                if (startDateTextField.text ?? "").isEmpty {
                    startDateTextField.text = f.string(from: startPicker.date)
                    startDateTextField.textColor = .systemPurple
                }
            } else {
                if (endDateTextField.text ?? "").isEmpty {
                    endDateTextField.text = f.string(from: endPicker.date)
                    endDateTextField.textColor = .systemPurple
                }
            }
            return true
        }
        return true
    }

    // Digit-only inputs for Guest Count and Budget
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // Always allow backspace
        if string.isEmpty { return true }

        if textField === guestCountTextField || textField === budgetTextField {
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        }

        // Do not allow manual edits for date fields
        if textField === startDateTextField || textField === endDateTextField {
            return false
        }
        return true
    }
}

// Expand tap target for the right-view buttons (clean version)
final class HitTestButton: UIButton {
    // Positive values expand the tappable area
    var hitTestPadding: UIEdgeInsets = .zero
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let larger = bounds.inset(by: UIEdgeInsets(top: -hitTestPadding.top,
                                                   left: -hitTestPadding.left,
                                                   bottom: -hitTestPadding.bottom,
                                                   right: -hitTestPadding.right))
        return larger.contains(point)
    }
}
