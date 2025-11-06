import UIKit

class ViewController3: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var purpleCardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serviceTextField: UITextField!
    @IBOutlet weak var subServicesLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Data
    var subServices: [Subservice] = [] {
        didSet { tableView.reloadData(); updateEmptyState() }
    }

    private var emptyStateLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        updateEmptyState()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Purple card styling
        purpleCardView.layer.cornerRadius = 18
        purpleCardView.layer.shadowColor = UIColor.black.cgColor
        purpleCardView.layer.shadowOpacity = 0.12
        purpleCardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        purpleCardView.layer.shadowRadius = 10
        purpleCardView.backgroundColor = UIColor(red: 138/255, green: 73/255, blue: 246/255, alpha: 1)

        // Title label
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        // Text field styling
        serviceTextField.backgroundColor = .white
        serviceTextField.layer.cornerRadius = 10
        serviceTextField.placeholder = "Enter Service Name"
        serviceTextField.textAlignment = .center
        serviceTextField.font = .systemFont(ofSize: 18)

        // Buttons
        closeButton.tintColor = .black
        addButton.tintColor = .black
        addButton.layer.cornerRadius = 18

        // Sub-services label
        subServicesLabel.font = .boldSystemFont(ofSize: 20)
        subServicesLabel.textColor = UIColor(red: 32/255, green: 42/255, blue: 52/255, alpha: 1)
    }

    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Empty state label
        emptyStateLabel = UILabel()
        emptyStateLabel.text = "No Sub-Services found"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = .systemFont(ofSize: 18)
        emptyStateLabel.textColor = UIColor(white: 0.45, alpha: 1)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(emptyStateLabel)
        tableView.backgroundView = containerView

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    private func updateEmptyState() {
        emptyStateLabel.isHidden = !subServices.isEmpty
    }

    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        // Open the Add Subservice screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddSubserviceVC") as! AddSubserviceViewController

        // Sheet presentation style
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        // When user saves a new subservice
        vc.onSave = { [weak self] newSub in
            guard let self = self else { return }
            self.subServices.append(newSub)
        }

        present(vc, animated: true)
    }
}

// MARK: - TableView
extension ViewController3: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subServices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = subServices[indexPath.row]
        cell.textLabel?.text = "\(item.name) — ₹\(Int(item.rate)) (\(item.unit))"
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subServices.remove(at: indexPath.row)
        }
    }
}

